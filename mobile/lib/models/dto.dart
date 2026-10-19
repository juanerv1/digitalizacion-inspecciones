import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:drift/drift.dart';

// ==========================================
// Helpers de Parseo
// ==========================================
DateTime _parseDate(String dateStr) => DateTime.parse(dateStr).toLocal();
DateTime? _parseDateNullable(String? dateStr) => dateStr != null ? DateTime.parse(dateStr).toLocal() : null;

TipoVariableEnum _parseTipoVariable(String value) {
  return TipoVariableEnum.values.firstWhere(
    (e) => e.name == value || e.toString().split('.').last == value,
    orElse: () => TipoVariableEnum.TipoVehiculo, // Fallback seguro
  );
}

// ==========================================
// 0. Clientes
// ==========================================
class ClienteSync {
  final String id;
  final String nombre;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClienteSync({
    required this.id,
    required this.nombre,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClienteSync.fromJson(Map<String, dynamic> json) {
    return ClienteSync(
      id: json['id'],
      nombre: json['nombre'],
      // Asumiendo que usas el helper _parseDate que definimos antes
      createdAt: _parseDate(json['created_at']), 
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  ClientesCompanion toCompanion({required bool isFromServer}) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      // Lógica de sincronización offline-first
    );
  }
}

// ==========================================
// 1. Variables
// ==========================================
class ClienteVariableSync {
  final String id;
  final String clienteId;
  final TipoVariableEnum tipoVariable;
  final String nombre;
  final DateTime createdAt;

  ClienteVariableSync({
    required this.id,
    required this.clienteId,
    required this.tipoVariable,
    required this.nombre,
    required this.createdAt,
  });

  factory ClienteVariableSync.fromJson(Map<String, dynamic> json) {
    return ClienteVariableSync(
      id: json['id'],
      clienteId: json['cliente_id'],
      tipoVariable: _parseTipoVariable(json['tipo_variable']),
      nombre: json['nombre'],
      createdAt: _parseDate(json['created_at']),
    );
  }

  ClienteVariablesCompanion toCompanion({required bool isFromServer}) {
    return ClienteVariablesCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      tipoVariable: Value(tipoVariable),
      nombre: Value(nombre),
      createdAt: Value(createdAt),
      creadaLocal: isFromServer ? const Value(false) : const Value.absent(),
      pendienteSync: isFromServer ? const Value(false) : const Value.absent(),
    );
  }
}

// ==========================================
// 2. Vehículos
// ==========================================
class VehiculoSync {
  final String id;
  final String codigoVehiculo;
  final String clienteId;
  final String tipoId;
  final String marcaId;
  final int noLlantas;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehiculoSync({
    required this.id,
    required this.codigoVehiculo,
    required this.clienteId,
    required this.tipoId,
    required this.marcaId,
    required this.noLlantas,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehiculoSync.fromJson(Map<String, dynamic> json) {
    return VehiculoSync(
      id: json['id'],
      codigoVehiculo: json['codigo_vehiculo'],
      clienteId: json['cliente_id'],
      tipoId: json['tipo_id'],
      marcaId: json['marca_id'],
      noLlantas: json['no_llantas'],
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  VehiculosCompanion toCompanion({required bool isFromServer}) {
    return VehiculosCompanion(
      id: Value(id),
      codigoVehiculo: Value(codigoVehiculo),
      clienteId: Value(clienteId),
      tipoId: Value(tipoId),
      marcaId: Value(marcaId),
      noLlantas: Value(noLlantas),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creadaLocal: isFromServer ? const Value(false) : const Value.absent(),
      pendienteSync: isFromServer ? const Value(false) : const Value.absent(),
    );
  }
}

// ==========================================
// 3. Inspecciones
// ==========================================
class InspeccionSync {
  final String id;
  final String clienteId;
  final String? nombre;
  final DateTime fechaRevision;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;

  InspeccionSync({
    required this.id,
    required this.clienteId,
    this.nombre,
    required this.fechaRevision,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InspeccionSync.fromJson(Map<String, dynamic> json) {
    return InspeccionSync(
      id: json['id'],
      clienteId: json['cliente_id'],
      nombre: json['nombre'],
      fechaRevision: _parseDate(json['fecha_revision']),
      estado: json['estado'] ?? 'FINALIZADO',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  InspeccionesCompanion toCompanion({required bool isFromServer}) {
    return InspeccionesCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      nombre: Value(nombre),
      fechaRevision: Value(fechaRevision),
      estado: Value(estado),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creadaLocal: isFromServer ? const Value(false) : const Value.absent(),
      pendienteSync: isFromServer ? const Value(false) : const Value.absent(),
    );
  }
}

// ==========================================
// 4. Inspección de Vehículos
// ==========================================
class InspeccionVehiculoSync {
  final String id;
  final String inspeccionId;
  final String vehiculoId;
  final double? horometro;
  final double? kilometraje;
  final DateTime createdAt;

  InspeccionVehiculoSync({
    required this.id,
    required this.inspeccionId,
    required this.vehiculoId,
    this.horometro,
    this.kilometraje,
    required this.createdAt,
  });

  factory InspeccionVehiculoSync.fromJson(Map<String, dynamic> json) {
    return InspeccionVehiculoSync(
      id: json['id'],
      inspeccionId: json['inspeccion_id'],
      vehiculoId: json['vehiculo_id'],
      horometro: json['horometro']?.toDouble(),
      kilometraje: json['kilometraje']?.toDouble(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  InspeccionVehiculosCompanion toCompanion({required bool isFromServer}) {
    return InspeccionVehiculosCompanion(
      id: Value(id),
      inspeccionId: Value(inspeccionId),
      vehiculoId: Value(vehiculoId),
      horometro: Value(horometro),
      kilometraje: Value(kilometraje),
      createdAt: Value(createdAt),
      creadaLocal: isFromServer ? const Value(false) : const Value.absent(),
      pendienteSync: isFromServer ? const Value(false) : const Value.absent(),
    );
  }
}

// ==========================================
// 5. Inspección de Llantas
// ==========================================
class InspeccionLlantaSync {
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

  InspeccionLlantaSync({
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
  });

  factory InspeccionLlantaSync.fromJson(Map<String, dynamic> json) {
    return InspeccionLlantaSync(
      id: json['id'],
      inspeccionId: json['inspeccion_id'],
      vehiculoId: json['vehiculo_id'],
      codigoLlanta: json['codigo_llanta'],
      fechaMontaje: _parseDateNullable(json['fecha_montaje']),
      horoMontaje: json['horometro_montaje']?.toDouble(),
      kmMontaje: json['kilometraje_montaje']?.toDouble(),
      tipoLlantaId: json['tipo_llanta_id'],
      marcaLlantaId: json['marca_llanta_id'],
      dimensionLlantaId: json['dimension_llanta_id'],
      disenoLlantaId: json['diseno_llanta_id'],
      posicion: json['posicion'],
      presion: json['presion']?.toDouble(),
      medidaInt: json['medida_int']?.toDouble(),
      medidaCent: json['medida_cent']?.toDouble(),
      medidaExt: json['medida_ext']?.toDouble(),
      observacion: json['observacion'],
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  InspeccionLlantasCompanion toCompanion({required bool isFromServer}) {
    return InspeccionLlantasCompanion(
      id: Value(id),
      inspeccionId: Value(inspeccionId),
      vehiculoId: Value(vehiculoId),
      codigoLlanta: Value(codigoLlanta),
      fechaMontaje: Value(fechaMontaje),
      horoMontaje: Value(horoMontaje),
      kmMontaje: Value(kmMontaje),
      tipoLlantaId: Value(tipoLlantaId),
      marcaLlantaId: Value(marcaLlantaId),
      dimensionLlantaId: Value(dimensionLlantaId),
      disenoLlantaId: Value(disenoLlantaId),
      posicion: Value(posicion),
      presion: Value(presion),
      medidaInt: Value(medidaInt),
      medidaCent: Value(medidaCent),
      medidaExt: Value(medidaExt),
      observacion: Value(observacion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creadaLocal: isFromServer ? const Value(false) : const Value.absent(),
      pendienteSync: isFromServer ? const Value(false) : const Value.absent(),
    );
  }
}

// --- NUEVAS CLASES PARA LA METADATA ---

class SyncCounts {
  final int clientes;
  final int variables;
  final int vehiculos;
  final int inspecciones;
  final int inspeccionVehiculos;
  final int inspeccionLlantas;

  SyncCounts({
    required this.clientes,
    required this.variables,
    required this.vehiculos,
    required this.inspecciones,
    required this.inspeccionVehiculos,
    required this.inspeccionLlantas,
  });

  factory SyncCounts.fromJson(Map<String, dynamic> json) {
    return SyncCounts(
      clientes: json['clientes'] as int? ?? 0,
      variables: json['variables'] as int? ?? 0,
      vehiculos: json['vehiculos'] as int? ?? 0,
      inspecciones: json['inspecciones'] as int? ?? 0,
      inspeccionVehiculos: json['inspeccion_vehiculos'] as int? ?? 0,
      inspeccionLlantas: json['inspeccion_llantas'] as int? ?? 0,
    );
  }
}

class SyncMetadata {
  final DateTime serverTimestamp;
  final SyncCounts counts;

  SyncMetadata({
    required this.serverTimestamp,
    required this.counts,
  });

  factory SyncMetadata.fromJson(Map<String, dynamic> json) {
    return SyncMetadata(
      // Se parsea el string ISO-8601 a DateTime y garantizamos que esté en UTC
      serverTimestamp: DateTime.parse(json['server_timestamp'] as String).toUtc(),
      counts: SyncCounts.fromJson(json['counts'] as Map<String, dynamic>),
    );
  }
}

// --- TU PAYLOAD ACTUALIZADO ---

class AppSyncPayload {
  final SyncMetadata metadata; // <-- Nuevo campo
  final List<ClienteSync> clientes;
  final List<ClienteVariableSync> variables;
  final List<VehiculoSync> vehiculos;
  final List<InspeccionSync> inspecciones;
  final List<InspeccionVehiculoSync> inspeccionVehiculos;
  final List<InspeccionLlantaSync> inspeccionLlantas;

  AppSyncPayload({
    required this.metadata, // <-- Requerido
    required this.clientes,
    required this.variables,
    required this.vehiculos,
    required this.inspecciones,
    required this.inspeccionVehiculos,
    required this.inspeccionLlantas,
  });

  factory AppSyncPayload.fromJson(Map<String, dynamic> json) {
    return AppSyncPayload(
      // Instanciamos la metadata desde su nodo en el JSON
      metadata: SyncMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      
      clientes: (json['clientes'] as List?)
              ?.map((e) => ClienteSync.fromJson(e))
              .toList() ??
          [],      
      variables: (json['variables'] as List?)
              ?.map((e) => ClienteVariableSync.fromJson(e))
              .toList() ??
          [],
      vehiculos: (json['vehiculos'] as List?)
              ?.map((e) => VehiculoSync.fromJson(e))
              .toList() ??
          [],
      inspecciones: (json['inspecciones'] as List?)
              ?.map((e) => InspeccionSync.fromJson(e))
              .toList() ??
          [],
      inspeccionVehiculos: (json['inspeccion_vehiculos'] as List?)
              ?.map((e) => InspeccionVehiculoSync.fromJson(e))
              .toList() ??
          [],
      inspeccionLlantas: (json['inspeccion_llantas'] as List?)
              ?.map((e) => InspeccionLlantaSync.fromJson(e))
              .toList() ??
          [],
    );
  }
}