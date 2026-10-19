import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = crearBaseDeDatosEnMemoria());
  tearDown(() => db.close());

  group('Catálogo de variables del cliente', () {
    test('crea la variable en mayúsculas y la marca como pendiente de envío', () async {
      await sembrarClienteYVehiculo(db);
      final id = await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: 'cliente-1',
        tipoEnum: TipoVariableEnum.MarcaLlata,
        nombreProporcionado: '  taurex ',
      );

      final variable = await (db.select(db.clienteVariables)..where((t) => t.id.equals(id))).getSingle();
      expect(variable.nombre, 'TAUREX');
      expect(variable.pendienteSync, isTrue);
      expect(variable.creadaLocal, isTrue);
    });

    test('reutiliza una variable existente sin importar mayúsculas', () async {
      await sembrarClienteYVehiculo(db);
      final dao = db.clienteVariablesDao;
      final id1 = await dao.obtenerOCrearVariable(
          clienteId: 'cliente-1', tipoEnum: TipoVariableEnum.MarcaLlata, nombreProporcionado: 'Taurex');
      final id2 = await dao.obtenerOCrearVariable(
          clienteId: 'cliente-1', tipoEnum: TipoVariableEnum.MarcaLlata, nombreProporcionado: 'TAUREX');

      expect(id2, id1);
    });

    test('si recibe un ID lo devuelve sin crear nada', () async {
      final id = await db.clienteVariablesDao.obtenerOCrearVariable(
          clienteId: 'cliente-1', tipoEnum: TipoVariableEnum.TipoLlanta, idProporcionado: 'id-existente');

      expect(id, 'id-existente');
      expect(await db.select(db.clienteVariables).get(), isEmpty);
    });

    test('sin ID ni nombre lanza ArgumentError', () {
      expect(
        () => db.clienteVariablesDao.obtenerOCrearVariable(
            clienteId: 'cliente-1', tipoEnum: TipoVariableEnum.TipoLlanta, nombreProporcionado: '  '),
        throwsArgumentError,
      );
    });

    test('verificarNuevasVariables avisa solo de los valores que no existen', () async {
      await sembrarClienteYVehiculo(db); // Crea MONTACARGAS y NORVIK MX-30
      final nuevas = await db.clienteVariablesDao.verificarNuevasVariables(
        clienteId: 'cliente-1',
        nombreTipoVehiculo: 'montacargas',
        nombreMarcaLlanta: 'Orlyn',
      );

      expect(nuevas, ['Marca de Llanta: "ORLYN"']);
    });
  });

  group('Inspecciones', () {
    test('una inspección nueva empieza en PENDIENTE', () async {
      final base = await sembrarClienteYVehiculo(db);
      final id = await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda mayo', fechaInspeccion: DateTime(2026, 5, 10));

      final inspeccion = await (db.select(db.inspecciones)..where((t) => t.id.equals(id))).getSingle();
      expect(inspeccion.estado, 'PENDIENTE');
      expect(inspeccion.pendienteSync, isTrue);
    });

    test('guardar dos veces la misma posición actualiza en lugar de duplicar', () async {
      final base = await sembrarClienteYVehiculo(db);
      final inspId = await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda', fechaInspeccion: DateTime(2026, 5, 10));

      final id1 = await db.inspeccionLlantasDao.guardarLlanta(
        clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
        codigoLlanta: 'A-1', posicion: 1, presion: 30, nombreMarca: 'Taurex',
      );
      final id2 = await db.inspeccionLlantasDao.guardarLlanta(
        clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
        codigoLlanta: 'A-1', posicion: 1, presion: 34, nombreMarca: 'Taurex',
      );

      final llantas = await db.inspeccionLlantasDao
          .getLlantasDeVehiculoEnInspeccion(inspeccionId: inspId, vehiculoId: base.vehiculoId);
      expect(id2, id1);
      expect(llantas, hasLength(1));
      expect(llantas.single.presion, 34);
      expect(llantas.single.nombreMarca, 'TAUREX');
    });

    test('guardarInspeccionVehiculo actualiza el registro existente', () async {
      final base = await sembrarClienteYVehiculo(db);
      final inspId = await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda', fechaInspeccion: DateTime(2026, 5, 10));
      final dao = db.inspeccionVehiculosDao;

      final id1 = await dao.guardarInspeccionVehiculo(inspeccionId: inspId, vehiculoId: base.vehiculoId, horometro: 100);
      final id2 = await dao.guardarInspeccionVehiculo(inspeccionId: inspId, vehiculoId: base.vehiculoId, horometro: 150);

      expect(id2, id1);
      final registro = await dao.getInspeccionVehiculo(inspeccionId: inspId, vehiculoId: base.vehiculoId);
      expect(registro!.horometro, 150);
    });

    test('finalizar crea el registro del vehículo si faltaba y cambia el estado', () async {
      final base = await sembrarClienteYVehiculo(db);
      final inspId = await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda', fechaInspeccion: DateTime(2026, 5, 10));
      await db.inspeccionLlantasDao.guardarLlanta(
        clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
        codigoLlanta: 'A-1', posicion: 1,
      );

      await db.inspeccionesDao.finalizarInspeccion(inspId);

      final inspeccion = await (db.select(db.inspecciones)..where((t) => t.id.equals(inspId))).getSingle();
      final vehiculoInspeccionado = await db.inspeccionVehiculosDao
          .getInspeccionVehiculo(inspeccionId: inspId, vehiculoId: base.vehiculoId);
      expect(inspeccion.estado, 'FINALIZADO');
      expect(vehiculoInspeccionado, isNotNull);
      expect(vehiculoInspeccionado!.horometro, isNull);
    });

    test('las inspecciones finalizadas salen de la lista de activas', () async {
      final base = await sembrarClienteYVehiculo(db);
      final dao = db.inspeccionesDao;
      final activa = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Activa', fechaInspeccion: DateTime(2026, 5, 10));
      final cerrada = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Cerrada', fechaInspeccion: DateTime(2026, 5, 11));
      await dao.finalizarInspeccion(cerrada);

      final activas = await dao.watchInspeccionesNoFinalizadas().first;
      expect(activas.map((i) => i.id), [activa]);
      expect(activas.single.clienteNombre, 'Cliente Demo - Valle');
    });

    test('eliminar en cascada borra llantas y vehículos de la inspección', () async {
      final base = await sembrarClienteYVehiculo(db);
      final inspId = await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda', fechaInspeccion: DateTime(2026, 5, 10));
      await db.inspeccionVehiculosDao.guardarInspeccionVehiculo(inspeccionId: inspId, vehiculoId: base.vehiculoId);
      await db.inspeccionLlantasDao.guardarLlanta(
        clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
        codigoLlanta: 'A-1', posicion: 1,
      );

      await db.inspeccionesDao.eliminarInspeccionEnCascada(inspId);

      expect(await db.select(db.inspecciones).get(), isEmpty);
      expect(await db.select(db.inspeccionVehiculos).get(), isEmpty);
      expect(await db.select(db.inspeccionLlantas).get(), isEmpty);
      // El vehículo maestro se conserva
      expect(await db.select(db.vehiculos).get(), hasLength(1));
    });
  });

  group('Historial y resúmenes', () {
    test('el historial trae la medición más reciente de cada posición, sin la inspección actual', () async {
      final base = await sembrarClienteYVehiculo(db);
      final dao = db.inspeccionesDao;
      final llantas = db.inspeccionLlantasDao;

      final antigua = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Enero', fechaInspeccion: DateTime(2026, 1, 10));
      final reciente = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Marzo', fechaInspeccion: DateTime(2026, 3, 10));
      final actual = await dao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Mayo', fechaInspeccion: DateTime(2026, 5, 10));

      Future<void> medir(String inspId, int posicion, double ext) => llantas.guardarLlanta(
            clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
            codigoLlanta: 'P$posicion', posicion: posicion, medidaExt: ext,
          );

      await medir(antigua, 1, 30);
      await medir(antigua, 2, 31);
      await medir(reciente, 1, 25);
      await medir(actual, 1, 20);

      final historial = await llantas.getHistorialPrevioLlantasVehiculo(
          inspeccionActualId: actual, vehiculoId: base.vehiculoId);

      expect(historial.map((l) => l.posicion), [1, 2]);
      expect(historial[0].medidaExt, 25); // Marzo, no Mayo (actual) ni Enero
      expect(historial[1].medidaExt, 31); // La posición 2 solo se midió en Enero
    });

    test('el resumen de clientes cuenta vehículos e inspecciones', () async {
      final base = await sembrarClienteYVehiculo(db);
      await db.vehiculosDao.crearVehiculoLocal(
          codigoVehiculo: '102', clienteId: base.clienteId, noLlantas: 4, nombreTipo: 'Montacargas', nombreMarca: 'Norvik');
      await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda', fechaInspeccion: DateTime(2026, 5, 10));

      final resumen = (await db.clienteDao.watchClientesConEstadisticas().first).single;
      expect(resumen.cantidadVehiculos, 2);
      expect(resumen.cantidadInspecciones, 1);
      expect(resumen.ultimaInspeccion, DateTime(2026, 5, 10));
    });

    test('el vehículo reporta cuántas llantas lleva inspeccionadas', () async {
      final base = await sembrarClienteYVehiculo(db);
      final inspId = await db.inspeccionesDao.crearNuevaInspeccion(
          clienteId: base.clienteId, nombre: 'Ronda', fechaInspeccion: DateTime(2026, 5, 10));
      for (final p in [1, 2, 3]) {
        await db.inspeccionLlantasDao.guardarLlanta(
          clienteId: base.clienteId, inspeccionId: inspId, vehiculoId: base.vehiculoId,
          codigoLlanta: 'P$p', posicion: p,
        );
      }

      final vehiculos = await db.vehiculosDao
          .getVehiculosParaInspeccion(clienteId: base.clienteId, inspeccionId: inspId)
          .first;
      expect(vehiculos.single.cantidadLlantasInspeccionadas, 3);
      expect(vehiculos.single.noLlantas, 4);
      expect(vehiculos.single.nombreTipo, 'MONTACARGAS');
    });
  });

  group('Control de sincronización', () {
    test('sin sincronizaciones previas devuelve la fecha epoch', () async {
      expect(await db.syncDataDao.getLastSuccessfulSync(), DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('devuelve la última fecha registrada', () async {
      await db.syncDataDao.insertLastSync(DateTime.utc(2026, 1, 1));
      await db.syncDataDao.insertLastSync(DateTime.utc(2026, 2, 1));
      final ultima = await db.syncDataDao.getLastSuccessfulSync();
      expect(ultima.isAtSameMomentAs(DateTime.utc(2026, 2, 1)), isTrue);
    });

    test('marcarComoSincronizados limpia la bandera de pendiente', () async {
      final base = await sembrarClienteYVehiculo(db);
      expect(await db.vehiculosDao.obtenerPendientesSync(), hasLength(1));

      await db.vehiculosDao.marcarComoSincronizados([base.vehiculoId]);
      expect(await db.vehiculosDao.obtenerPendientesSync(), isEmpty);
    });

    test('upsert desde el servidor no duplica registros', () async {
      const cliente = ClientesCompanion(id: Value('c-x'), nombre: Value('Original'));
      await db.clienteDao.upsert(cliente);
      await db.clienteDao.upsert(cliente.copyWith(nombre: const Value('Renombrado')));

      final clientes = await db.select(db.clientes).get();
      expect(clientes.single.nombre, 'Renombrado');
    });
  });
}
