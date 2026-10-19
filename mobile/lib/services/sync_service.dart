import 'package:flutter/foundation.dart';

import 'package:inspecciones_llantas/core/network/api_client.dart';
import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/models/dto.dart';

class SyncService {
  final AppDatabase db;
  final ApiClient api;

  // Constructor optimizado: Solo 2 argumentos
  SyncService(this.db, this.api);

  Future<void> syncPull() async {
    try {
      final since = await db.syncDataDao.getLastSuccessfulSync();
      final queryParams = <String, String>{};
      
      // Enviamos la fecha de la última sincronización
      queryParams['ultima_sincronizacion'] = since.toUtc().toIso8601String();
    
      final uri = Uri(
        path: '/mobile/sync/download', 
        queryParameters: queryParams.isNotEmpty ? queryParams : null
      );

      final response = await api.get(uri.toString());
      final syncPayload = AppSyncPayload.fromJson(response);

      // --- VALIDACIÓN DE INTEGRIDAD ---
      // Asegurarnos de que el JSON se parseó completamente sin perder registros por errores silenciosos
      final metaCounts = syncPayload.metadata.counts;
      if (syncPayload.clientes.length != metaCounts.clientes ||
          syncPayload.variables.length != metaCounts.variables ||
          syncPayload.vehiculos.length != metaCounts.vehiculos ||
          syncPayload.inspecciones.length != metaCounts.inspecciones ||
          syncPayload.inspeccionVehiculos.length != metaCounts.inspeccionVehiculos ||
          syncPayload.inspeccionLlantas.length != metaCounts.inspeccionLlantas) {
        
        throw Exception("Fallo de integridad: La cantidad de registros parseados no coincide con los declarados por el servidor.");
      }

      // Inicia la transacción Atómica
      await db.transaction(() async {
        await _applyClientes(syncPayload.clientes);
        await _applyVariables(syncPayload.variables);
        await _applyVehiculos(syncPayload.vehiculos);
        await _applyInspecciones(syncPayload.inspecciones);
        await _applyInspeccionVehiculos(syncPayload.inspeccionVehiculos);
        await _applyInspeccionLlantas(syncPayload.inspeccionLlantas);

        // ¡CRÍTICO!: Usar el timestamp DEL SERVIDOR, no el DateTime.now() del dispositivo
        final serverTimestamp = syncPayload.metadata.serverTimestamp;
        await db.syncDataDao.insertLastSync(serverTimestamp);
      });

      debugPrint('🏁 Sync pull (Descarga) finalizado correctamente');
    } catch (e) {
      // Al hacer rethrow, la transacción en Drift se aborta automáticamente (Rollback).
      // Ningún dato parcial se guarda y la fecha de última sincronización NO se actualiza.
      debugPrint('🆘 ERROR EN SYNC PULL: $e');
      rethrow; 
    }
  }

  // ==========================================
  // Funciones de Aplicación Internas
  // ==========================================

  Future<void> _applyClientes(List<ClienteSync> items) async {
    if (items.isEmpty) return;
    for (final item in items) {
      await db.clienteDao.upsert(item.toCompanion(isFromServer: true));
    }
  }

  Future<void> _applyVariables(List<ClienteVariableSync> items) async {
    if (items.isEmpty) return;
    for (final item in items) {
      await db.clienteVariablesDao.upsert(item.toCompanion(isFromServer: true));
    }
  }

  Future<void> _applyVehiculos(List<VehiculoSync> items) async {
    if (items.isEmpty) return;
    for (final item in items) {
      await db.vehiculosDao.upsert(item.toCompanion(isFromServer: true));
    }
  }

  Future<void> _applyInspecciones(List<InspeccionSync> items) async {
    if (items.isEmpty) return;
    for (final item in items) {
      await db.inspeccionesDao.upsert(item.toCompanion(isFromServer: true));
    }
  }

  Future<void> _applyInspeccionVehiculos(List<InspeccionVehiculoSync> items) async {
    if (items.isEmpty) return;
    for (final item in items) {
      await db.inspeccionVehiculosDao.upsert(item.toCompanion(isFromServer: true));
    }
  }

  Future<void> _applyInspeccionLlantas(List<InspeccionLlantaSync> items) async {
    if (items.isEmpty) return;
    for (final item in items) {
      await db.inspeccionLlantasDao.upsert(item.toCompanion(isFromServer: true));
    }
  }

  Future<void> enviarDatosAlServidor() async {
    try {
      // 1. RECOLECTAR DATOS PENDIENTES DE TODAS LAS TABLAS
      final variablesPendientes = await db.clienteVariablesDao.obtenerPendientesSync();
      final vehiculosPendientes = await db.vehiculosDao.obtenerPendientesSync();

      final inspeccionesPendientes = (await db.inspeccionesDao.obtenerPendientesSync())
          .where((i) => i.estado == 'FINALIZADO')
          .toList();

      final idsInspeccionesFinalizadas = inspeccionesPendientes.map((i) => i.id).toSet();

      final inspVehiculosPendientes = (await db.inspeccionVehiculosDao.obtenerPendientesSync())
          .where((iv) => idsInspeccionesFinalizadas.contains(iv.inspeccionId))
          .toList();

      final llantasPendientes = (await db.inspeccionLlantasDao.obtenerPendientesSync())
          .where((l) => idsInspeccionesFinalizadas.contains(l.inspeccionId))
          .toList();

      // Si no hay nada que enviar, terminamos la función temprano
      if (variablesPendientes.isEmpty &&
          vehiculosPendientes.isEmpty &&
          inspeccionesPendientes.isEmpty &&
          inspVehiculosPendientes.isEmpty &&
          llantasPendientes.isEmpty) {
        debugPrint('No hay datos nuevos o finalizados para sincronizar con el servidor.');
        return;
      }

      final idsVariables = variablesPendientes.map((e) => e.id).toList();
      final idsVehiculos = vehiculosPendientes.map((e) => e.id).toList();
      final idsInspecciones = inspeccionesPendientes.map((e) => e.id).toList();
      final idsInspVehiculos = inspVehiculosPendientes.map((e) => e.id).toList();
      final idsLlantas = llantasPendientes.map((e) => e.id).toList();

      // 2. CONSTRUIR METADATA DE INTEGRIDAD DE SUBIDA
      final Map<String, dynamic> metadataPayload = {
        "server_timestamp": DateTime.now().toUtc().toIso8601String(), // Timestamp referencial de la app
        "counts": {
          "clientes": 0, // No enviamos clientes en este flujo
          "variables": variablesPendientes.length,
          "vehiculos": vehiculosPendientes.length,
          "inspecciones": inspeccionesPendientes.length,
          "inspeccion_vehiculos": inspVehiculosPendientes.length,
          "inspeccion_llantas": llantasPendientes.length,
        }
      };

      // 3. ARMAR EL PAYLOAD (JSON) - Mapeo manual a snake_case
      final Map<String, dynamic> payload = {
        "metadata": metadataPayload, 
        "clientes": [],
        
        "variables": variablesPendientes.map((v) => {
          "id": v.id,
          "cliente_id": v.clienteId, 
          "tipo_variable": v.tipoVariable.name,
          "nombre": v.nombre,
          "created_at": v.createdAt.toUtc().toIso8601String(), 
        }).toList(),
        
        "vehiculos": vehiculosPendientes.map((v) => {
          "id": v.id,
          "codigo_vehiculo": v.codigoVehiculo,
          "cliente_id": v.clienteId,
          "tipo_id": v.tipoId,
          "marca_id": v.marcaId,
          "no_llantas": v.noLlantas,
          "created_at": v.createdAt.toUtc().toIso8601String(),
          "updated_at": v.updatedAt.toUtc().toIso8601String(),
        }).toList(),
        
        "inspecciones": inspeccionesPendientes.map((i) => {
          "id": i.id,
          "cliente_id": i.clienteId,
          "nombre": i.nombre,
          "fecha_revision": i.fechaRevision.toIso8601String().split('T')[0],          
          "estado": i.estado,
          "created_at": i.createdAt.toUtc().toIso8601String(),
          "updated_at": i.updatedAt.toUtc().toIso8601String(),
        }).toList(),
        
        "inspeccion_vehiculos": inspVehiculosPendientes.map((iv) => {
          "id": iv.id,
          "inspeccion_id": iv.inspeccionId,
          "vehiculo_id": iv.vehiculoId,
          "horometro": iv.horometro,
          "kilometraje": iv.kilometraje,
          "created_at": iv.createdAt.toUtc().toIso8601String(),
        }).toList(),
        
        "inspeccion_llantas": llantasPendientes.map((l) => {
          "id": l.id,
          "inspeccion_id": l.inspeccionId,
          "vehiculo_id": l.vehiculoId,
          "codigo_llanta": l.codigoLlanta,
          "fecha_montaje": l.fechaMontaje != null 
              ? l.fechaMontaje!.toIso8601String().split('T')[0] 
              : null,
          "horometro_montaje": l.horoMontaje,
          "kilometraje_montaje": l.kmMontaje,
          "tipo_llanta_id": l.tipoLlantaId,
          "marca_llanta_id": l.marcaLlantaId,
          "dimension_llanta_id": l.dimensionLlantaId,
          "diseno_llanta_id": l.disenoLlantaId,
          "posicion": l.posicion,
          "presion": l.presion,
          "medida_int": l.medidaInt,
          "medida_cent": l.medidaCent,
          "medida_ext": l.medidaExt,
          "observacion": l.observacion,
          "created_at": l.createdAt.toUtc().toIso8601String(),
          "updated_at": l.updatedAt.toUtc().toIso8601String(),
        }).toList(),
      };

      // 4. ENVIAR A LA API
      final uri = Uri(path: '/mobile/sync/send');

      // Petición HTTP POST enviando el payload completo
      await api.post(
        uri.toString(),
        body: payload,
      );
        
      // Si el servidor responde exitosamente (HTTP 200), actualizamos localmente
      await db.transaction(() async {
        await db.clienteVariablesDao.marcarComoSincronizados(idsVariables);
        await db.vehiculosDao.marcarComoSincronizados(idsVehiculos);
        await db.inspeccionesDao.marcarComoSincronizados(idsInspecciones);
        await db.inspeccionVehiculosDao.marcarComoSincronizados(idsInspVehiculos);
        await db.inspeccionLlantasDao.marcarComoSincronizados(idsLlantas);
      });

      debugPrint('Sincronización exitosa: Datos enviados y marcados localmente.');

    } catch (e) {
      debugPrint('Error en enviarDatosAlServidor: $e');
      rethrow; 
    }
  }
}