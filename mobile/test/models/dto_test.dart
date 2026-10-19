import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:inspecciones_llantas/models/dto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  group('AppSyncPayload.fromJson', () {
    test('parsea todas las colecciones y la metadata', () {
      final payload = AppSyncPayload.fromJson(respuestaDescarga());

      expect(payload.clientes, hasLength(1));
      expect(payload.variables, hasLength(2));
      expect(payload.vehiculos.single.noLlantas, 4);
      expect(payload.inspecciones.single.nombre, 'Inspección inicial');
      expect(payload.metadata.counts.inspeccionLlantas, 1);
      expect(payload.metadata.serverTimestamp, DateTime.utc(2026, 5, 10, 15, 30));
      expect(payload.metadata.serverTimestamp.isUtc, isTrue);
    });

    test('convierte números enteros del JSON a double', () {
      final llanta = AppSyncPayload.fromJson(respuestaDescarga()).inspeccionLlantas.single;

      expect(llanta.presion, 25.0);
      expect(llanta.medidaExt, 33.0);
      expect(llanta.horoMontaje, 3512.0);
      expect(llanta.medidaCent, isNull);
      expect(llanta.fechaMontaje, DateTime(2024, 3, 14));
    });

    test('las colecciones ausentes se interpretan como listas vacías', () {
      final json = respuestaDescarga()
        ..remove('vehiculos')
        ..remove('inspeccion_llantas');
      final payload = AppSyncPayload.fromJson(json);

      expect(payload.vehiculos, isEmpty);
      expect(payload.inspeccionLlantas, isEmpty);
    });

    test('los conteos faltantes valen 0', () {
      final counts = SyncCounts.fromJson({'clientes': 3});
      expect(counts.clientes, 3);
      expect(counts.vehiculos, 0);
      expect(counts.inspeccionLlantas, 0);
    });
  });

  group('ClienteVariableSync', () {
    test('mapea el tipo de variable del servidor al enum local', () {
      final variable = ClienteVariableSync.fromJson(respuestaDescarga()['variables'][1]);
      expect(variable.tipoVariable, TipoVariableEnum.MarcaLlata);
    });
  });

  group('toCompanion', () {
    test('los registros que vienen del servidor no quedan pendientes de envío', () {
      final llanta = AppSyncPayload.fromJson(respuestaDescarga()).inspeccionLlantas.single;
      final companion = llanta.toCompanion(isFromServer: true);

      expect(companion.pendienteSync, const Value(false));
      expect(companion.creadaLocal, const Value(false));
      expect(companion.codigoLlanta, const Value('A-500'));
    });

    test('si no vienen del servidor no se sobrescriben las banderas de sincronización', () {
      final variable = ClienteVariableSync.fromJson(respuestaDescarga()['variables'][0]);
      final companion = variable.toCompanion(isFromServer: false);

      expect(companion.pendienteSync, const Value<bool>.absent());
      expect(companion.creadaLocal, const Value<bool>.absent());
    });
  });
}
