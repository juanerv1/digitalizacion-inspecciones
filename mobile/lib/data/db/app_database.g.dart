// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final String id;
  final String nombre;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Cliente({
    required this.id,
    required this.nombre,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Cliente copyWith({
    String? id,
    String? nombre,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Cliente(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Cliente> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClienteVariablesTable extends ClienteVariables
    with TableInfo<$ClienteVariablesTable, ClienteVariable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClienteVariablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoVariableEnum, String>
  tipoVariable =
      GeneratedColumn<String>(
        'tipo_variable',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoVariableEnum>(
        $ClienteVariablesTable.$convertertipoVariable,
      );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _creadaLocalMeta = const VerificationMeta(
    'creadaLocal',
  );
  @override
  late final GeneratedColumn<bool> creadaLocal = GeneratedColumn<bool>(
    'creada_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("creada_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    tipoVariable,
    nombre,
    createdAt,
    creadaLocal,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cliente_variables';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClienteVariable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('creada_local')) {
      context.handle(
        _creadaLocalMeta,
        creadaLocal.isAcceptableOrUnknown(
          data['creada_local']!,
          _creadaLocalMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClienteVariable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteVariable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      tipoVariable: $ClienteVariablesTable.$convertertipoVariable.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo_variable'],
        )!,
      ),
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      creadaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}creada_local'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $ClienteVariablesTable createAlias(String alias) {
    return $ClienteVariablesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoVariableEnum, String, String>
  $convertertipoVariable = const EnumNameConverter<TipoVariableEnum>(
    TipoVariableEnum.values,
  );
}

class ClienteVariable extends DataClass implements Insertable<ClienteVariable> {
  final String id;
  final String clienteId;
  final TipoVariableEnum tipoVariable;
  final String nombre;
  final DateTime createdAt;
  final bool creadaLocal;
  final bool pendienteSync;
  const ClienteVariable({
    required this.id,
    required this.clienteId,
    required this.tipoVariable,
    required this.nombre,
    required this.createdAt,
    required this.creadaLocal,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    {
      map['tipo_variable'] = Variable<String>(
        $ClienteVariablesTable.$convertertipoVariable.toSql(tipoVariable),
      );
    }
    map['nombre'] = Variable<String>(nombre);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['creada_local'] = Variable<bool>(creadaLocal);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  ClienteVariablesCompanion toCompanion(bool nullToAbsent) {
    return ClienteVariablesCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      tipoVariable: Value(tipoVariable),
      nombre: Value(nombre),
      createdAt: Value(createdAt),
      creadaLocal: Value(creadaLocal),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory ClienteVariable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteVariable(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      tipoVariable: $ClienteVariablesTable.$convertertipoVariable.fromJson(
        serializer.fromJson<String>(json['tipoVariable']),
      ),
      nombre: serializer.fromJson<String>(json['nombre']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      creadaLocal: serializer.fromJson<bool>(json['creadaLocal']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'tipoVariable': serializer.toJson<String>(
        $ClienteVariablesTable.$convertertipoVariable.toJson(tipoVariable),
      ),
      'nombre': serializer.toJson<String>(nombre),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'creadaLocal': serializer.toJson<bool>(creadaLocal),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  ClienteVariable copyWith({
    String? id,
    String? clienteId,
    TipoVariableEnum? tipoVariable,
    String? nombre,
    DateTime? createdAt,
    bool? creadaLocal,
    bool? pendienteSync,
  }) => ClienteVariable(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    tipoVariable: tipoVariable ?? this.tipoVariable,
    nombre: nombre ?? this.nombre,
    createdAt: createdAt ?? this.createdAt,
    creadaLocal: creadaLocal ?? this.creadaLocal,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  ClienteVariable copyWithCompanion(ClienteVariablesCompanion data) {
    return ClienteVariable(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      tipoVariable: data.tipoVariable.present
          ? data.tipoVariable.value
          : this.tipoVariable,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      creadaLocal: data.creadaLocal.present
          ? data.creadaLocal.value
          : this.creadaLocal,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteVariable(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipoVariable: $tipoVariable, ')
          ..write('nombre: $nombre, ')
          ..write('createdAt: $createdAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    tipoVariable,
    nombre,
    createdAt,
    creadaLocal,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteVariable &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.tipoVariable == this.tipoVariable &&
          other.nombre == this.nombre &&
          other.createdAt == this.createdAt &&
          other.creadaLocal == this.creadaLocal &&
          other.pendienteSync == this.pendienteSync);
}

class ClienteVariablesCompanion extends UpdateCompanion<ClienteVariable> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<TipoVariableEnum> tipoVariable;
  final Value<String> nombre;
  final Value<DateTime> createdAt;
  final Value<bool> creadaLocal;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const ClienteVariablesCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.tipoVariable = const Value.absent(),
    this.nombre = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClienteVariablesCompanion.insert({
    this.id = const Value.absent(),
    required String clienteId,
    required TipoVariableEnum tipoVariable,
    required String nombre,
    this.createdAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clienteId = Value(clienteId),
       tipoVariable = Value(tipoVariable),
       nombre = Value(nombre);
  static Insertable<ClienteVariable> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? tipoVariable,
    Expression<String>? nombre,
    Expression<DateTime>? createdAt,
    Expression<bool>? creadaLocal,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (tipoVariable != null) 'tipo_variable': tipoVariable,
      if (nombre != null) 'nombre': nombre,
      if (createdAt != null) 'created_at': createdAt,
      if (creadaLocal != null) 'creada_local': creadaLocal,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClienteVariablesCompanion copyWith({
    Value<String>? id,
    Value<String>? clienteId,
    Value<TipoVariableEnum>? tipoVariable,
    Value<String>? nombre,
    Value<DateTime>? createdAt,
    Value<bool>? creadaLocal,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return ClienteVariablesCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      tipoVariable: tipoVariable ?? this.tipoVariable,
      nombre: nombre ?? this.nombre,
      createdAt: createdAt ?? this.createdAt,
      creadaLocal: creadaLocal ?? this.creadaLocal,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (tipoVariable.present) {
      map['tipo_variable'] = Variable<String>(
        $ClienteVariablesTable.$convertertipoVariable.toSql(tipoVariable.value),
      );
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (creadaLocal.present) {
      map['creada_local'] = Variable<bool>(creadaLocal.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteVariablesCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipoVariable: $tipoVariable, ')
          ..write('nombre: $nombre, ')
          ..write('createdAt: $createdAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehiculosTable extends Vehiculos
    with TableInfo<$VehiculosTable, Vehiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiculosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _codigoVehiculoMeta = const VerificationMeta(
    'codigoVehiculo',
  );
  @override
  late final GeneratedColumn<String> codigoVehiculo = GeneratedColumn<String>(
    'codigo_vehiculo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tipoIdMeta = const VerificationMeta('tipoId');
  @override
  late final GeneratedColumn<String> tipoId = GeneratedColumn<String>(
    'tipo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente_variables (id)',
    ),
  );
  static const VerificationMeta _marcaIdMeta = const VerificationMeta(
    'marcaId',
  );
  @override
  late final GeneratedColumn<String> marcaId = GeneratedColumn<String>(
    'marca_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente_variables (id)',
    ),
  );
  static const VerificationMeta _noLlantasMeta = const VerificationMeta(
    'noLlantas',
  );
  @override
  late final GeneratedColumn<int> noLlantas = GeneratedColumn<int>(
    'no_llantas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _creadaLocalMeta = const VerificationMeta(
    'creadaLocal',
  );
  @override
  late final GeneratedColumn<bool> creadaLocal = GeneratedColumn<bool>(
    'creada_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("creada_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigoVehiculo,
    clienteId,
    tipoId,
    marcaId,
    noLlantas,
    createdAt,
    updatedAt,
    creadaLocal,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehiculos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehiculo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo_vehiculo')) {
      context.handle(
        _codigoVehiculoMeta,
        codigoVehiculo.isAcceptableOrUnknown(
          data['codigo_vehiculo']!,
          _codigoVehiculoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codigoVehiculoMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('tipo_id')) {
      context.handle(
        _tipoIdMeta,
        tipoId.isAcceptableOrUnknown(data['tipo_id']!, _tipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoIdMeta);
    }
    if (data.containsKey('marca_id')) {
      context.handle(
        _marcaIdMeta,
        marcaId.isAcceptableOrUnknown(data['marca_id']!, _marcaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaIdMeta);
    }
    if (data.containsKey('no_llantas')) {
      context.handle(
        _noLlantasMeta,
        noLlantas.isAcceptableOrUnknown(data['no_llantas']!, _noLlantasMeta),
      );
    } else if (isInserting) {
      context.missing(_noLlantasMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('creada_local')) {
      context.handle(
        _creadaLocalMeta,
        creadaLocal.isAcceptableOrUnknown(
          data['creada_local']!,
          _creadaLocalMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehiculo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      codigoVehiculo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_vehiculo'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      tipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_id'],
      )!,
      marcaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca_id'],
      )!,
      noLlantas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}no_llantas'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      creadaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}creada_local'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $VehiculosTable createAlias(String alias) {
    return $VehiculosTable(attachedDatabase, alias);
  }
}

class Vehiculo extends DataClass implements Insertable<Vehiculo> {
  final String id;
  final String codigoVehiculo;
  final String clienteId;
  final String tipoId;
  final String marcaId;
  final int noLlantas;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool creadaLocal;
  final bool pendienteSync;
  const Vehiculo({
    required this.id,
    required this.codigoVehiculo,
    required this.clienteId,
    required this.tipoId,
    required this.marcaId,
    required this.noLlantas,
    required this.createdAt,
    required this.updatedAt,
    required this.creadaLocal,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['codigo_vehiculo'] = Variable<String>(codigoVehiculo);
    map['cliente_id'] = Variable<String>(clienteId);
    map['tipo_id'] = Variable<String>(tipoId);
    map['marca_id'] = Variable<String>(marcaId);
    map['no_llantas'] = Variable<int>(noLlantas);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['creada_local'] = Variable<bool>(creadaLocal);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  VehiculosCompanion toCompanion(bool nullToAbsent) {
    return VehiculosCompanion(
      id: Value(id),
      codigoVehiculo: Value(codigoVehiculo),
      clienteId: Value(clienteId),
      tipoId: Value(tipoId),
      marcaId: Value(marcaId),
      noLlantas: Value(noLlantas),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creadaLocal: Value(creadaLocal),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Vehiculo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehiculo(
      id: serializer.fromJson<String>(json['id']),
      codigoVehiculo: serializer.fromJson<String>(json['codigoVehiculo']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      tipoId: serializer.fromJson<String>(json['tipoId']),
      marcaId: serializer.fromJson<String>(json['marcaId']),
      noLlantas: serializer.fromJson<int>(json['noLlantas']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      creadaLocal: serializer.fromJson<bool>(json['creadaLocal']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'codigoVehiculo': serializer.toJson<String>(codigoVehiculo),
      'clienteId': serializer.toJson<String>(clienteId),
      'tipoId': serializer.toJson<String>(tipoId),
      'marcaId': serializer.toJson<String>(marcaId),
      'noLlantas': serializer.toJson<int>(noLlantas),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'creadaLocal': serializer.toJson<bool>(creadaLocal),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Vehiculo copyWith({
    String? id,
    String? codigoVehiculo,
    String? clienteId,
    String? tipoId,
    String? marcaId,
    int? noLlantas,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? creadaLocal,
    bool? pendienteSync,
  }) => Vehiculo(
    id: id ?? this.id,
    codigoVehiculo: codigoVehiculo ?? this.codigoVehiculo,
    clienteId: clienteId ?? this.clienteId,
    tipoId: tipoId ?? this.tipoId,
    marcaId: marcaId ?? this.marcaId,
    noLlantas: noLlantas ?? this.noLlantas,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    creadaLocal: creadaLocal ?? this.creadaLocal,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Vehiculo copyWithCompanion(VehiculosCompanion data) {
    return Vehiculo(
      id: data.id.present ? data.id.value : this.id,
      codigoVehiculo: data.codigoVehiculo.present
          ? data.codigoVehiculo.value
          : this.codigoVehiculo,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      tipoId: data.tipoId.present ? data.tipoId.value : this.tipoId,
      marcaId: data.marcaId.present ? data.marcaId.value : this.marcaId,
      noLlantas: data.noLlantas.present ? data.noLlantas.value : this.noLlantas,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      creadaLocal: data.creadaLocal.present
          ? data.creadaLocal.value
          : this.creadaLocal,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehiculo(')
          ..write('id: $id, ')
          ..write('codigoVehiculo: $codigoVehiculo, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipoId: $tipoId, ')
          ..write('marcaId: $marcaId, ')
          ..write('noLlantas: $noLlantas, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigoVehiculo,
    clienteId,
    tipoId,
    marcaId,
    noLlantas,
    createdAt,
    updatedAt,
    creadaLocal,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehiculo &&
          other.id == this.id &&
          other.codigoVehiculo == this.codigoVehiculo &&
          other.clienteId == this.clienteId &&
          other.tipoId == this.tipoId &&
          other.marcaId == this.marcaId &&
          other.noLlantas == this.noLlantas &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.creadaLocal == this.creadaLocal &&
          other.pendienteSync == this.pendienteSync);
}

class VehiculosCompanion extends UpdateCompanion<Vehiculo> {
  final Value<String> id;
  final Value<String> codigoVehiculo;
  final Value<String> clienteId;
  final Value<String> tipoId;
  final Value<String> marcaId;
  final Value<int> noLlantas;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> creadaLocal;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const VehiculosCompanion({
    this.id = const Value.absent(),
    this.codigoVehiculo = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.tipoId = const Value.absent(),
    this.marcaId = const Value.absent(),
    this.noLlantas = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiculosCompanion.insert({
    this.id = const Value.absent(),
    required String codigoVehiculo,
    required String clienteId,
    required String tipoId,
    required String marcaId,
    required int noLlantas,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigoVehiculo = Value(codigoVehiculo),
       clienteId = Value(clienteId),
       tipoId = Value(tipoId),
       marcaId = Value(marcaId),
       noLlantas = Value(noLlantas);
  static Insertable<Vehiculo> custom({
    Expression<String>? id,
    Expression<String>? codigoVehiculo,
    Expression<String>? clienteId,
    Expression<String>? tipoId,
    Expression<String>? marcaId,
    Expression<int>? noLlantas,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? creadaLocal,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigoVehiculo != null) 'codigo_vehiculo': codigoVehiculo,
      if (clienteId != null) 'cliente_id': clienteId,
      if (tipoId != null) 'tipo_id': tipoId,
      if (marcaId != null) 'marca_id': marcaId,
      if (noLlantas != null) 'no_llantas': noLlantas,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (creadaLocal != null) 'creada_local': creadaLocal,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiculosCompanion copyWith({
    Value<String>? id,
    Value<String>? codigoVehiculo,
    Value<String>? clienteId,
    Value<String>? tipoId,
    Value<String>? marcaId,
    Value<int>? noLlantas,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? creadaLocal,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return VehiculosCompanion(
      id: id ?? this.id,
      codigoVehiculo: codigoVehiculo ?? this.codigoVehiculo,
      clienteId: clienteId ?? this.clienteId,
      tipoId: tipoId ?? this.tipoId,
      marcaId: marcaId ?? this.marcaId,
      noLlantas: noLlantas ?? this.noLlantas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creadaLocal: creadaLocal ?? this.creadaLocal,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (codigoVehiculo.present) {
      map['codigo_vehiculo'] = Variable<String>(codigoVehiculo.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (tipoId.present) {
      map['tipo_id'] = Variable<String>(tipoId.value);
    }
    if (marcaId.present) {
      map['marca_id'] = Variable<String>(marcaId.value);
    }
    if (noLlantas.present) {
      map['no_llantas'] = Variable<int>(noLlantas.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (creadaLocal.present) {
      map['creada_local'] = Variable<bool>(creadaLocal.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiculosCompanion(')
          ..write('id: $id, ')
          ..write('codigoVehiculo: $codigoVehiculo, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipoId: $tipoId, ')
          ..write('marcaId: $marcaId, ')
          ..write('noLlantas: $noLlantas, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspeccionesTable extends Inspecciones
    with TableInfo<$InspeccionesTable, Inspeccion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspeccionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaRevisionMeta = const VerificationMeta(
    'fechaRevision',
  );
  @override
  late final GeneratedColumn<DateTime> fechaRevision =
      GeneratedColumn<DateTime>(
        'fecha_revision',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FINALIZADO'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _creadaLocalMeta = const VerificationMeta(
    'creadaLocal',
  );
  @override
  late final GeneratedColumn<bool> creadaLocal = GeneratedColumn<bool>(
    'creada_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("creada_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    nombre,
    fechaRevision,
    estado,
    createdAt,
    updatedAt,
    creadaLocal,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspecciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspeccion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('fecha_revision')) {
      context.handle(
        _fechaRevisionMeta,
        fechaRevision.isAcceptableOrUnknown(
          data['fecha_revision']!,
          _fechaRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaRevisionMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('creada_local')) {
      context.handle(
        _creadaLocalMeta,
        creadaLocal.isAcceptableOrUnknown(
          data['creada_local']!,
          _creadaLocalMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspeccion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspeccion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      ),
      fechaRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_revision'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      creadaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}creada_local'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $InspeccionesTable createAlias(String alias) {
    return $InspeccionesTable(attachedDatabase, alias);
  }
}

class Inspeccion extends DataClass implements Insertable<Inspeccion> {
  final String id;
  final String clienteId;
  final String? nombre;
  final DateTime fechaRevision;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool creadaLocal;
  final bool pendienteSync;
  const Inspeccion({
    required this.id,
    required this.clienteId,
    this.nombre,
    required this.fechaRevision,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.creadaLocal,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    if (!nullToAbsent || nombre != null) {
      map['nombre'] = Variable<String>(nombre);
    }
    map['fecha_revision'] = Variable<DateTime>(fechaRevision);
    map['estado'] = Variable<String>(estado);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['creada_local'] = Variable<bool>(creadaLocal);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  InspeccionesCompanion toCompanion(bool nullToAbsent) {
    return InspeccionesCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      nombre: nombre == null && nullToAbsent
          ? const Value.absent()
          : Value(nombre),
      fechaRevision: Value(fechaRevision),
      estado: Value(estado),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creadaLocal: Value(creadaLocal),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Inspeccion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspeccion(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      nombre: serializer.fromJson<String?>(json['nombre']),
      fechaRevision: serializer.fromJson<DateTime>(json['fechaRevision']),
      estado: serializer.fromJson<String>(json['estado']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      creadaLocal: serializer.fromJson<bool>(json['creadaLocal']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'nombre': serializer.toJson<String?>(nombre),
      'fechaRevision': serializer.toJson<DateTime>(fechaRevision),
      'estado': serializer.toJson<String>(estado),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'creadaLocal': serializer.toJson<bool>(creadaLocal),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Inspeccion copyWith({
    String? id,
    String? clienteId,
    Value<String?> nombre = const Value.absent(),
    DateTime? fechaRevision,
    String? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? creadaLocal,
    bool? pendienteSync,
  }) => Inspeccion(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    nombre: nombre.present ? nombre.value : this.nombre,
    fechaRevision: fechaRevision ?? this.fechaRevision,
    estado: estado ?? this.estado,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    creadaLocal: creadaLocal ?? this.creadaLocal,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Inspeccion copyWithCompanion(InspeccionesCompanion data) {
    return Inspeccion(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      fechaRevision: data.fechaRevision.present
          ? data.fechaRevision.value
          : this.fechaRevision,
      estado: data.estado.present ? data.estado.value : this.estado,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      creadaLocal: data.creadaLocal.present
          ? data.creadaLocal.value
          : this.creadaLocal,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspeccion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('nombre: $nombre, ')
          ..write('fechaRevision: $fechaRevision, ')
          ..write('estado: $estado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    nombre,
    fechaRevision,
    estado,
    createdAt,
    updatedAt,
    creadaLocal,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspeccion &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.nombre == this.nombre &&
          other.fechaRevision == this.fechaRevision &&
          other.estado == this.estado &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.creadaLocal == this.creadaLocal &&
          other.pendienteSync == this.pendienteSync);
}

class InspeccionesCompanion extends UpdateCompanion<Inspeccion> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String?> nombre;
  final Value<DateTime> fechaRevision;
  final Value<String> estado;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> creadaLocal;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const InspeccionesCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.fechaRevision = const Value.absent(),
    this.estado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspeccionesCompanion.insert({
    this.id = const Value.absent(),
    required String clienteId,
    this.nombre = const Value.absent(),
    required DateTime fechaRevision,
    this.estado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clienteId = Value(clienteId),
       fechaRevision = Value(fechaRevision);
  static Insertable<Inspeccion> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? nombre,
    Expression<DateTime>? fechaRevision,
    Expression<String>? estado,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? creadaLocal,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (nombre != null) 'nombre': nombre,
      if (fechaRevision != null) 'fecha_revision': fechaRevision,
      if (estado != null) 'estado': estado,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (creadaLocal != null) 'creada_local': creadaLocal,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspeccionesCompanion copyWith({
    Value<String>? id,
    Value<String>? clienteId,
    Value<String?>? nombre,
    Value<DateTime>? fechaRevision,
    Value<String>? estado,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? creadaLocal,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return InspeccionesCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      nombre: nombre ?? this.nombre,
      fechaRevision: fechaRevision ?? this.fechaRevision,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creadaLocal: creadaLocal ?? this.creadaLocal,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (fechaRevision.present) {
      map['fecha_revision'] = Variable<DateTime>(fechaRevision.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (creadaLocal.present) {
      map['creada_local'] = Variable<bool>(creadaLocal.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionesCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('nombre: $nombre, ')
          ..write('fechaRevision: $fechaRevision, ')
          ..write('estado: $estado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspeccionVehiculosTable extends InspeccionVehiculos
    with TableInfo<$InspeccionVehiculosTable, InspeccionVehiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspeccionVehiculosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _inspeccionIdMeta = const VerificationMeta(
    'inspeccionId',
  );
  @override
  late final GeneratedColumn<String> inspeccionId = GeneratedColumn<String>(
    'inspeccion_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspecciones (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _vehiculoIdMeta = const VerificationMeta(
    'vehiculoId',
  );
  @override
  late final GeneratedColumn<String> vehiculoId = GeneratedColumn<String>(
    'vehiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehiculos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _horometroMeta = const VerificationMeta(
    'horometro',
  );
  @override
  late final GeneratedColumn<double> horometro = GeneratedColumn<double>(
    'horometro',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kilometrajeMeta = const VerificationMeta(
    'kilometraje',
  );
  @override
  late final GeneratedColumn<double> kilometraje = GeneratedColumn<double>(
    'kilometraje',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _creadaLocalMeta = const VerificationMeta(
    'creadaLocal',
  );
  @override
  late final GeneratedColumn<bool> creadaLocal = GeneratedColumn<bool>(
    'creada_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("creada_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspeccionId,
    vehiculoId,
    horometro,
    kilometraje,
    createdAt,
    creadaLocal,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspeccion_vehiculos';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspeccionVehiculo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inspeccion_id')) {
      context.handle(
        _inspeccionIdMeta,
        inspeccionId.isAcceptableOrUnknown(
          data['inspeccion_id']!,
          _inspeccionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspeccionIdMeta);
    }
    if (data.containsKey('vehiculo_id')) {
      context.handle(
        _vehiculoIdMeta,
        vehiculoId.isAcceptableOrUnknown(data['vehiculo_id']!, _vehiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    if (data.containsKey('horometro')) {
      context.handle(
        _horometroMeta,
        horometro.isAcceptableOrUnknown(data['horometro']!, _horometroMeta),
      );
    }
    if (data.containsKey('kilometraje')) {
      context.handle(
        _kilometrajeMeta,
        kilometraje.isAcceptableOrUnknown(
          data['kilometraje']!,
          _kilometrajeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('creada_local')) {
      context.handle(
        _creadaLocalMeta,
        creadaLocal.isAcceptableOrUnknown(
          data['creada_local']!,
          _creadaLocalMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {inspeccionId, vehiculoId},
  ];
  @override
  InspeccionVehiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspeccionVehiculo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspeccionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspeccion_id'],
      )!,
      vehiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_id'],
      )!,
      horometro: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}horometro'],
      ),
      kilometraje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kilometraje'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      creadaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}creada_local'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $InspeccionVehiculosTable createAlias(String alias) {
    return $InspeccionVehiculosTable(attachedDatabase, alias);
  }
}

class InspeccionVehiculo extends DataClass
    implements Insertable<InspeccionVehiculo> {
  final String id;
  final String inspeccionId;
  final String vehiculoId;
  final double? horometro;
  final double? kilometraje;
  final DateTime createdAt;
  final bool creadaLocal;
  final bool pendienteSync;
  const InspeccionVehiculo({
    required this.id,
    required this.inspeccionId,
    required this.vehiculoId,
    this.horometro,
    this.kilometraje,
    required this.createdAt,
    required this.creadaLocal,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspeccion_id'] = Variable<String>(inspeccionId);
    map['vehiculo_id'] = Variable<String>(vehiculoId);
    if (!nullToAbsent || horometro != null) {
      map['horometro'] = Variable<double>(horometro);
    }
    if (!nullToAbsent || kilometraje != null) {
      map['kilometraje'] = Variable<double>(kilometraje);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['creada_local'] = Variable<bool>(creadaLocal);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  InspeccionVehiculosCompanion toCompanion(bool nullToAbsent) {
    return InspeccionVehiculosCompanion(
      id: Value(id),
      inspeccionId: Value(inspeccionId),
      vehiculoId: Value(vehiculoId),
      horometro: horometro == null && nullToAbsent
          ? const Value.absent()
          : Value(horometro),
      kilometraje: kilometraje == null && nullToAbsent
          ? const Value.absent()
          : Value(kilometraje),
      createdAt: Value(createdAt),
      creadaLocal: Value(creadaLocal),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory InspeccionVehiculo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspeccionVehiculo(
      id: serializer.fromJson<String>(json['id']),
      inspeccionId: serializer.fromJson<String>(json['inspeccionId']),
      vehiculoId: serializer.fromJson<String>(json['vehiculoId']),
      horometro: serializer.fromJson<double?>(json['horometro']),
      kilometraje: serializer.fromJson<double?>(json['kilometraje']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      creadaLocal: serializer.fromJson<bool>(json['creadaLocal']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspeccionId': serializer.toJson<String>(inspeccionId),
      'vehiculoId': serializer.toJson<String>(vehiculoId),
      'horometro': serializer.toJson<double?>(horometro),
      'kilometraje': serializer.toJson<double?>(kilometraje),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'creadaLocal': serializer.toJson<bool>(creadaLocal),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  InspeccionVehiculo copyWith({
    String? id,
    String? inspeccionId,
    String? vehiculoId,
    Value<double?> horometro = const Value.absent(),
    Value<double?> kilometraje = const Value.absent(),
    DateTime? createdAt,
    bool? creadaLocal,
    bool? pendienteSync,
  }) => InspeccionVehiculo(
    id: id ?? this.id,
    inspeccionId: inspeccionId ?? this.inspeccionId,
    vehiculoId: vehiculoId ?? this.vehiculoId,
    horometro: horometro.present ? horometro.value : this.horometro,
    kilometraje: kilometraje.present ? kilometraje.value : this.kilometraje,
    createdAt: createdAt ?? this.createdAt,
    creadaLocal: creadaLocal ?? this.creadaLocal,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  InspeccionVehiculo copyWithCompanion(InspeccionVehiculosCompanion data) {
    return InspeccionVehiculo(
      id: data.id.present ? data.id.value : this.id,
      inspeccionId: data.inspeccionId.present
          ? data.inspeccionId.value
          : this.inspeccionId,
      vehiculoId: data.vehiculoId.present
          ? data.vehiculoId.value
          : this.vehiculoId,
      horometro: data.horometro.present ? data.horometro.value : this.horometro,
      kilometraje: data.kilometraje.present
          ? data.kilometraje.value
          : this.kilometraje,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      creadaLocal: data.creadaLocal.present
          ? data.creadaLocal.value
          : this.creadaLocal,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionVehiculo(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('horometro: $horometro, ')
          ..write('kilometraje: $kilometraje, ')
          ..write('createdAt: $createdAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspeccionId,
    vehiculoId,
    horometro,
    kilometraje,
    createdAt,
    creadaLocal,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspeccionVehiculo &&
          other.id == this.id &&
          other.inspeccionId == this.inspeccionId &&
          other.vehiculoId == this.vehiculoId &&
          other.horometro == this.horometro &&
          other.kilometraje == this.kilometraje &&
          other.createdAt == this.createdAt &&
          other.creadaLocal == this.creadaLocal &&
          other.pendienteSync == this.pendienteSync);
}

class InspeccionVehiculosCompanion extends UpdateCompanion<InspeccionVehiculo> {
  final Value<String> id;
  final Value<String> inspeccionId;
  final Value<String> vehiculoId;
  final Value<double?> horometro;
  final Value<double?> kilometraje;
  final Value<DateTime> createdAt;
  final Value<bool> creadaLocal;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const InspeccionVehiculosCompanion({
    this.id = const Value.absent(),
    this.inspeccionId = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.horometro = const Value.absent(),
    this.kilometraje = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspeccionVehiculosCompanion.insert({
    this.id = const Value.absent(),
    required String inspeccionId,
    required String vehiculoId,
    this.horometro = const Value.absent(),
    this.kilometraje = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : inspeccionId = Value(inspeccionId),
       vehiculoId = Value(vehiculoId);
  static Insertable<InspeccionVehiculo> custom({
    Expression<String>? id,
    Expression<String>? inspeccionId,
    Expression<String>? vehiculoId,
    Expression<double>? horometro,
    Expression<double>? kilometraje,
    Expression<DateTime>? createdAt,
    Expression<bool>? creadaLocal,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspeccionId != null) 'inspeccion_id': inspeccionId,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (horometro != null) 'horometro': horometro,
      if (kilometraje != null) 'kilometraje': kilometraje,
      if (createdAt != null) 'created_at': createdAt,
      if (creadaLocal != null) 'creada_local': creadaLocal,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspeccionVehiculosCompanion copyWith({
    Value<String>? id,
    Value<String>? inspeccionId,
    Value<String>? vehiculoId,
    Value<double?>? horometro,
    Value<double?>? kilometraje,
    Value<DateTime>? createdAt,
    Value<bool>? creadaLocal,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return InspeccionVehiculosCompanion(
      id: id ?? this.id,
      inspeccionId: inspeccionId ?? this.inspeccionId,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      horometro: horometro ?? this.horometro,
      kilometraje: kilometraje ?? this.kilometraje,
      createdAt: createdAt ?? this.createdAt,
      creadaLocal: creadaLocal ?? this.creadaLocal,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspeccionId.present) {
      map['inspeccion_id'] = Variable<String>(inspeccionId.value);
    }
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<String>(vehiculoId.value);
    }
    if (horometro.present) {
      map['horometro'] = Variable<double>(horometro.value);
    }
    if (kilometraje.present) {
      map['kilometraje'] = Variable<double>(kilometraje.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (creadaLocal.present) {
      map['creada_local'] = Variable<bool>(creadaLocal.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionVehiculosCompanion(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('horometro: $horometro, ')
          ..write('kilometraje: $kilometraje, ')
          ..write('createdAt: $createdAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspeccionLlantasTable extends InspeccionLlantas
    with TableInfo<$InspeccionLlantasTable, InspeccionLlanta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspeccionLlantasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _inspeccionIdMeta = const VerificationMeta(
    'inspeccionId',
  );
  @override
  late final GeneratedColumn<String> inspeccionId = GeneratedColumn<String>(
    'inspeccion_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspecciones (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _vehiculoIdMeta = const VerificationMeta(
    'vehiculoId',
  );
  @override
  late final GeneratedColumn<String> vehiculoId = GeneratedColumn<String>(
    'vehiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehiculos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _codigoLlantaMeta = const VerificationMeta(
    'codigoLlanta',
  );
  @override
  late final GeneratedColumn<String> codigoLlanta = GeneratedColumn<String>(
    'codigo_llanta',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMontajeMeta = const VerificationMeta(
    'fechaMontaje',
  );
  @override
  late final GeneratedColumn<DateTime> fechaMontaje = GeneratedColumn<DateTime>(
    'fecha_montaje',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _horoMontajeMeta = const VerificationMeta(
    'horoMontaje',
  );
  @override
  late final GeneratedColumn<double> horoMontaje = GeneratedColumn<double>(
    'horo_montaje',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kmMontajeMeta = const VerificationMeta(
    'kmMontaje',
  );
  @override
  late final GeneratedColumn<double> kmMontaje = GeneratedColumn<double>(
    'km_montaje',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoLlantaIdMeta = const VerificationMeta(
    'tipoLlantaId',
  );
  @override
  late final GeneratedColumn<String> tipoLlantaId = GeneratedColumn<String>(
    'tipo_llanta_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente_variables (id)',
    ),
  );
  static const VerificationMeta _marcaLlantaIdMeta = const VerificationMeta(
    'marcaLlantaId',
  );
  @override
  late final GeneratedColumn<String> marcaLlantaId = GeneratedColumn<String>(
    'marca_llanta_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente_variables (id)',
    ),
  );
  static const VerificationMeta _dimensionLlantaIdMeta = const VerificationMeta(
    'dimensionLlantaId',
  );
  @override
  late final GeneratedColumn<String> dimensionLlantaId =
      GeneratedColumn<String>(
        'dimension_llanta_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cliente_variables (id)',
        ),
      );
  static const VerificationMeta _disenoLlantaIdMeta = const VerificationMeta(
    'disenoLlantaId',
  );
  @override
  late final GeneratedColumn<String> disenoLlantaId = GeneratedColumn<String>(
    'diseno_llanta_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente_variables (id)',
    ),
  );
  static const VerificationMeta _posicionMeta = const VerificationMeta(
    'posicion',
  );
  @override
  late final GeneratedColumn<int> posicion = GeneratedColumn<int>(
    'posicion',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presionMeta = const VerificationMeta(
    'presion',
  );
  @override
  late final GeneratedColumn<double> presion = GeneratedColumn<double>(
    'presion',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medidaIntMeta = const VerificationMeta(
    'medidaInt',
  );
  @override
  late final GeneratedColumn<double> medidaInt = GeneratedColumn<double>(
    'medida_int',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medidaCentMeta = const VerificationMeta(
    'medidaCent',
  );
  @override
  late final GeneratedColumn<double> medidaCent = GeneratedColumn<double>(
    'medida_cent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medidaExtMeta = const VerificationMeta(
    'medidaExt',
  );
  @override
  late final GeneratedColumn<double> medidaExt = GeneratedColumn<double>(
    'medida_ext',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observacionMeta = const VerificationMeta(
    'observacion',
  );
  @override
  late final GeneratedColumn<String> observacion = GeneratedColumn<String>(
    'observacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _creadaLocalMeta = const VerificationMeta(
    'creadaLocal',
  );
  @override
  late final GeneratedColumn<bool> creadaLocal = GeneratedColumn<bool>(
    'creada_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("creada_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspeccionId,
    vehiculoId,
    codigoLlanta,
    fechaMontaje,
    horoMontaje,
    kmMontaje,
    tipoLlantaId,
    marcaLlantaId,
    dimensionLlantaId,
    disenoLlantaId,
    posicion,
    presion,
    medidaInt,
    medidaCent,
    medidaExt,
    observacion,
    createdAt,
    updatedAt,
    creadaLocal,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspeccion_llantas';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspeccionLlanta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inspeccion_id')) {
      context.handle(
        _inspeccionIdMeta,
        inspeccionId.isAcceptableOrUnknown(
          data['inspeccion_id']!,
          _inspeccionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspeccionIdMeta);
    }
    if (data.containsKey('vehiculo_id')) {
      context.handle(
        _vehiculoIdMeta,
        vehiculoId.isAcceptableOrUnknown(data['vehiculo_id']!, _vehiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    if (data.containsKey('codigo_llanta')) {
      context.handle(
        _codigoLlantaMeta,
        codigoLlanta.isAcceptableOrUnknown(
          data['codigo_llanta']!,
          _codigoLlantaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codigoLlantaMeta);
    }
    if (data.containsKey('fecha_montaje')) {
      context.handle(
        _fechaMontajeMeta,
        fechaMontaje.isAcceptableOrUnknown(
          data['fecha_montaje']!,
          _fechaMontajeMeta,
        ),
      );
    }
    if (data.containsKey('horo_montaje')) {
      context.handle(
        _horoMontajeMeta,
        horoMontaje.isAcceptableOrUnknown(
          data['horo_montaje']!,
          _horoMontajeMeta,
        ),
      );
    }
    if (data.containsKey('km_montaje')) {
      context.handle(
        _kmMontajeMeta,
        kmMontaje.isAcceptableOrUnknown(data['km_montaje']!, _kmMontajeMeta),
      );
    }
    if (data.containsKey('tipo_llanta_id')) {
      context.handle(
        _tipoLlantaIdMeta,
        tipoLlantaId.isAcceptableOrUnknown(
          data['tipo_llanta_id']!,
          _tipoLlantaIdMeta,
        ),
      );
    }
    if (data.containsKey('marca_llanta_id')) {
      context.handle(
        _marcaLlantaIdMeta,
        marcaLlantaId.isAcceptableOrUnknown(
          data['marca_llanta_id']!,
          _marcaLlantaIdMeta,
        ),
      );
    }
    if (data.containsKey('dimension_llanta_id')) {
      context.handle(
        _dimensionLlantaIdMeta,
        dimensionLlantaId.isAcceptableOrUnknown(
          data['dimension_llanta_id']!,
          _dimensionLlantaIdMeta,
        ),
      );
    }
    if (data.containsKey('diseno_llanta_id')) {
      context.handle(
        _disenoLlantaIdMeta,
        disenoLlantaId.isAcceptableOrUnknown(
          data['diseno_llanta_id']!,
          _disenoLlantaIdMeta,
        ),
      );
    }
    if (data.containsKey('posicion')) {
      context.handle(
        _posicionMeta,
        posicion.isAcceptableOrUnknown(data['posicion']!, _posicionMeta),
      );
    } else if (isInserting) {
      context.missing(_posicionMeta);
    }
    if (data.containsKey('presion')) {
      context.handle(
        _presionMeta,
        presion.isAcceptableOrUnknown(data['presion']!, _presionMeta),
      );
    }
    if (data.containsKey('medida_int')) {
      context.handle(
        _medidaIntMeta,
        medidaInt.isAcceptableOrUnknown(data['medida_int']!, _medidaIntMeta),
      );
    }
    if (data.containsKey('medida_cent')) {
      context.handle(
        _medidaCentMeta,
        medidaCent.isAcceptableOrUnknown(data['medida_cent']!, _medidaCentMeta),
      );
    }
    if (data.containsKey('medida_ext')) {
      context.handle(
        _medidaExtMeta,
        medidaExt.isAcceptableOrUnknown(data['medida_ext']!, _medidaExtMeta),
      );
    }
    if (data.containsKey('observacion')) {
      context.handle(
        _observacionMeta,
        observacion.isAcceptableOrUnknown(
          data['observacion']!,
          _observacionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('creada_local')) {
      context.handle(
        _creadaLocalMeta,
        creadaLocal.isAcceptableOrUnknown(
          data['creada_local']!,
          _creadaLocalMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {inspeccionId, vehiculoId, posicion},
  ];
  @override
  InspeccionLlanta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspeccionLlanta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inspeccionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspeccion_id'],
      )!,
      vehiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_id'],
      )!,
      codigoLlanta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_llanta'],
      )!,
      fechaMontaje: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_montaje'],
      ),
      horoMontaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}horo_montaje'],
      ),
      kmMontaje: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}km_montaje'],
      ),
      tipoLlantaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_llanta_id'],
      ),
      marcaLlantaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca_llanta_id'],
      ),
      dimensionLlantaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dimension_llanta_id'],
      ),
      disenoLlantaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diseno_llanta_id'],
      ),
      posicion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posicion'],
      )!,
      presion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}presion'],
      ),
      medidaInt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}medida_int'],
      ),
      medidaCent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}medida_cent'],
      ),
      medidaExt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}medida_ext'],
      ),
      observacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacion'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      creadaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}creada_local'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $InspeccionLlantasTable createAlias(String alias) {
    return $InspeccionLlantasTable(attachedDatabase, alias);
  }
}

class InspeccionLlanta extends DataClass
    implements Insertable<InspeccionLlanta> {
  final String id;
  final String inspeccionId;
  final String vehiculoId;
  final String codigoLlanta;
  final DateTime? fechaMontaje;
  final double? horoMontaje;
  final double? kmMontaje;
  final String? tipoLlantaId;
  final String? marcaLlantaId;
  final String? dimensionLlantaId;
  final String? disenoLlantaId;
  final int posicion;
  final double? presion;
  final double? medidaInt;
  final double? medidaCent;
  final double? medidaExt;
  final String? observacion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool creadaLocal;
  final bool pendienteSync;
  const InspeccionLlanta({
    required this.id,
    required this.inspeccionId,
    required this.vehiculoId,
    required this.codigoLlanta,
    this.fechaMontaje,
    this.horoMontaje,
    this.kmMontaje,
    this.tipoLlantaId,
    this.marcaLlantaId,
    this.dimensionLlantaId,
    this.disenoLlantaId,
    required this.posicion,
    this.presion,
    this.medidaInt,
    this.medidaCent,
    this.medidaExt,
    this.observacion,
    required this.createdAt,
    required this.updatedAt,
    required this.creadaLocal,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inspeccion_id'] = Variable<String>(inspeccionId);
    map['vehiculo_id'] = Variable<String>(vehiculoId);
    map['codigo_llanta'] = Variable<String>(codigoLlanta);
    if (!nullToAbsent || fechaMontaje != null) {
      map['fecha_montaje'] = Variable<DateTime>(fechaMontaje);
    }
    if (!nullToAbsent || horoMontaje != null) {
      map['horo_montaje'] = Variable<double>(horoMontaje);
    }
    if (!nullToAbsent || kmMontaje != null) {
      map['km_montaje'] = Variable<double>(kmMontaje);
    }
    if (!nullToAbsent || tipoLlantaId != null) {
      map['tipo_llanta_id'] = Variable<String>(tipoLlantaId);
    }
    if (!nullToAbsent || marcaLlantaId != null) {
      map['marca_llanta_id'] = Variable<String>(marcaLlantaId);
    }
    if (!nullToAbsent || dimensionLlantaId != null) {
      map['dimension_llanta_id'] = Variable<String>(dimensionLlantaId);
    }
    if (!nullToAbsent || disenoLlantaId != null) {
      map['diseno_llanta_id'] = Variable<String>(disenoLlantaId);
    }
    map['posicion'] = Variable<int>(posicion);
    if (!nullToAbsent || presion != null) {
      map['presion'] = Variable<double>(presion);
    }
    if (!nullToAbsent || medidaInt != null) {
      map['medida_int'] = Variable<double>(medidaInt);
    }
    if (!nullToAbsent || medidaCent != null) {
      map['medida_cent'] = Variable<double>(medidaCent);
    }
    if (!nullToAbsent || medidaExt != null) {
      map['medida_ext'] = Variable<double>(medidaExt);
    }
    if (!nullToAbsent || observacion != null) {
      map['observacion'] = Variable<String>(observacion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['creada_local'] = Variable<bool>(creadaLocal);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  InspeccionLlantasCompanion toCompanion(bool nullToAbsent) {
    return InspeccionLlantasCompanion(
      id: Value(id),
      inspeccionId: Value(inspeccionId),
      vehiculoId: Value(vehiculoId),
      codigoLlanta: Value(codigoLlanta),
      fechaMontaje: fechaMontaje == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaMontaje),
      horoMontaje: horoMontaje == null && nullToAbsent
          ? const Value.absent()
          : Value(horoMontaje),
      kmMontaje: kmMontaje == null && nullToAbsent
          ? const Value.absent()
          : Value(kmMontaje),
      tipoLlantaId: tipoLlantaId == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoLlantaId),
      marcaLlantaId: marcaLlantaId == null && nullToAbsent
          ? const Value.absent()
          : Value(marcaLlantaId),
      dimensionLlantaId: dimensionLlantaId == null && nullToAbsent
          ? const Value.absent()
          : Value(dimensionLlantaId),
      disenoLlantaId: disenoLlantaId == null && nullToAbsent
          ? const Value.absent()
          : Value(disenoLlantaId),
      posicion: Value(posicion),
      presion: presion == null && nullToAbsent
          ? const Value.absent()
          : Value(presion),
      medidaInt: medidaInt == null && nullToAbsent
          ? const Value.absent()
          : Value(medidaInt),
      medidaCent: medidaCent == null && nullToAbsent
          ? const Value.absent()
          : Value(medidaCent),
      medidaExt: medidaExt == null && nullToAbsent
          ? const Value.absent()
          : Value(medidaExt),
      observacion: observacion == null && nullToAbsent
          ? const Value.absent()
          : Value(observacion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creadaLocal: Value(creadaLocal),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory InspeccionLlanta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspeccionLlanta(
      id: serializer.fromJson<String>(json['id']),
      inspeccionId: serializer.fromJson<String>(json['inspeccionId']),
      vehiculoId: serializer.fromJson<String>(json['vehiculoId']),
      codigoLlanta: serializer.fromJson<String>(json['codigoLlanta']),
      fechaMontaje: serializer.fromJson<DateTime?>(json['fechaMontaje']),
      horoMontaje: serializer.fromJson<double?>(json['horoMontaje']),
      kmMontaje: serializer.fromJson<double?>(json['kmMontaje']),
      tipoLlantaId: serializer.fromJson<String?>(json['tipoLlantaId']),
      marcaLlantaId: serializer.fromJson<String?>(json['marcaLlantaId']),
      dimensionLlantaId: serializer.fromJson<String?>(
        json['dimensionLlantaId'],
      ),
      disenoLlantaId: serializer.fromJson<String?>(json['disenoLlantaId']),
      posicion: serializer.fromJson<int>(json['posicion']),
      presion: serializer.fromJson<double?>(json['presion']),
      medidaInt: serializer.fromJson<double?>(json['medidaInt']),
      medidaCent: serializer.fromJson<double?>(json['medidaCent']),
      medidaExt: serializer.fromJson<double?>(json['medidaExt']),
      observacion: serializer.fromJson<String?>(json['observacion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      creadaLocal: serializer.fromJson<bool>(json['creadaLocal']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inspeccionId': serializer.toJson<String>(inspeccionId),
      'vehiculoId': serializer.toJson<String>(vehiculoId),
      'codigoLlanta': serializer.toJson<String>(codigoLlanta),
      'fechaMontaje': serializer.toJson<DateTime?>(fechaMontaje),
      'horoMontaje': serializer.toJson<double?>(horoMontaje),
      'kmMontaje': serializer.toJson<double?>(kmMontaje),
      'tipoLlantaId': serializer.toJson<String?>(tipoLlantaId),
      'marcaLlantaId': serializer.toJson<String?>(marcaLlantaId),
      'dimensionLlantaId': serializer.toJson<String?>(dimensionLlantaId),
      'disenoLlantaId': serializer.toJson<String?>(disenoLlantaId),
      'posicion': serializer.toJson<int>(posicion),
      'presion': serializer.toJson<double?>(presion),
      'medidaInt': serializer.toJson<double?>(medidaInt),
      'medidaCent': serializer.toJson<double?>(medidaCent),
      'medidaExt': serializer.toJson<double?>(medidaExt),
      'observacion': serializer.toJson<String?>(observacion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'creadaLocal': serializer.toJson<bool>(creadaLocal),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  InspeccionLlanta copyWith({
    String? id,
    String? inspeccionId,
    String? vehiculoId,
    String? codigoLlanta,
    Value<DateTime?> fechaMontaje = const Value.absent(),
    Value<double?> horoMontaje = const Value.absent(),
    Value<double?> kmMontaje = const Value.absent(),
    Value<String?> tipoLlantaId = const Value.absent(),
    Value<String?> marcaLlantaId = const Value.absent(),
    Value<String?> dimensionLlantaId = const Value.absent(),
    Value<String?> disenoLlantaId = const Value.absent(),
    int? posicion,
    Value<double?> presion = const Value.absent(),
    Value<double?> medidaInt = const Value.absent(),
    Value<double?> medidaCent = const Value.absent(),
    Value<double?> medidaExt = const Value.absent(),
    Value<String?> observacion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? creadaLocal,
    bool? pendienteSync,
  }) => InspeccionLlanta(
    id: id ?? this.id,
    inspeccionId: inspeccionId ?? this.inspeccionId,
    vehiculoId: vehiculoId ?? this.vehiculoId,
    codigoLlanta: codigoLlanta ?? this.codigoLlanta,
    fechaMontaje: fechaMontaje.present ? fechaMontaje.value : this.fechaMontaje,
    horoMontaje: horoMontaje.present ? horoMontaje.value : this.horoMontaje,
    kmMontaje: kmMontaje.present ? kmMontaje.value : this.kmMontaje,
    tipoLlantaId: tipoLlantaId.present ? tipoLlantaId.value : this.tipoLlantaId,
    marcaLlantaId: marcaLlantaId.present
        ? marcaLlantaId.value
        : this.marcaLlantaId,
    dimensionLlantaId: dimensionLlantaId.present
        ? dimensionLlantaId.value
        : this.dimensionLlantaId,
    disenoLlantaId: disenoLlantaId.present
        ? disenoLlantaId.value
        : this.disenoLlantaId,
    posicion: posicion ?? this.posicion,
    presion: presion.present ? presion.value : this.presion,
    medidaInt: medidaInt.present ? medidaInt.value : this.medidaInt,
    medidaCent: medidaCent.present ? medidaCent.value : this.medidaCent,
    medidaExt: medidaExt.present ? medidaExt.value : this.medidaExt,
    observacion: observacion.present ? observacion.value : this.observacion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    creadaLocal: creadaLocal ?? this.creadaLocal,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  InspeccionLlanta copyWithCompanion(InspeccionLlantasCompanion data) {
    return InspeccionLlanta(
      id: data.id.present ? data.id.value : this.id,
      inspeccionId: data.inspeccionId.present
          ? data.inspeccionId.value
          : this.inspeccionId,
      vehiculoId: data.vehiculoId.present
          ? data.vehiculoId.value
          : this.vehiculoId,
      codigoLlanta: data.codigoLlanta.present
          ? data.codigoLlanta.value
          : this.codigoLlanta,
      fechaMontaje: data.fechaMontaje.present
          ? data.fechaMontaje.value
          : this.fechaMontaje,
      horoMontaje: data.horoMontaje.present
          ? data.horoMontaje.value
          : this.horoMontaje,
      kmMontaje: data.kmMontaje.present ? data.kmMontaje.value : this.kmMontaje,
      tipoLlantaId: data.tipoLlantaId.present
          ? data.tipoLlantaId.value
          : this.tipoLlantaId,
      marcaLlantaId: data.marcaLlantaId.present
          ? data.marcaLlantaId.value
          : this.marcaLlantaId,
      dimensionLlantaId: data.dimensionLlantaId.present
          ? data.dimensionLlantaId.value
          : this.dimensionLlantaId,
      disenoLlantaId: data.disenoLlantaId.present
          ? data.disenoLlantaId.value
          : this.disenoLlantaId,
      posicion: data.posicion.present ? data.posicion.value : this.posicion,
      presion: data.presion.present ? data.presion.value : this.presion,
      medidaInt: data.medidaInt.present ? data.medidaInt.value : this.medidaInt,
      medidaCent: data.medidaCent.present
          ? data.medidaCent.value
          : this.medidaCent,
      medidaExt: data.medidaExt.present ? data.medidaExt.value : this.medidaExt,
      observacion: data.observacion.present
          ? data.observacion.value
          : this.observacion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      creadaLocal: data.creadaLocal.present
          ? data.creadaLocal.value
          : this.creadaLocal,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionLlanta(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('codigoLlanta: $codigoLlanta, ')
          ..write('fechaMontaje: $fechaMontaje, ')
          ..write('horoMontaje: $horoMontaje, ')
          ..write('kmMontaje: $kmMontaje, ')
          ..write('tipoLlantaId: $tipoLlantaId, ')
          ..write('marcaLlantaId: $marcaLlantaId, ')
          ..write('dimensionLlantaId: $dimensionLlantaId, ')
          ..write('disenoLlantaId: $disenoLlantaId, ')
          ..write('posicion: $posicion, ')
          ..write('presion: $presion, ')
          ..write('medidaInt: $medidaInt, ')
          ..write('medidaCent: $medidaCent, ')
          ..write('medidaExt: $medidaExt, ')
          ..write('observacion: $observacion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    inspeccionId,
    vehiculoId,
    codigoLlanta,
    fechaMontaje,
    horoMontaje,
    kmMontaje,
    tipoLlantaId,
    marcaLlantaId,
    dimensionLlantaId,
    disenoLlantaId,
    posicion,
    presion,
    medidaInt,
    medidaCent,
    medidaExt,
    observacion,
    createdAt,
    updatedAt,
    creadaLocal,
    pendienteSync,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspeccionLlanta &&
          other.id == this.id &&
          other.inspeccionId == this.inspeccionId &&
          other.vehiculoId == this.vehiculoId &&
          other.codigoLlanta == this.codigoLlanta &&
          other.fechaMontaje == this.fechaMontaje &&
          other.horoMontaje == this.horoMontaje &&
          other.kmMontaje == this.kmMontaje &&
          other.tipoLlantaId == this.tipoLlantaId &&
          other.marcaLlantaId == this.marcaLlantaId &&
          other.dimensionLlantaId == this.dimensionLlantaId &&
          other.disenoLlantaId == this.disenoLlantaId &&
          other.posicion == this.posicion &&
          other.presion == this.presion &&
          other.medidaInt == this.medidaInt &&
          other.medidaCent == this.medidaCent &&
          other.medidaExt == this.medidaExt &&
          other.observacion == this.observacion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.creadaLocal == this.creadaLocal &&
          other.pendienteSync == this.pendienteSync);
}

class InspeccionLlantasCompanion extends UpdateCompanion<InspeccionLlanta> {
  final Value<String> id;
  final Value<String> inspeccionId;
  final Value<String> vehiculoId;
  final Value<String> codigoLlanta;
  final Value<DateTime?> fechaMontaje;
  final Value<double?> horoMontaje;
  final Value<double?> kmMontaje;
  final Value<String?> tipoLlantaId;
  final Value<String?> marcaLlantaId;
  final Value<String?> dimensionLlantaId;
  final Value<String?> disenoLlantaId;
  final Value<int> posicion;
  final Value<double?> presion;
  final Value<double?> medidaInt;
  final Value<double?> medidaCent;
  final Value<double?> medidaExt;
  final Value<String?> observacion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> creadaLocal;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const InspeccionLlantasCompanion({
    this.id = const Value.absent(),
    this.inspeccionId = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.codigoLlanta = const Value.absent(),
    this.fechaMontaje = const Value.absent(),
    this.horoMontaje = const Value.absent(),
    this.kmMontaje = const Value.absent(),
    this.tipoLlantaId = const Value.absent(),
    this.marcaLlantaId = const Value.absent(),
    this.dimensionLlantaId = const Value.absent(),
    this.disenoLlantaId = const Value.absent(),
    this.posicion = const Value.absent(),
    this.presion = const Value.absent(),
    this.medidaInt = const Value.absent(),
    this.medidaCent = const Value.absent(),
    this.medidaExt = const Value.absent(),
    this.observacion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspeccionLlantasCompanion.insert({
    this.id = const Value.absent(),
    required String inspeccionId,
    required String vehiculoId,
    required String codigoLlanta,
    this.fechaMontaje = const Value.absent(),
    this.horoMontaje = const Value.absent(),
    this.kmMontaje = const Value.absent(),
    this.tipoLlantaId = const Value.absent(),
    this.marcaLlantaId = const Value.absent(),
    this.dimensionLlantaId = const Value.absent(),
    this.disenoLlantaId = const Value.absent(),
    required int posicion,
    this.presion = const Value.absent(),
    this.medidaInt = const Value.absent(),
    this.medidaCent = const Value.absent(),
    this.medidaExt = const Value.absent(),
    this.observacion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creadaLocal = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : inspeccionId = Value(inspeccionId),
       vehiculoId = Value(vehiculoId),
       codigoLlanta = Value(codigoLlanta),
       posicion = Value(posicion);
  static Insertable<InspeccionLlanta> custom({
    Expression<String>? id,
    Expression<String>? inspeccionId,
    Expression<String>? vehiculoId,
    Expression<String>? codigoLlanta,
    Expression<DateTime>? fechaMontaje,
    Expression<double>? horoMontaje,
    Expression<double>? kmMontaje,
    Expression<String>? tipoLlantaId,
    Expression<String>? marcaLlantaId,
    Expression<String>? dimensionLlantaId,
    Expression<String>? disenoLlantaId,
    Expression<int>? posicion,
    Expression<double>? presion,
    Expression<double>? medidaInt,
    Expression<double>? medidaCent,
    Expression<double>? medidaExt,
    Expression<String>? observacion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? creadaLocal,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspeccionId != null) 'inspeccion_id': inspeccionId,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (codigoLlanta != null) 'codigo_llanta': codigoLlanta,
      if (fechaMontaje != null) 'fecha_montaje': fechaMontaje,
      if (horoMontaje != null) 'horo_montaje': horoMontaje,
      if (kmMontaje != null) 'km_montaje': kmMontaje,
      if (tipoLlantaId != null) 'tipo_llanta_id': tipoLlantaId,
      if (marcaLlantaId != null) 'marca_llanta_id': marcaLlantaId,
      if (dimensionLlantaId != null) 'dimension_llanta_id': dimensionLlantaId,
      if (disenoLlantaId != null) 'diseno_llanta_id': disenoLlantaId,
      if (posicion != null) 'posicion': posicion,
      if (presion != null) 'presion': presion,
      if (medidaInt != null) 'medida_int': medidaInt,
      if (medidaCent != null) 'medida_cent': medidaCent,
      if (medidaExt != null) 'medida_ext': medidaExt,
      if (observacion != null) 'observacion': observacion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (creadaLocal != null) 'creada_local': creadaLocal,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspeccionLlantasCompanion copyWith({
    Value<String>? id,
    Value<String>? inspeccionId,
    Value<String>? vehiculoId,
    Value<String>? codigoLlanta,
    Value<DateTime?>? fechaMontaje,
    Value<double?>? horoMontaje,
    Value<double?>? kmMontaje,
    Value<String?>? tipoLlantaId,
    Value<String?>? marcaLlantaId,
    Value<String?>? dimensionLlantaId,
    Value<String?>? disenoLlantaId,
    Value<int>? posicion,
    Value<double?>? presion,
    Value<double?>? medidaInt,
    Value<double?>? medidaCent,
    Value<double?>? medidaExt,
    Value<String?>? observacion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? creadaLocal,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return InspeccionLlantasCompanion(
      id: id ?? this.id,
      inspeccionId: inspeccionId ?? this.inspeccionId,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      codigoLlanta: codigoLlanta ?? this.codigoLlanta,
      fechaMontaje: fechaMontaje ?? this.fechaMontaje,
      horoMontaje: horoMontaje ?? this.horoMontaje,
      kmMontaje: kmMontaje ?? this.kmMontaje,
      tipoLlantaId: tipoLlantaId ?? this.tipoLlantaId,
      marcaLlantaId: marcaLlantaId ?? this.marcaLlantaId,
      dimensionLlantaId: dimensionLlantaId ?? this.dimensionLlantaId,
      disenoLlantaId: disenoLlantaId ?? this.disenoLlantaId,
      posicion: posicion ?? this.posicion,
      presion: presion ?? this.presion,
      medidaInt: medidaInt ?? this.medidaInt,
      medidaCent: medidaCent ?? this.medidaCent,
      medidaExt: medidaExt ?? this.medidaExt,
      observacion: observacion ?? this.observacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creadaLocal: creadaLocal ?? this.creadaLocal,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inspeccionId.present) {
      map['inspeccion_id'] = Variable<String>(inspeccionId.value);
    }
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<String>(vehiculoId.value);
    }
    if (codigoLlanta.present) {
      map['codigo_llanta'] = Variable<String>(codigoLlanta.value);
    }
    if (fechaMontaje.present) {
      map['fecha_montaje'] = Variable<DateTime>(fechaMontaje.value);
    }
    if (horoMontaje.present) {
      map['horo_montaje'] = Variable<double>(horoMontaje.value);
    }
    if (kmMontaje.present) {
      map['km_montaje'] = Variable<double>(kmMontaje.value);
    }
    if (tipoLlantaId.present) {
      map['tipo_llanta_id'] = Variable<String>(tipoLlantaId.value);
    }
    if (marcaLlantaId.present) {
      map['marca_llanta_id'] = Variable<String>(marcaLlantaId.value);
    }
    if (dimensionLlantaId.present) {
      map['dimension_llanta_id'] = Variable<String>(dimensionLlantaId.value);
    }
    if (disenoLlantaId.present) {
      map['diseno_llanta_id'] = Variable<String>(disenoLlantaId.value);
    }
    if (posicion.present) {
      map['posicion'] = Variable<int>(posicion.value);
    }
    if (presion.present) {
      map['presion'] = Variable<double>(presion.value);
    }
    if (medidaInt.present) {
      map['medida_int'] = Variable<double>(medidaInt.value);
    }
    if (medidaCent.present) {
      map['medida_cent'] = Variable<double>(medidaCent.value);
    }
    if (medidaExt.present) {
      map['medida_ext'] = Variable<double>(medidaExt.value);
    }
    if (observacion.present) {
      map['observacion'] = Variable<String>(observacion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (creadaLocal.present) {
      map['creada_local'] = Variable<bool>(creadaLocal.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspeccionLlantasCompanion(')
          ..write('id: $id, ')
          ..write('inspeccionId: $inspeccionId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('codigoLlanta: $codigoLlanta, ')
          ..write('fechaMontaje: $fechaMontaje, ')
          ..write('horoMontaje: $horoMontaje, ')
          ..write('kmMontaje: $kmMontaje, ')
          ..write('tipoLlantaId: $tipoLlantaId, ')
          ..write('marcaLlantaId: $marcaLlantaId, ')
          ..write('dimensionLlantaId: $dimensionLlantaId, ')
          ..write('disenoLlantaId: $disenoLlantaId, ')
          ..write('posicion: $posicion, ')
          ..write('presion: $presion, ')
          ..write('medidaInt: $medidaInt, ')
          ..write('medidaCent: $medidaCent, ')
          ..write('medidaExt: $medidaExt, ')
          ..write('observacion: $observacion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creadaLocal: $creadaLocal, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncDataTable extends SyncData
    with TableInfo<$SyncDataTable, sync_data> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lastSuccessfulSyncMeta =
      const VerificationMeta('lastSuccessfulSync');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulSync =
      GeneratedColumn<DateTime>(
        'last_successful_sync',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [id, lastSuccessfulSync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_data';
  @override
  VerificationContext validateIntegrity(
    Insertable<sync_data> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_successful_sync')) {
      context.handle(
        _lastSuccessfulSyncMeta,
        lastSuccessfulSync.isAcceptableOrUnknown(
          data['last_successful_sync']!,
          _lastSuccessfulSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  sync_data map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return sync_data(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSuccessfulSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_sync'],
      ),
    );
  }

  @override
  $SyncDataTable createAlias(String alias) {
    return $SyncDataTable(attachedDatabase, alias);
  }
}

class sync_data extends DataClass implements Insertable<sync_data> {
  final int id;
  final DateTime? lastSuccessfulSync;
  const sync_data({required this.id, this.lastSuccessfulSync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSuccessfulSync != null) {
      map['last_successful_sync'] = Variable<DateTime>(lastSuccessfulSync);
    }
    return map;
  }

  SyncDataCompanion toCompanion(bool nullToAbsent) {
    return SyncDataCompanion(
      id: Value(id),
      lastSuccessfulSync: lastSuccessfulSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulSync),
    );
  }

  factory sync_data.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return sync_data(
      id: serializer.fromJson<int>(json['id']),
      lastSuccessfulSync: serializer.fromJson<DateTime?>(
        json['lastSuccessfulSync'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSuccessfulSync': serializer.toJson<DateTime?>(lastSuccessfulSync),
    };
  }

  sync_data copyWith({
    int? id,
    Value<DateTime?> lastSuccessfulSync = const Value.absent(),
  }) => sync_data(
    id: id ?? this.id,
    lastSuccessfulSync: lastSuccessfulSync.present
        ? lastSuccessfulSync.value
        : this.lastSuccessfulSync,
  );
  sync_data copyWithCompanion(SyncDataCompanion data) {
    return sync_data(
      id: data.id.present ? data.id.value : this.id,
      lastSuccessfulSync: data.lastSuccessfulSync.present
          ? data.lastSuccessfulSync.value
          : this.lastSuccessfulSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('sync_data(')
          ..write('id: $id, ')
          ..write('lastSuccessfulSync: $lastSuccessfulSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastSuccessfulSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is sync_data &&
          other.id == this.id &&
          other.lastSuccessfulSync == this.lastSuccessfulSync);
}

class SyncDataCompanion extends UpdateCompanion<sync_data> {
  final Value<int> id;
  final Value<DateTime?> lastSuccessfulSync;
  const SyncDataCompanion({
    this.id = const Value.absent(),
    this.lastSuccessfulSync = const Value.absent(),
  });
  SyncDataCompanion.insert({
    this.id = const Value.absent(),
    this.lastSuccessfulSync = const Value.absent(),
  });
  static Insertable<sync_data> custom({
    Expression<int>? id,
    Expression<DateTime>? lastSuccessfulSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSuccessfulSync != null)
        'last_successful_sync': lastSuccessfulSync,
    });
  }

  SyncDataCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? lastSuccessfulSync,
  }) {
    return SyncDataCompanion(
      id: id ?? this.id,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSuccessfulSync.present) {
      map['last_successful_sync'] = Variable<DateTime>(
        lastSuccessfulSync.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncDataCompanion(')
          ..write('id: $id, ')
          ..write('lastSuccessfulSync: $lastSuccessfulSync')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ClienteVariablesTable clienteVariables = $ClienteVariablesTable(
    this,
  );
  late final $VehiculosTable vehiculos = $VehiculosTable(this);
  late final $InspeccionesTable inspecciones = $InspeccionesTable(this);
  late final $InspeccionVehiculosTable inspeccionVehiculos =
      $InspeccionVehiculosTable(this);
  late final $InspeccionLlantasTable inspeccionLlantas =
      $InspeccionLlantasTable(this);
  late final $SyncDataTable syncData = $SyncDataTable(this);
  late final ClienteDao clienteDao = ClienteDao(this as AppDatabase);
  late final ClienteVariablesDao clienteVariablesDao = ClienteVariablesDao(
    this as AppDatabase,
  );
  late final VehiculosDao vehiculosDao = VehiculosDao(this as AppDatabase);
  late final InspeccionesDao inspeccionesDao = InspeccionesDao(
    this as AppDatabase,
  );
  late final InspeccionVehiculosDao inspeccionVehiculosDao =
      InspeccionVehiculosDao(this as AppDatabase);
  late final InspeccionLlantasDao inspeccionLlantasDao = InspeccionLlantasDao(
    this as AppDatabase,
  );
  late final SyncDataDao syncDataDao = SyncDataDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    clienteVariables,
    vehiculos,
    inspecciones,
    inspeccionVehiculos,
    inspeccionLlantas,
    syncData,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clientes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cliente_variables', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clientes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vehiculos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clientes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspecciones', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inspecciones',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspeccion_vehiculos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehiculos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspeccion_vehiculos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inspecciones',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspeccion_llantas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehiculos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inspeccion_llantas', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      Value<String> id,
      required String nombre,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ClienteVariablesTable, List<ClienteVariable>>
  _clienteVariablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clienteVariables,
    aliasName: $_aliasNameGenerator(
      db.clientes.id,
      db.clienteVariables.clienteId,
    ),
  );

  $$ClienteVariablesTableProcessedTableManager get clienteVariablesRefs {
    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _clienteVariablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VehiculosTable, List<Vehiculo>>
  _vehiculosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vehiculos,
    aliasName: $_aliasNameGenerator(db.clientes.id, db.vehiculos.clienteId),
  );

  $$VehiculosTableProcessedTableManager get vehiculosRefs {
    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiculosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InspeccionesTable, List<Inspeccion>>
  _inspeccionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspecciones,
    aliasName: $_aliasNameGenerator(db.clientes.id, db.inspecciones.clienteId),
  );

  $$InspeccionesTableProcessedTableManager get inspeccionesRefs {
    final manager = $$InspeccionesTableTableManager(
      $_db,
      $_db.inspecciones,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inspeccionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clienteVariablesRefs(
    Expression<bool> Function($$ClienteVariablesTableFilterComposer f) f,
  ) {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vehiculosRefs(
    Expression<bool> Function($$VehiculosTableFilterComposer f) f,
  ) {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inspeccionesRefs(
    Expression<bool> Function($$InspeccionesTableFilterComposer f) f,
  ) {
    final $$InspeccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableFilterComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> clienteVariablesRefs<T extends Object>(
    Expression<T> Function($$ClienteVariablesTableAnnotationComposer a) f,
  ) {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vehiculosRefs<T extends Object>(
    Expression<T> Function($$VehiculosTableAnnotationComposer a) f,
  ) {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inspeccionesRefs<T extends Object>(
    Expression<T> Function($$InspeccionesTableAnnotationComposer a) f,
  ) {
    final $$InspeccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({
            bool clienteVariablesRefs,
            bool vehiculosRefs,
            bool inspeccionesRefs,
          })
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String nombre,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteVariablesRefs = false,
                vehiculosRefs = false,
                inspeccionesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clienteVariablesRefs) db.clienteVariables,
                    if (vehiculosRefs) db.vehiculos,
                    if (inspeccionesRefs) db.inspecciones,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clienteVariablesRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          ClienteVariable
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._clienteVariablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).clienteVariablesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vehiculosRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          Vehiculo
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._vehiculosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).vehiculosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inspeccionesRefs)
                        await $_getPrefetchedData<
                          Cliente,
                          $ClientesTable,
                          Inspeccion
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableReferences
                              ._inspeccionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableReferences(
                                db,
                                table,
                                p0,
                              ).inspeccionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({
        bool clienteVariablesRefs,
        bool vehiculosRefs,
        bool inspeccionesRefs,
      })
    >;
typedef $$ClienteVariablesTableCreateCompanionBuilder =
    ClienteVariablesCompanion Function({
      Value<String> id,
      required String clienteId,
      required TipoVariableEnum tipoVariable,
      required String nombre,
      Value<DateTime> createdAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$ClienteVariablesTableUpdateCompanionBuilder =
    ClienteVariablesCompanion Function({
      Value<String> id,
      Value<String> clienteId,
      Value<TipoVariableEnum> tipoVariable,
      Value<String> nombre,
      Value<DateTime> createdAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

final class $$ClienteVariablesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ClienteVariablesTable, ClienteVariable> {
  $$ClienteVariablesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.clienteVariables.clienteId, db.clientes.id),
      );

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClienteVariablesTableFilterComposer
    extends Composer<_$AppDatabase, $ClienteVariablesTable> {
  $$ClienteVariablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoVariableEnum, TipoVariableEnum, String>
  get tipoVariable => $composableBuilder(
    column: $table.tipoVariable,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteVariablesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClienteVariablesTable> {
  $$ClienteVariablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoVariable => $composableBuilder(
    column: $table.tipoVariable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteVariablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClienteVariablesTable> {
  $$ClienteVariablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoVariableEnum, String> get tipoVariable =>
      $composableBuilder(
        column: $table.tipoVariable,
        builder: (column) => column,
      );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteVariablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClienteVariablesTable,
          ClienteVariable,
          $$ClienteVariablesTableFilterComposer,
          $$ClienteVariablesTableOrderingComposer,
          $$ClienteVariablesTableAnnotationComposer,
          $$ClienteVariablesTableCreateCompanionBuilder,
          $$ClienteVariablesTableUpdateCompanionBuilder,
          (ClienteVariable, $$ClienteVariablesTableReferences),
          ClienteVariable,
          PrefetchHooks Function({bool clienteId})
        > {
  $$ClienteVariablesTableTableManager(
    _$AppDatabase db,
    $ClienteVariablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClienteVariablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClienteVariablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClienteVariablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<TipoVariableEnum> tipoVariable = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClienteVariablesCompanion(
                id: id,
                clienteId: clienteId,
                tipoVariable: tipoVariable,
                nombre: nombre,
                createdAt: createdAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String clienteId,
                required TipoVariableEnum tipoVariable,
                required String nombre,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClienteVariablesCompanion.insert(
                id: id,
                clienteId: clienteId,
                tipoVariable: tipoVariable,
                nombre: nombre,
                createdAt: createdAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClienteVariablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clienteId,
                                referencedTable:
                                    $$ClienteVariablesTableReferences
                                        ._clienteIdTable(db),
                                referencedColumn:
                                    $$ClienteVariablesTableReferences
                                        ._clienteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClienteVariablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClienteVariablesTable,
      ClienteVariable,
      $$ClienteVariablesTableFilterComposer,
      $$ClienteVariablesTableOrderingComposer,
      $$ClienteVariablesTableAnnotationComposer,
      $$ClienteVariablesTableCreateCompanionBuilder,
      $$ClienteVariablesTableUpdateCompanionBuilder,
      (ClienteVariable, $$ClienteVariablesTableReferences),
      ClienteVariable,
      PrefetchHooks Function({bool clienteId})
    >;
typedef $$VehiculosTableCreateCompanionBuilder =
    VehiculosCompanion Function({
      Value<String> id,
      required String codigoVehiculo,
      required String clienteId,
      required String tipoId,
      required String marcaId,
      required int noLlantas,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$VehiculosTableUpdateCompanionBuilder =
    VehiculosCompanion Function({
      Value<String> id,
      Value<String> codigoVehiculo,
      Value<String> clienteId,
      Value<String> tipoId,
      Value<String> marcaId,
      Value<int> noLlantas,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

final class $$VehiculosTableReferences
    extends BaseReferences<_$AppDatabase, $VehiculosTable, Vehiculo> {
  $$VehiculosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.vehiculos.clienteId, db.clientes.id),
      );

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClienteVariablesTable _tipoIdTable(_$AppDatabase db) =>
      db.clienteVariables.createAlias(
        $_aliasNameGenerator(db.vehiculos.tipoId, db.clienteVariables.id),
      );

  $$ClienteVariablesTableProcessedTableManager get tipoId {
    final $_column = $_itemColumn<String>('tipo_id')!;

    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClienteVariablesTable _marcaIdTable(_$AppDatabase db) =>
      db.clienteVariables.createAlias(
        $_aliasNameGenerator(db.vehiculos.marcaId, db.clienteVariables.id),
      );

  $$ClienteVariablesTableProcessedTableManager get marcaId {
    final $_column = $_itemColumn<String>('marca_id')!;

    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_marcaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $InspeccionVehiculosTable,
    List<InspeccionVehiculo>
  >
  _inspeccionVehiculosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inspeccionVehiculos,
        aliasName: $_aliasNameGenerator(
          db.vehiculos.id,
          db.inspeccionVehiculos.vehiculoId,
        ),
      );

  $$InspeccionVehiculosTableProcessedTableManager get inspeccionVehiculosRefs {
    final manager = $$InspeccionVehiculosTableTableManager(
      $_db,
      $_db.inspeccionVehiculos,
    ).filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inspeccionVehiculosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InspeccionLlantasTable, List<InspeccionLlanta>>
  _inspeccionLlantasRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inspeccionLlantas,
        aliasName: $_aliasNameGenerator(
          db.vehiculos.id,
          db.inspeccionLlantas.vehiculoId,
        ),
      );

  $$InspeccionLlantasTableProcessedTableManager get inspeccionLlantasRefs {
    final manager = $$InspeccionLlantasTableTableManager(
      $_db,
      $_db.inspeccionLlantas,
    ).filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inspeccionLlantasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiculosTableFilterComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoVehiculo => $composableBuilder(
    column: $table.codigoVehiculo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get noLlantas => $composableBuilder(
    column: $table.noLlantas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableFilterComposer get tipoId {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableFilterComposer get marcaId {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.marcaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inspeccionVehiculosRefs(
    Expression<bool> Function($$InspeccionVehiculosTableFilterComposer f) f,
  ) {
    final $$InspeccionVehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspeccionVehiculos,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionVehiculosTableFilterComposer(
            $db: $db,
            $table: $db.inspeccionVehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inspeccionLlantasRefs(
    Expression<bool> Function($$InspeccionLlantasTableFilterComposer f) f,
  ) {
    final $$InspeccionLlantasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspeccionLlantas,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionLlantasTableFilterComposer(
            $db: $db,
            $table: $db.inspeccionLlantas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiculosTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoVehiculo => $composableBuilder(
    column: $table.codigoVehiculo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get noLlantas => $composableBuilder(
    column: $table.noLlantas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableOrderingComposer get tipoId {
    final $$ClienteVariablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableOrderingComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableOrderingComposer get marcaId {
    final $$ClienteVariablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.marcaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableOrderingComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehiculosTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigoVehiculo => $composableBuilder(
    column: $table.codigoVehiculo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get noLlantas =>
      $composableBuilder(column: $table.noLlantas, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableAnnotationComposer get tipoId {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableAnnotationComposer get marcaId {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.marcaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inspeccionVehiculosRefs<T extends Object>(
    Expression<T> Function($$InspeccionVehiculosTableAnnotationComposer a) f,
  ) {
    final $$InspeccionVehiculosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inspeccionVehiculos,
          getReferencedColumn: (t) => t.vehiculoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InspeccionVehiculosTableAnnotationComposer(
                $db: $db,
                $table: $db.inspeccionVehiculos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> inspeccionLlantasRefs<T extends Object>(
    Expression<T> Function($$InspeccionLlantasTableAnnotationComposer a) f,
  ) {
    final $$InspeccionLlantasTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inspeccionLlantas,
          getReferencedColumn: (t) => t.vehiculoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InspeccionLlantasTableAnnotationComposer(
                $db: $db,
                $table: $db.inspeccionLlantas,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VehiculosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiculosTable,
          Vehiculo,
          $$VehiculosTableFilterComposer,
          $$VehiculosTableOrderingComposer,
          $$VehiculosTableAnnotationComposer,
          $$VehiculosTableCreateCompanionBuilder,
          $$VehiculosTableUpdateCompanionBuilder,
          (Vehiculo, $$VehiculosTableReferences),
          Vehiculo,
          PrefetchHooks Function({
            bool clienteId,
            bool tipoId,
            bool marcaId,
            bool inspeccionVehiculosRefs,
            bool inspeccionLlantasRefs,
          })
        > {
  $$VehiculosTableTableManager(_$AppDatabase db, $VehiculosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiculosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiculosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiculosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> codigoVehiculo = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<String> tipoId = const Value.absent(),
                Value<String> marcaId = const Value.absent(),
                Value<int> noLlantas = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiculosCompanion(
                id: id,
                codigoVehiculo: codigoVehiculo,
                clienteId: clienteId,
                tipoId: tipoId,
                marcaId: marcaId,
                noLlantas: noLlantas,
                createdAt: createdAt,
                updatedAt: updatedAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String codigoVehiculo,
                required String clienteId,
                required String tipoId,
                required String marcaId,
                required int noLlantas,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiculosCompanion.insert(
                id: id,
                codigoVehiculo: codigoVehiculo,
                clienteId: clienteId,
                tipoId: tipoId,
                marcaId: marcaId,
                noLlantas: noLlantas,
                createdAt: createdAt,
                updatedAt: updatedAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiculosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                tipoId = false,
                marcaId = false,
                inspeccionVehiculosRefs = false,
                inspeccionLlantasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inspeccionVehiculosRefs) db.inspeccionVehiculos,
                    if (inspeccionLlantasRefs) db.inspeccionLlantas,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable: $$VehiculosTableReferences
                                        ._clienteIdTable(db),
                                    referencedColumn: $$VehiculosTableReferences
                                        ._clienteIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (tipoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tipoId,
                                    referencedTable: $$VehiculosTableReferences
                                        ._tipoIdTable(db),
                                    referencedColumn: $$VehiculosTableReferences
                                        ._tipoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (marcaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.marcaId,
                                    referencedTable: $$VehiculosTableReferences
                                        ._marcaIdTable(db),
                                    referencedColumn: $$VehiculosTableReferences
                                        ._marcaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inspeccionVehiculosRefs)
                        await $_getPrefetchedData<
                          Vehiculo,
                          $VehiculosTable,
                          InspeccionVehiculo
                        >(
                          currentTable: table,
                          referencedTable: $$VehiculosTableReferences
                              ._inspeccionVehiculosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).inspeccionVehiculosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inspeccionLlantasRefs)
                        await $_getPrefetchedData<
                          Vehiculo,
                          $VehiculosTable,
                          InspeccionLlanta
                        >(
                          currentTable: table,
                          referencedTable: $$VehiculosTableReferences
                              ._inspeccionLlantasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).inspeccionLlantasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiculosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiculosTable,
      Vehiculo,
      $$VehiculosTableFilterComposer,
      $$VehiculosTableOrderingComposer,
      $$VehiculosTableAnnotationComposer,
      $$VehiculosTableCreateCompanionBuilder,
      $$VehiculosTableUpdateCompanionBuilder,
      (Vehiculo, $$VehiculosTableReferences),
      Vehiculo,
      PrefetchHooks Function({
        bool clienteId,
        bool tipoId,
        bool marcaId,
        bool inspeccionVehiculosRefs,
        bool inspeccionLlantasRefs,
      })
    >;
typedef $$InspeccionesTableCreateCompanionBuilder =
    InspeccionesCompanion Function({
      Value<String> id,
      required String clienteId,
      Value<String?> nombre,
      required DateTime fechaRevision,
      Value<String> estado,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$InspeccionesTableUpdateCompanionBuilder =
    InspeccionesCompanion Function({
      Value<String> id,
      Value<String> clienteId,
      Value<String?> nombre,
      Value<DateTime> fechaRevision,
      Value<String> estado,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

final class $$InspeccionesTableReferences
    extends BaseReferences<_$AppDatabase, $InspeccionesTable, Inspeccion> {
  $$InspeccionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.inspecciones.clienteId, db.clientes.id),
      );

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $InspeccionVehiculosTable,
    List<InspeccionVehiculo>
  >
  _inspeccionVehiculosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inspeccionVehiculos,
        aliasName: $_aliasNameGenerator(
          db.inspecciones.id,
          db.inspeccionVehiculos.inspeccionId,
        ),
      );

  $$InspeccionVehiculosTableProcessedTableManager get inspeccionVehiculosRefs {
    final manager = $$InspeccionVehiculosTableTableManager(
      $_db,
      $_db.inspeccionVehiculos,
    ).filter((f) => f.inspeccionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inspeccionVehiculosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InspeccionLlantasTable, List<InspeccionLlanta>>
  _inspeccionLlantasRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inspeccionLlantas,
        aliasName: $_aliasNameGenerator(
          db.inspecciones.id,
          db.inspeccionLlantas.inspeccionId,
        ),
      );

  $$InspeccionLlantasTableProcessedTableManager get inspeccionLlantasRefs {
    final manager = $$InspeccionLlantasTableTableManager(
      $_db,
      $_db.inspeccionLlantas,
    ).filter((f) => f.inspeccionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inspeccionLlantasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InspeccionesTableFilterComposer
    extends Composer<_$AppDatabase, $InspeccionesTable> {
  $$InspeccionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaRevision => $composableBuilder(
    column: $table.fechaRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inspeccionVehiculosRefs(
    Expression<bool> Function($$InspeccionVehiculosTableFilterComposer f) f,
  ) {
    final $$InspeccionVehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspeccionVehiculos,
      getReferencedColumn: (t) => t.inspeccionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionVehiculosTableFilterComposer(
            $db: $db,
            $table: $db.inspeccionVehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inspeccionLlantasRefs(
    Expression<bool> Function($$InspeccionLlantasTableFilterComposer f) f,
  ) {
    final $$InspeccionLlantasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspeccionLlantas,
      getReferencedColumn: (t) => t.inspeccionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionLlantasTableFilterComposer(
            $db: $db,
            $table: $db.inspeccionLlantas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspeccionesTableOrderingComposer
    extends Composer<_$AppDatabase, $InspeccionesTable> {
  $$InspeccionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaRevision => $composableBuilder(
    column: $table.fechaRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspeccionesTable> {
  $$InspeccionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaRevision => $composableBuilder(
    column: $table.fechaRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inspeccionVehiculosRefs<T extends Object>(
    Expression<T> Function($$InspeccionVehiculosTableAnnotationComposer a) f,
  ) {
    final $$InspeccionVehiculosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inspeccionVehiculos,
          getReferencedColumn: (t) => t.inspeccionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InspeccionVehiculosTableAnnotationComposer(
                $db: $db,
                $table: $db.inspeccionVehiculos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> inspeccionLlantasRefs<T extends Object>(
    Expression<T> Function($$InspeccionLlantasTableAnnotationComposer a) f,
  ) {
    final $$InspeccionLlantasTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inspeccionLlantas,
          getReferencedColumn: (t) => t.inspeccionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InspeccionLlantasTableAnnotationComposer(
                $db: $db,
                $table: $db.inspeccionLlantas,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InspeccionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspeccionesTable,
          Inspeccion,
          $$InspeccionesTableFilterComposer,
          $$InspeccionesTableOrderingComposer,
          $$InspeccionesTableAnnotationComposer,
          $$InspeccionesTableCreateCompanionBuilder,
          $$InspeccionesTableUpdateCompanionBuilder,
          (Inspeccion, $$InspeccionesTableReferences),
          Inspeccion,
          PrefetchHooks Function({
            bool clienteId,
            bool inspeccionVehiculosRefs,
            bool inspeccionLlantasRefs,
          })
        > {
  $$InspeccionesTableTableManager(_$AppDatabase db, $InspeccionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspeccionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspeccionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspeccionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<String?> nombre = const Value.absent(),
                Value<DateTime> fechaRevision = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspeccionesCompanion(
                id: id,
                clienteId: clienteId,
                nombre: nombre,
                fechaRevision: fechaRevision,
                estado: estado,
                createdAt: createdAt,
                updatedAt: updatedAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String clienteId,
                Value<String?> nombre = const Value.absent(),
                required DateTime fechaRevision,
                Value<String> estado = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspeccionesCompanion.insert(
                id: id,
                clienteId: clienteId,
                nombre: nombre,
                fechaRevision: fechaRevision,
                estado: estado,
                createdAt: createdAt,
                updatedAt: updatedAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspeccionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                inspeccionVehiculosRefs = false,
                inspeccionLlantasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inspeccionVehiculosRefs) db.inspeccionVehiculos,
                    if (inspeccionLlantasRefs) db.inspeccionLlantas,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable:
                                        $$InspeccionesTableReferences
                                            ._clienteIdTable(db),
                                    referencedColumn:
                                        $$InspeccionesTableReferences
                                            ._clienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inspeccionVehiculosRefs)
                        await $_getPrefetchedData<
                          Inspeccion,
                          $InspeccionesTable,
                          InspeccionVehiculo
                        >(
                          currentTable: table,
                          referencedTable: $$InspeccionesTableReferences
                              ._inspeccionVehiculosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspeccionesTableReferences(
                                db,
                                table,
                                p0,
                              ).inspeccionVehiculosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspeccionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inspeccionLlantasRefs)
                        await $_getPrefetchedData<
                          Inspeccion,
                          $InspeccionesTable,
                          InspeccionLlanta
                        >(
                          currentTable: table,
                          referencedTable: $$InspeccionesTableReferences
                              ._inspeccionLlantasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspeccionesTableReferences(
                                db,
                                table,
                                p0,
                              ).inspeccionLlantasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspeccionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InspeccionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspeccionesTable,
      Inspeccion,
      $$InspeccionesTableFilterComposer,
      $$InspeccionesTableOrderingComposer,
      $$InspeccionesTableAnnotationComposer,
      $$InspeccionesTableCreateCompanionBuilder,
      $$InspeccionesTableUpdateCompanionBuilder,
      (Inspeccion, $$InspeccionesTableReferences),
      Inspeccion,
      PrefetchHooks Function({
        bool clienteId,
        bool inspeccionVehiculosRefs,
        bool inspeccionLlantasRefs,
      })
    >;
typedef $$InspeccionVehiculosTableCreateCompanionBuilder =
    InspeccionVehiculosCompanion Function({
      Value<String> id,
      required String inspeccionId,
      required String vehiculoId,
      Value<double?> horometro,
      Value<double?> kilometraje,
      Value<DateTime> createdAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$InspeccionVehiculosTableUpdateCompanionBuilder =
    InspeccionVehiculosCompanion Function({
      Value<String> id,
      Value<String> inspeccionId,
      Value<String> vehiculoId,
      Value<double?> horometro,
      Value<double?> kilometraje,
      Value<DateTime> createdAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

final class $$InspeccionVehiculosTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InspeccionVehiculosTable,
          InspeccionVehiculo
        > {
  $$InspeccionVehiculosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InspeccionesTable _inspeccionIdTable(_$AppDatabase db) =>
      db.inspecciones.createAlias(
        $_aliasNameGenerator(
          db.inspeccionVehiculos.inspeccionId,
          db.inspecciones.id,
        ),
      );

  $$InspeccionesTableProcessedTableManager get inspeccionId {
    final $_column = $_itemColumn<String>('inspeccion_id')!;

    final manager = $$InspeccionesTableTableManager(
      $_db,
      $_db.inspecciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspeccionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiculosTable _vehiculoIdTable(_$AppDatabase db) =>
      db.vehiculos.createAlias(
        $_aliasNameGenerator(
          db.inspeccionVehiculos.vehiculoId,
          db.vehiculos.id,
        ),
      );

  $$VehiculosTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<String>('vehiculo_id')!;

    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InspeccionVehiculosTableFilterComposer
    extends Composer<_$AppDatabase, $InspeccionVehiculosTable> {
  $$InspeccionVehiculosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get horometro => $composableBuilder(
    column: $table.horometro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kilometraje => $composableBuilder(
    column: $table.kilometraje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );

  $$InspeccionesTableFilterComposer get inspeccionId {
    final $$InspeccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspeccionId,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableFilterComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableFilterComposer get vehiculoId {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionVehiculosTableOrderingComposer
    extends Composer<_$AppDatabase, $InspeccionVehiculosTable> {
  $$InspeccionVehiculosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get horometro => $composableBuilder(
    column: $table.horometro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kilometraje => $composableBuilder(
    column: $table.kilometraje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspeccionesTableOrderingComposer get inspeccionId {
    final $$InspeccionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspeccionId,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableOrderingComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableOrderingComposer get vehiculoId {
    final $$VehiculosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableOrderingComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionVehiculosTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspeccionVehiculosTable> {
  $$InspeccionVehiculosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get horometro =>
      $composableBuilder(column: $table.horometro, builder: (column) => column);

  GeneratedColumn<double> get kilometraje => $composableBuilder(
    column: $table.kilometraje,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );

  $$InspeccionesTableAnnotationComposer get inspeccionId {
    final $$InspeccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspeccionId,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableAnnotationComposer get vehiculoId {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionVehiculosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspeccionVehiculosTable,
          InspeccionVehiculo,
          $$InspeccionVehiculosTableFilterComposer,
          $$InspeccionVehiculosTableOrderingComposer,
          $$InspeccionVehiculosTableAnnotationComposer,
          $$InspeccionVehiculosTableCreateCompanionBuilder,
          $$InspeccionVehiculosTableUpdateCompanionBuilder,
          (InspeccionVehiculo, $$InspeccionVehiculosTableReferences),
          InspeccionVehiculo,
          PrefetchHooks Function({bool inspeccionId, bool vehiculoId})
        > {
  $$InspeccionVehiculosTableTableManager(
    _$AppDatabase db,
    $InspeccionVehiculosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspeccionVehiculosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspeccionVehiculosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InspeccionVehiculosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspeccionId = const Value.absent(),
                Value<String> vehiculoId = const Value.absent(),
                Value<double?> horometro = const Value.absent(),
                Value<double?> kilometraje = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspeccionVehiculosCompanion(
                id: id,
                inspeccionId: inspeccionId,
                vehiculoId: vehiculoId,
                horometro: horometro,
                kilometraje: kilometraje,
                createdAt: createdAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String inspeccionId,
                required String vehiculoId,
                Value<double?> horometro = const Value.absent(),
                Value<double?> kilometraje = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspeccionVehiculosCompanion.insert(
                id: id,
                inspeccionId: inspeccionId,
                vehiculoId: vehiculoId,
                horometro: horometro,
                kilometraje: kilometraje,
                createdAt: createdAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspeccionVehiculosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspeccionId = false, vehiculoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspeccionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.inspeccionId,
                                referencedTable:
                                    $$InspeccionVehiculosTableReferences
                                        ._inspeccionIdTable(db),
                                referencedColumn:
                                    $$InspeccionVehiculosTableReferences
                                        ._inspeccionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (vehiculoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehiculoId,
                                referencedTable:
                                    $$InspeccionVehiculosTableReferences
                                        ._vehiculoIdTable(db),
                                referencedColumn:
                                    $$InspeccionVehiculosTableReferences
                                        ._vehiculoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InspeccionVehiculosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspeccionVehiculosTable,
      InspeccionVehiculo,
      $$InspeccionVehiculosTableFilterComposer,
      $$InspeccionVehiculosTableOrderingComposer,
      $$InspeccionVehiculosTableAnnotationComposer,
      $$InspeccionVehiculosTableCreateCompanionBuilder,
      $$InspeccionVehiculosTableUpdateCompanionBuilder,
      (InspeccionVehiculo, $$InspeccionVehiculosTableReferences),
      InspeccionVehiculo,
      PrefetchHooks Function({bool inspeccionId, bool vehiculoId})
    >;
typedef $$InspeccionLlantasTableCreateCompanionBuilder =
    InspeccionLlantasCompanion Function({
      Value<String> id,
      required String inspeccionId,
      required String vehiculoId,
      required String codigoLlanta,
      Value<DateTime?> fechaMontaje,
      Value<double?> horoMontaje,
      Value<double?> kmMontaje,
      Value<String?> tipoLlantaId,
      Value<String?> marcaLlantaId,
      Value<String?> dimensionLlantaId,
      Value<String?> disenoLlantaId,
      required int posicion,
      Value<double?> presion,
      Value<double?> medidaInt,
      Value<double?> medidaCent,
      Value<double?> medidaExt,
      Value<String?> observacion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$InspeccionLlantasTableUpdateCompanionBuilder =
    InspeccionLlantasCompanion Function({
      Value<String> id,
      Value<String> inspeccionId,
      Value<String> vehiculoId,
      Value<String> codigoLlanta,
      Value<DateTime?> fechaMontaje,
      Value<double?> horoMontaje,
      Value<double?> kmMontaje,
      Value<String?> tipoLlantaId,
      Value<String?> marcaLlantaId,
      Value<String?> dimensionLlantaId,
      Value<String?> disenoLlantaId,
      Value<int> posicion,
      Value<double?> presion,
      Value<double?> medidaInt,
      Value<double?> medidaCent,
      Value<double?> medidaExt,
      Value<String?> observacion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> creadaLocal,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

final class $$InspeccionLlantasTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InspeccionLlantasTable,
          InspeccionLlanta
        > {
  $$InspeccionLlantasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InspeccionesTable _inspeccionIdTable(_$AppDatabase db) =>
      db.inspecciones.createAlias(
        $_aliasNameGenerator(
          db.inspeccionLlantas.inspeccionId,
          db.inspecciones.id,
        ),
      );

  $$InspeccionesTableProcessedTableManager get inspeccionId {
    final $_column = $_itemColumn<String>('inspeccion_id')!;

    final manager = $$InspeccionesTableTableManager(
      $_db,
      $_db.inspecciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspeccionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiculosTable _vehiculoIdTable(_$AppDatabase db) =>
      db.vehiculos.createAlias(
        $_aliasNameGenerator(db.inspeccionLlantas.vehiculoId, db.vehiculos.id),
      );

  $$VehiculosTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<String>('vehiculo_id')!;

    final manager = $$VehiculosTableTableManager(
      $_db,
      $_db.vehiculos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClienteVariablesTable _tipoLlantaIdTable(_$AppDatabase db) =>
      db.clienteVariables.createAlias(
        $_aliasNameGenerator(
          db.inspeccionLlantas.tipoLlantaId,
          db.clienteVariables.id,
        ),
      );

  $$ClienteVariablesTableProcessedTableManager? get tipoLlantaId {
    final $_column = $_itemColumn<String>('tipo_llanta_id');
    if ($_column == null) return null;
    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoLlantaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClienteVariablesTable _marcaLlantaIdTable(_$AppDatabase db) =>
      db.clienteVariables.createAlias(
        $_aliasNameGenerator(
          db.inspeccionLlantas.marcaLlantaId,
          db.clienteVariables.id,
        ),
      );

  $$ClienteVariablesTableProcessedTableManager? get marcaLlantaId {
    final $_column = $_itemColumn<String>('marca_llanta_id');
    if ($_column == null) return null;
    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_marcaLlantaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClienteVariablesTable _dimensionLlantaIdTable(_$AppDatabase db) =>
      db.clienteVariables.createAlias(
        $_aliasNameGenerator(
          db.inspeccionLlantas.dimensionLlantaId,
          db.clienteVariables.id,
        ),
      );

  $$ClienteVariablesTableProcessedTableManager? get dimensionLlantaId {
    final $_column = $_itemColumn<String>('dimension_llanta_id');
    if ($_column == null) return null;
    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dimensionLlantaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClienteVariablesTable _disenoLlantaIdTable(_$AppDatabase db) =>
      db.clienteVariables.createAlias(
        $_aliasNameGenerator(
          db.inspeccionLlantas.disenoLlantaId,
          db.clienteVariables.id,
        ),
      );

  $$ClienteVariablesTableProcessedTableManager? get disenoLlantaId {
    final $_column = $_itemColumn<String>('diseno_llanta_id');
    if ($_column == null) return null;
    final manager = $$ClienteVariablesTableTableManager(
      $_db,
      $_db.clienteVariables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_disenoLlantaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InspeccionLlantasTableFilterComposer
    extends Composer<_$AppDatabase, $InspeccionLlantasTable> {
  $$InspeccionLlantasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoLlanta => $composableBuilder(
    column: $table.codigoLlanta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaMontaje => $composableBuilder(
    column: $table.fechaMontaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get horoMontaje => $composableBuilder(
    column: $table.horoMontaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kmMontaje => $composableBuilder(
    column: $table.kmMontaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get presion => $composableBuilder(
    column: $table.presion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get medidaInt => $composableBuilder(
    column: $table.medidaInt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get medidaCent => $composableBuilder(
    column: $table.medidaCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get medidaExt => $composableBuilder(
    column: $table.medidaExt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacion => $composableBuilder(
    column: $table.observacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );

  $$InspeccionesTableFilterComposer get inspeccionId {
    final $$InspeccionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspeccionId,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableFilterComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableFilterComposer get vehiculoId {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableFilterComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableFilterComposer get tipoLlantaId {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableFilterComposer get marcaLlantaId {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.marcaLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableFilterComposer get dimensionLlantaId {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dimensionLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableFilterComposer get disenoLlantaId {
    final $$ClienteVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disenoLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableFilterComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionLlantasTableOrderingComposer
    extends Composer<_$AppDatabase, $InspeccionLlantasTable> {
  $$InspeccionLlantasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoLlanta => $composableBuilder(
    column: $table.codigoLlanta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaMontaje => $composableBuilder(
    column: $table.fechaMontaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get horoMontaje => $composableBuilder(
    column: $table.horoMontaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kmMontaje => $composableBuilder(
    column: $table.kmMontaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get presion => $composableBuilder(
    column: $table.presion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get medidaInt => $composableBuilder(
    column: $table.medidaInt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get medidaCent => $composableBuilder(
    column: $table.medidaCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get medidaExt => $composableBuilder(
    column: $table.medidaExt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacion => $composableBuilder(
    column: $table.observacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspeccionesTableOrderingComposer get inspeccionId {
    final $$InspeccionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspeccionId,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableOrderingComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableOrderingComposer get vehiculoId {
    final $$VehiculosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableOrderingComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableOrderingComposer get tipoLlantaId {
    final $$ClienteVariablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableOrderingComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableOrderingComposer get marcaLlantaId {
    final $$ClienteVariablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.marcaLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableOrderingComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableOrderingComposer get dimensionLlantaId {
    final $$ClienteVariablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dimensionLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableOrderingComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableOrderingComposer get disenoLlantaId {
    final $$ClienteVariablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disenoLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableOrderingComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionLlantasTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspeccionLlantasTable> {
  $$InspeccionLlantasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigoLlanta => $composableBuilder(
    column: $table.codigoLlanta,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaMontaje => $composableBuilder(
    column: $table.fechaMontaje,
    builder: (column) => column,
  );

  GeneratedColumn<double> get horoMontaje => $composableBuilder(
    column: $table.horoMontaje,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kmMontaje =>
      $composableBuilder(column: $table.kmMontaje, builder: (column) => column);

  GeneratedColumn<int> get posicion =>
      $composableBuilder(column: $table.posicion, builder: (column) => column);

  GeneratedColumn<double> get presion =>
      $composableBuilder(column: $table.presion, builder: (column) => column);

  GeneratedColumn<double> get medidaInt =>
      $composableBuilder(column: $table.medidaInt, builder: (column) => column);

  GeneratedColumn<double> get medidaCent => $composableBuilder(
    column: $table.medidaCent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get medidaExt =>
      $composableBuilder(column: $table.medidaExt, builder: (column) => column);

  GeneratedColumn<String> get observacion => $composableBuilder(
    column: $table.observacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get creadaLocal => $composableBuilder(
    column: $table.creadaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );

  $$InspeccionesTableAnnotationComposer get inspeccionId {
    final $$InspeccionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspeccionId,
      referencedTable: $db.inspecciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspeccionesTableAnnotationComposer(
            $db: $db,
            $table: $db.inspecciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiculosTableAnnotationComposer get vehiculoId {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableAnnotationComposer get tipoLlantaId {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableAnnotationComposer get marcaLlantaId {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.marcaLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableAnnotationComposer get dimensionLlantaId {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dimensionLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClienteVariablesTableAnnotationComposer get disenoLlantaId {
    final $$ClienteVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.disenoLlantaId,
      referencedTable: $db.clienteVariables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspeccionLlantasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspeccionLlantasTable,
          InspeccionLlanta,
          $$InspeccionLlantasTableFilterComposer,
          $$InspeccionLlantasTableOrderingComposer,
          $$InspeccionLlantasTableAnnotationComposer,
          $$InspeccionLlantasTableCreateCompanionBuilder,
          $$InspeccionLlantasTableUpdateCompanionBuilder,
          (InspeccionLlanta, $$InspeccionLlantasTableReferences),
          InspeccionLlanta,
          PrefetchHooks Function({
            bool inspeccionId,
            bool vehiculoId,
            bool tipoLlantaId,
            bool marcaLlantaId,
            bool dimensionLlantaId,
            bool disenoLlantaId,
          })
        > {
  $$InspeccionLlantasTableTableManager(
    _$AppDatabase db,
    $InspeccionLlantasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspeccionLlantasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspeccionLlantasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspeccionLlantasTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inspeccionId = const Value.absent(),
                Value<String> vehiculoId = const Value.absent(),
                Value<String> codigoLlanta = const Value.absent(),
                Value<DateTime?> fechaMontaje = const Value.absent(),
                Value<double?> horoMontaje = const Value.absent(),
                Value<double?> kmMontaje = const Value.absent(),
                Value<String?> tipoLlantaId = const Value.absent(),
                Value<String?> marcaLlantaId = const Value.absent(),
                Value<String?> dimensionLlantaId = const Value.absent(),
                Value<String?> disenoLlantaId = const Value.absent(),
                Value<int> posicion = const Value.absent(),
                Value<double?> presion = const Value.absent(),
                Value<double?> medidaInt = const Value.absent(),
                Value<double?> medidaCent = const Value.absent(),
                Value<double?> medidaExt = const Value.absent(),
                Value<String?> observacion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspeccionLlantasCompanion(
                id: id,
                inspeccionId: inspeccionId,
                vehiculoId: vehiculoId,
                codigoLlanta: codigoLlanta,
                fechaMontaje: fechaMontaje,
                horoMontaje: horoMontaje,
                kmMontaje: kmMontaje,
                tipoLlantaId: tipoLlantaId,
                marcaLlantaId: marcaLlantaId,
                dimensionLlantaId: dimensionLlantaId,
                disenoLlantaId: disenoLlantaId,
                posicion: posicion,
                presion: presion,
                medidaInt: medidaInt,
                medidaCent: medidaCent,
                medidaExt: medidaExt,
                observacion: observacion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String inspeccionId,
                required String vehiculoId,
                required String codigoLlanta,
                Value<DateTime?> fechaMontaje = const Value.absent(),
                Value<double?> horoMontaje = const Value.absent(),
                Value<double?> kmMontaje = const Value.absent(),
                Value<String?> tipoLlantaId = const Value.absent(),
                Value<String?> marcaLlantaId = const Value.absent(),
                Value<String?> dimensionLlantaId = const Value.absent(),
                Value<String?> disenoLlantaId = const Value.absent(),
                required int posicion,
                Value<double?> presion = const Value.absent(),
                Value<double?> medidaInt = const Value.absent(),
                Value<double?> medidaCent = const Value.absent(),
                Value<double?> medidaExt = const Value.absent(),
                Value<String?> observacion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> creadaLocal = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspeccionLlantasCompanion.insert(
                id: id,
                inspeccionId: inspeccionId,
                vehiculoId: vehiculoId,
                codigoLlanta: codigoLlanta,
                fechaMontaje: fechaMontaje,
                horoMontaje: horoMontaje,
                kmMontaje: kmMontaje,
                tipoLlantaId: tipoLlantaId,
                marcaLlantaId: marcaLlantaId,
                dimensionLlantaId: dimensionLlantaId,
                disenoLlantaId: disenoLlantaId,
                posicion: posicion,
                presion: presion,
                medidaInt: medidaInt,
                medidaCent: medidaCent,
                medidaExt: medidaExt,
                observacion: observacion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                creadaLocal: creadaLocal,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspeccionLlantasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                inspeccionId = false,
                vehiculoId = false,
                tipoLlantaId = false,
                marcaLlantaId = false,
                dimensionLlantaId = false,
                disenoLlantaId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (inspeccionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.inspeccionId,
                                    referencedTable:
                                        $$InspeccionLlantasTableReferences
                                            ._inspeccionIdTable(db),
                                    referencedColumn:
                                        $$InspeccionLlantasTableReferences
                                            ._inspeccionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (vehiculoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehiculoId,
                                    referencedTable:
                                        $$InspeccionLlantasTableReferences
                                            ._vehiculoIdTable(db),
                                    referencedColumn:
                                        $$InspeccionLlantasTableReferences
                                            ._vehiculoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tipoLlantaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tipoLlantaId,
                                    referencedTable:
                                        $$InspeccionLlantasTableReferences
                                            ._tipoLlantaIdTable(db),
                                    referencedColumn:
                                        $$InspeccionLlantasTableReferences
                                            ._tipoLlantaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (marcaLlantaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.marcaLlantaId,
                                    referencedTable:
                                        $$InspeccionLlantasTableReferences
                                            ._marcaLlantaIdTable(db),
                                    referencedColumn:
                                        $$InspeccionLlantasTableReferences
                                            ._marcaLlantaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (dimensionLlantaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.dimensionLlantaId,
                                    referencedTable:
                                        $$InspeccionLlantasTableReferences
                                            ._dimensionLlantaIdTable(db),
                                    referencedColumn:
                                        $$InspeccionLlantasTableReferences
                                            ._dimensionLlantaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (disenoLlantaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.disenoLlantaId,
                                    referencedTable:
                                        $$InspeccionLlantasTableReferences
                                            ._disenoLlantaIdTable(db),
                                    referencedColumn:
                                        $$InspeccionLlantasTableReferences
                                            ._disenoLlantaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$InspeccionLlantasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspeccionLlantasTable,
      InspeccionLlanta,
      $$InspeccionLlantasTableFilterComposer,
      $$InspeccionLlantasTableOrderingComposer,
      $$InspeccionLlantasTableAnnotationComposer,
      $$InspeccionLlantasTableCreateCompanionBuilder,
      $$InspeccionLlantasTableUpdateCompanionBuilder,
      (InspeccionLlanta, $$InspeccionLlantasTableReferences),
      InspeccionLlanta,
      PrefetchHooks Function({
        bool inspeccionId,
        bool vehiculoId,
        bool tipoLlantaId,
        bool marcaLlantaId,
        bool dimensionLlantaId,
        bool disenoLlantaId,
      })
    >;
typedef $$SyncDataTableCreateCompanionBuilder =
    SyncDataCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSuccessfulSync,
    });
typedef $$SyncDataTableUpdateCompanionBuilder =
    SyncDataCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSuccessfulSync,
    });

class $$SyncDataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncDataTable> {
  $$SyncDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulSync => $composableBuilder(
    column: $table.lastSuccessfulSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncDataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncDataTable> {
  $$SyncDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulSync => $composableBuilder(
    column: $table.lastSuccessfulSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncDataTable> {
  $$SyncDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessfulSync => $composableBuilder(
    column: $table.lastSuccessfulSync,
    builder: (column) => column,
  );
}

class $$SyncDataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncDataTable,
          sync_data,
          $$SyncDataTableFilterComposer,
          $$SyncDataTableOrderingComposer,
          $$SyncDataTableAnnotationComposer,
          $$SyncDataTableCreateCompanionBuilder,
          $$SyncDataTableUpdateCompanionBuilder,
          (sync_data, BaseReferences<_$AppDatabase, $SyncDataTable, sync_data>),
          sync_data,
          PrefetchHooks Function()
        > {
  $$SyncDataTableTableManager(_$AppDatabase db, $SyncDataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSuccessfulSync = const Value.absent(),
              }) => SyncDataCompanion(
                id: id,
                lastSuccessfulSync: lastSuccessfulSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSuccessfulSync = const Value.absent(),
              }) => SyncDataCompanion.insert(
                id: id,
                lastSuccessfulSync: lastSuccessfulSync,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncDataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncDataTable,
      sync_data,
      $$SyncDataTableFilterComposer,
      $$SyncDataTableOrderingComposer,
      $$SyncDataTableAnnotationComposer,
      $$SyncDataTableCreateCompanionBuilder,
      $$SyncDataTableUpdateCompanionBuilder,
      (sync_data, BaseReferences<_$AppDatabase, $SyncDataTable, sync_data>),
      sync_data,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ClienteVariablesTableTableManager get clienteVariables =>
      $$ClienteVariablesTableTableManager(_db, _db.clienteVariables);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db, _db.vehiculos);
  $$InspeccionesTableTableManager get inspecciones =>
      $$InspeccionesTableTableManager(_db, _db.inspecciones);
  $$InspeccionVehiculosTableTableManager get inspeccionVehiculos =>
      $$InspeccionVehiculosTableTableManager(_db, _db.inspeccionVehiculos);
  $$InspeccionLlantasTableTableManager get inspeccionLlantas =>
      $$InspeccionLlantasTableTableManager(_db, _db.inspeccionLlantas);
  $$SyncDataTableTableManager get syncData =>
      $$SyncDataTableTableManager(_db, _db.syncData);
}
