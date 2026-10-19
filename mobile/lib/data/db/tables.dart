// Los valores del enum coinciden con los del servidor (TipoVariableEnum en la API)
// ignore_for_file: constant_identifier_names
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

// Necesitarás instalar la librería uuid: flutter pub add uuid
const uuid = Uuid();

// ==========================================
// 1. Enums
// ==========================================

enum TipoVariableEnum {
  TipoVehiculo,
  MarcaVehiculo,
  DimensionLlanta,
  DisenoLlanta,
  MarcaLlata,
  TipoLlanta
}

// ==========================================
// 2. Modelos (Tablas)
// ==========================================

@DataClassName('Cliente')
class Clientes extends Table {
  @override
  String get tableName => 'clientes';

  // Atributos
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get nombre => text().withLength(max: 100)();

  // Tiempos
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ClienteVariable')
class ClienteVariables extends Table {
  @override
  String get tableName => 'cliente_variables';

  // Atributos
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get clienteId => text().references(Clientes, #id, onDelete: KeyAction.cascade)();
  TextColumn get tipoVariable => textEnum<TipoVariableEnum>()();
  TextColumn get nombre => text().withLength(max: 50)();

  // Tiempos
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Sync logic
  BoolColumn get creadaLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get pendienteSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Vehiculo')
class Vehiculos extends Table {
  @override
  String get tableName => 'vehiculos';

  // Atributos
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get codigoVehiculo => text().withLength(max: 20)();
  TextColumn get clienteId => text().references(Clientes, #id, onDelete: KeyAction.cascade)();
  TextColumn get tipoId => text().references(ClienteVariables, #id)();
  TextColumn get marcaId => text().references(ClienteVariables, #id)();
  IntColumn get noLlantas => integer()();

  // Tiempos
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync logic
  BoolColumn get creadaLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get pendienteSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Inspeccion')
class Inspecciones extends Table {
  @override
  String get tableName => 'inspecciones';

  // Atributos
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get clienteId => text().references(Clientes, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text().withLength(max: 100).nullable()();
  DateTimeColumn get fechaRevision => dateTime()();
  TextColumn get estado => text().withLength(max: 20).withDefault(const Constant('FINALIZADO'))();

  // Tiempos
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync logic
  BoolColumn get creadaLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get pendienteSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('InspeccionVehiculo')
class InspeccionVehiculos extends Table {
  @override
  String get tableName => 'inspeccion_vehiculos';

  // Atributos
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get inspeccionId => text().references(Inspecciones, #id, onDelete: KeyAction.cascade)();
  TextColumn get vehiculoId => text().references(Vehiculos, #id, onDelete: KeyAction.cascade)();
  RealColumn get horometro => real().nullable()();
  RealColumn get kilometraje => real().nullable()();

  // Tiempos
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Sync logic
  BoolColumn get creadaLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get pendienteSync => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};

  // Restricciones equivalentes a UniqueConstraint
  @override
  List<Set<Column>> get uniqueKeys => [{inspeccionId, vehiculoId}];
}

@DataClassName('InspeccionLlanta')
class InspeccionLlantas extends Table {
  @override
  String get tableName => 'inspeccion_llantas';

  // Atributos
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get inspeccionId => text().references(Inspecciones, #id, onDelete: KeyAction.cascade)();
  TextColumn get vehiculoId => text().references(Vehiculos, #id, onDelete: KeyAction.cascade)();
  TextColumn get codigoLlanta => text().withLength(max: 50)();
  DateTimeColumn get fechaMontaje => dateTime().nullable()();
  RealColumn get horoMontaje => real().nullable()();
  RealColumn get kmMontaje => real().nullable()();
  
  TextColumn get tipoLlantaId => text().references(ClienteVariables, #id).nullable()();
  TextColumn get marcaLlantaId => text().references(ClienteVariables, #id).nullable()();
  TextColumn get dimensionLlantaId => text().references(ClienteVariables, #id).nullable()();
  TextColumn get disenoLlantaId => text().references(ClienteVariables, #id).nullable()();
  
  IntColumn get posicion => integer()();
  RealColumn get presion => real().nullable()();
  RealColumn get medidaInt => real().nullable()();
  RealColumn get medidaCent => real().nullable()();
  RealColumn get medidaExt => real().nullable()();
  TextColumn get observacion => text().nullable()();

  // Tiempos
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync logic
  BoolColumn get creadaLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get pendienteSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  // --- NUEVA RESTRICCIÓN DE UNICIDAD ---
  // Garantiza que para una misma inspección y un mismo vehículo, 
  // no se repita nunca la misma posición de llanta.
  @override
  List<Set<Column>> get uniqueKeys => [
    {inspeccionId, vehiculoId, posicion}
  ];
}

@DataClassName('sync_data')
class SyncData extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get lastSuccessfulSync => dateTime().nullable()();
}