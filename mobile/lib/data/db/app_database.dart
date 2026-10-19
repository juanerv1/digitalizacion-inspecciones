import 'package:inspecciones_llantas/data/db/daos.dart';
import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Clientes,
  ClienteVariables,
  Vehiculos,
  Inspecciones,
  InspeccionVehiculos,
  InspeccionLlantas,
  SyncData],
  daos: [
    ClienteDao,
    ClienteVariablesDao,
    VehiculosDao,
    InspeccionesDao,
    InspeccionVehiculosDao,
    InspeccionLlantasDao,
    SyncDataDao
    ])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Permite inyectar otra conexión (p. ej. SQLite en memoria para las pruebas).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1; 
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
