import 'package:inspecciones_llantas/data/db/tables.dart';

class ClienteResumen {
  final String id;
  final String nombre;
  final int cantidadVehiculos;
  final int cantidadInspecciones;
  final DateTime? ultimaInspeccion;

  ClienteResumen({
    required this.id,
    required this.nombre,
    required this.cantidadVehiculos,
    required this.cantidadInspecciones,
    this.ultimaInspeccion,
  });
}

class InspeccionResumen {
  final String id;
  final String clienteId;
  final String? clienteNombre;
  final String? nombre;
  final DateTime fechaRevision;
  final int cantidadVehiculos;
  final int cantidadLlantas;
  final String estado;

  InspeccionResumen({
    required this.id,
    required this.clienteId,
    this.nombre,
    this.clienteNombre,
    required this.fechaRevision,
    required this.cantidadVehiculos,
    required this.cantidadLlantas,
    required this.estado,
  });
}

class VehiculoInspeccionResumen {
  // Datos del Vehículo
  final String vehiculoId;
  final String? inspeccionId;
  final String codigoVehiculo;
  final String clienteId;
  final String tipoId;
  final String? nombreTipo;
  final String marcaId;
  final String? nombreMarca;
  final int noLlantas;

  // Datos de la Inspección (Pueden ser nulos si el vehículo aún no se inspecciona)
  final String? inspeccionVehiculoId;
  final double? horometro;
  final double? kilometraje;
  final int cantidadLlantasInspeccionadas;

  VehiculoInspeccionResumen({
    required this.vehiculoId,
    this.inspeccionId,
    required this.codigoVehiculo,
    required this.clienteId,
    required this.tipoId,
    this.nombreTipo,
    required this.marcaId,
    this.nombreMarca,
    required this.noLlantas,
    this.inspeccionVehiculoId,
    this.horometro,
    this.kilometraje,
    required this.cantidadLlantasInspeccionadas,
  });
  
  // Helper útil para la UI: saber si el vehículo ya fue trabajado en esta inspección
  bool get estaInspeccionado => inspeccionVehiculoId != null;
}

class LlantaInspeccionResumen {
  final String id;
  final String inspeccionId;
  final String vehiculoId;
  final int posicion;
  final String codigoLlanta;
  final DateTime? fechaMontaje;
  final double? horoMontaje;
  final double? kmMontaje;

  // Nombres resueltos de las variables (pueden ser nulos si no se llenaron)
  final String? tipoLlantaId;
  final String? nombreTipo;
  final String? marcaLlantaId;
  final String? nombreMarca;
  final String? dimensionLlantaId;
  final String? nombreDimension;
  final String? disenoLlantaId;
  final String? nombreDiseno;

  final double? presion;
  final double? medidaInt;
  final double? medidaCent;
  final double? medidaExt;
  final String? observacion;

  LlantaInspeccionResumen({
    required this.id,
    required this.inspeccionId,
    required this.vehiculoId,
    required this.posicion,
    required this.codigoLlanta,
    this.fechaMontaje,
    this.horoMontaje,
    this.kmMontaje,
    this.tipoLlantaId,
    this.nombreTipo,
    this.marcaLlantaId,
    this.nombreMarca,
    this.dimensionLlantaId,
    this.nombreDimension,
    this.disenoLlantaId,
    this.nombreDiseno,
    this.presion,
    this.medidaInt,
    this.medidaCent,
    this.medidaExt,
    this.observacion,
  });
}

class ClienteVariableEntity {
  final String id;
  final String clienteId;
  final TipoVariableEnum tipoVariable;
  final String nombre;

  ClienteVariableEntity({
    required this.id,
    required this.clienteId,
    required this.tipoVariable,
    required this.nombre,
  });
}