import 'dart:convert';

import 'package:inspecciones_llantas/core/network/api_client.dart';
import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/test_database.dart';
import '../helpers/fixtures.dart';

/// Servidor simulado: registra cada petición y responde con [responder].
class ServidorFalso {
  final List<http.Request> peticiones = [];
  http.Response Function(http.Request) responder;

  ServidorFalso(this.responder);

  MockClient get cliente => MockClient((request) async {
        peticiones.add(request);
        return responder(request);
      });
}

http.Response jsonResponse(Object body, [int status = 200]) => http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

void main() {
  late AppDatabase db;

  setUp(() {
    db = crearBaseDeDatosEnMemoria();
    ApiConfig.baseUrl = 'http://servidor-test:8000';
    ApiConfig.apiKey = 'llave-test';
  });
  tearDown(() => db.close());

  SyncService crearServicio(ServidorFalso servidor) => SyncService(db, ApiClient(client: servidor.cliente));

  group('Descarga (syncPull)', () {
    test('guarda los datos del servidor y la fecha de sincronización del servidor', () async {
      final servidor = ServidorFalso((_) => jsonResponse(respuestaDescarga()));

      await crearServicio(servidor).syncPull();

      expect(await db.select(db.clientes).get(), hasLength(1));
      expect(await db.select(db.vehiculos).get(), hasLength(1));
      expect(await db.select(db.inspeccionLlantas).get(), hasLength(1));

      final ultimaSync = await db.syncDataDao.getLastSuccessfulSync();
      expect(ultimaSync.isAtSameMomentAs(DateTime.utc(2026, 5, 10, 15, 30)), isTrue);
    });

    test('lo descargado no queda marcado como pendiente de envío', () async {
      final servidor = ServidorFalso((_) => jsonResponse(respuestaDescarga()));
      await crearServicio(servidor).syncPull();

      expect(await db.vehiculosDao.obtenerPendientesSync(), isEmpty);
      expect(await db.inspeccionLlantasDao.obtenerPendientesSync(), isEmpty);
    });

    test('envía la API Key y la fecha de la última sincronización', () async {
      final servidor = ServidorFalso((_) => jsonResponse(respuestaDescarga()));
      await crearServicio(servidor).syncPull();

      final peticion = servidor.peticiones.single;
      expect(peticion.method, 'GET');
      expect(peticion.url.path, '/mobile/sync/download');
      expect(peticion.headers['X-API-KEY'], 'llave-test');
      expect(peticion.url.queryParameters['ultima_sincronizacion'], '1970-01-01T00:00:00.000Z');
    });

    test('la segunda descarga es incremental desde la fecha del servidor', () async {
      final servidor = ServidorFalso((_) => jsonResponse(respuestaDescarga()));
      final servicio = crearServicio(servidor);

      await servicio.syncPull();
      await servicio.syncPull();

      expect(servidor.peticiones.last.url.queryParameters['ultima_sincronizacion'], '2026-05-10T15:30:00.000Z');
    });

    test('si los conteos no coinciden no guarda nada (rollback)', () async {
      final respuesta = respuestaDescarga();
      (respuesta['metadata'] as Map)['counts']['inspeccion_llantas'] = 5;
      final servidor = ServidorFalso((_) => jsonResponse(respuesta));

      await expectLater(crearServicio(servidor).syncPull(), throwsException);

      expect(await db.select(db.clientes).get(), isEmpty);
      expect(await db.syncDataDao.getLastSuccessfulSync(), DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('un error HTTP se propaga sin modificar la base local', () async {
      final servidor = ServidorFalso((_) => http.Response('{"detail":"forbidden"}', 403));

      await expectLater(crearServicio(servidor).syncPull(), throwsException);
      expect(await db.select(db.clientes).get(), isEmpty);
    });
  });

  group('Envío (enviarDatosAlServidor)', () {
    Future<(String finalizada, String enCurso)> prepararInspecciones() async {
      final base = await sembrarClienteYVehiculo(db);
      final dao = db.inspeccionesDao;
      final finalizada = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Finalizada', fechaInspeccion: DateTime(2026, 5, 10));
      final enCurso = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'En curso', fechaInspeccion: DateTime(2026, 5, 11));

      for (final inspId in [finalizada, enCurso]) {
        await db.inspeccionLlantasDao.guardarLlanta(
          clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
          codigoLlanta: 'A-1', posicion: 1, presion: 32, medidaExt: 20, nombreMarca: 'Taurex',
          fechaMontaje: DateTime(2025, 1, 15),
        );
      }
      await dao.finalizarInspeccion(finalizada);
      return (finalizada, enCurso);
    }

    test('solo envía las inspecciones FINALIZADAS, con conteos coherentes', () async {
      final (finalizada, _) = await prepararInspecciones();
      final servidor = ServidorFalso((_) => jsonResponse({'status': 'success'}));

      await crearServicio(servidor).enviarDatosAlServidor();

      final peticion = servidor.peticiones.single;
      expect(peticion.method, 'POST');
      expect(peticion.url.path, '/mobile/sync/send');
      expect(peticion.headers['X-API-KEY'], 'llave-test');

      final body = jsonDecode(peticion.body) as Map<String, dynamic>;
      expect((body['inspecciones'] as List).map((i) => i['id']), [finalizada]);
      expect(body['inspeccion_llantas'], hasLength(1));
      expect(body['inspeccion_vehiculos'], hasLength(1));

      final counts = body['metadata']['counts'] as Map<String, dynamic>;
      for (final clave in ['variables', 'vehiculos', 'inspecciones', 'inspeccion_vehiculos', 'inspeccion_llantas']) {
        expect(counts[clave], (body[clave] as List).length, reason: clave);
      }
    });

    test('serializa con el formato que espera la API', () async {
      await prepararInspecciones();
      final servidor = ServidorFalso((_) => jsonResponse({'status': 'success'}));
      await crearServicio(servidor).enviarDatosAlServidor();

      final body = jsonDecode(servidor.peticiones.single.body) as Map<String, dynamic>;
      final llanta = body['inspeccion_llantas'][0] as Map<String, dynamic>;
      final inspeccion = body['inspecciones'][0] as Map<String, dynamic>;
      final variable = (body['variables'] as List).first as Map<String, dynamic>;

      expect(inspeccion['fecha_revision'], '2026-05-10'); // Fecha sin hora
      expect(inspeccion['estado'], 'FINALIZADO');
      expect(llanta['fecha_montaje'], '2025-01-15');
      expect(llanta['presion'], 32.0);
      expect(llanta['created_at'], endsWith('Z')); // Timestamps en UTC
      expect(variable.keys, containsAll(['id', 'cliente_id', 'tipo_variable', 'nombre', 'created_at']));
    });

    test('tras un envío exitoso los registros quedan sincronizados', () async {
      final (_, enCurso) = await prepararInspecciones();
      final servidor = ServidorFalso((_) => jsonResponse({'status': 'success'}));

      await crearServicio(servidor).enviarDatosAlServidor();

      final pendientes = await db.inspeccionesDao.obtenerPendientesSync();
      expect(pendientes.map((i) => i.id), [enCurso], reason: 'La inspección en curso sigue pendiente');
      expect(await db.vehiculosDao.obtenerPendientesSync(), isEmpty);
    });

    test('si el servidor falla los registros siguen pendientes para reintentar', () async {
      await prepararInspecciones();
      final servidor = ServidorFalso((_) => http.Response('error', 500));

      await expectLater(crearServicio(servidor).enviarDatosAlServidor(), throwsException);

      final pendientes = await db.inspeccionesDao.obtenerPendientesSync();
      expect(pendientes, hasLength(2));
    });

    test('sin datos pendientes no hace ninguna petición', () async {
      final servidor = ServidorFalso((_) => jsonResponse({'status': 'success'}));
      await crearServicio(servidor).enviarDatosAlServidor();
      expect(servidor.peticiones, isEmpty);
    });
  });
}
