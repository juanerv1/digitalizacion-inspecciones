import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Base de datos SQLite en memoria: cada test arranca limpio y no toca el disco.
///
/// `closeStreamsSynchronously` evita que Drift deje timers pendientes al cancelar
/// los streams, algo que los widget tests consideran un error.
AppDatabase crearBaseDeDatosEnMemoria() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase.forTesting(
    DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
  );
}

/// Datos mínimos para una inspección: un cliente y un vehículo de 4 llantas.
class DatosBase {
  final String clienteId;
  final String vehiculoId;

  DatosBase(this.clienteId, this.vehiculoId);
}

Future<DatosBase> sembrarClienteYVehiculo(
  AppDatabase db, {
  String clienteId = 'cliente-1',
  String nombreCliente = 'Cliente Demo - Valle',
  String codigoVehiculo = '101',
}) async {
  await db.clienteDao.upsert(
    ClientesCompanion(id: Value(clienteId), nombre: Value(nombreCliente)),
  );

  final vehiculoId = await db.vehiculosDao.crearVehiculoLocal(
    codigoVehiculo: codigoVehiculo,
    clienteId: clienteId,
    noLlantas: 4,
    nombreTipo: 'Montacargas',
    nombreMarca: 'Norvik MX-30',
  );
  return DatosBase(clienteId, vehiculoId);
}
