from db.models import Cliente, ClienteVariable, Inspeccion, InspeccionLlanta, InspeccionVehiculo, Vehiculo
from schemas.sync import AppSyncPayload
from sqlalchemy.orm import Session
# Importa tus modelos de BD y el AppSyncPayload

from fastapi import HTTPException

def procesar_sincronizacion_app(db: Session, payload: AppSyncPayload):
    try:
        # --- AUDITORÍA DE INTEGRIDAD DE SUBIDA ---
        meta_counts = payload.metadata.counts
        
        # Validamos que lo recibido coincida estrictamente con lo que la app dice haber enviado
        if (len(payload.variables) != meta_counts.variables or
            len(payload.vehiculos) != meta_counts.vehiculos or
            len(payload.inspecciones) != meta_counts.inspecciones or
            len(payload.inspeccion_vehiculos) != meta_counts.inspeccion_vehiculos or
            len(payload.inspeccion_llantas) != meta_counts.inspeccion_llantas):
            
            # Si hay descuadre, disparamos una excepción controlada.
            # Esto evita que se guarden datos a medias si Pydantic descartó registros corruptos en silencio.
            raise ValueError(
                f"Fallo de integridad en subida. "
                f"Esperados vs Recibidos -> "
                f"Variables: {meta_counts.variables}/{len(payload.variables)}, "
                f"Vehículos: {meta_counts.vehiculos}/{len(payload.vehiculos)}, "
                f"Inspecciones: {meta_counts.inspecciones}/{len(payload.inspecciones)}, "
                f"Insp. Vehículos: {meta_counts.inspeccion_vehiculos}/{len(payload.inspeccion_vehiculos)}, "
                f"Insp. Llantas: {meta_counts.inspeccion_llantas}/{len(payload.inspeccion_llantas)}"
            )

        # --- PROCESAMIENTO ATÓMICO EN BD (El orden importa) ---
        
        # 1. Variables
        for var_data in payload.variables:
            var_db = ClienteVariable(**var_data.model_dump())
            db.merge(var_db)
            
        # 2. Vehículos
        for veh_data in payload.vehiculos:
            veh_db = Vehiculo(**veh_data.model_dump())
            db.merge(veh_db)
            
        # 3. Inspecciones Base
        for insp_data in payload.inspecciones:
            insp_db = Inspeccion(**insp_data.model_dump())
            db.merge(insp_db)
            
        # 4. Detalles: Inspecciones de Vehículos
        for insp_veh_data in payload.inspeccion_vehiculos:
            insp_veh_db = InspeccionVehiculo(**insp_veh_data.model_dump())
            db.merge(insp_veh_db)
            
        # 5. Detalles: Inspecciones de Llantas
        for insp_llanta_data in payload.inspeccion_llantas:
            insp_llanta_db = InspeccionLlanta(**insp_llanta_data.model_dump())
            db.merge(insp_llanta_db)

        # Confirmamos la gran transacción solo si TODO lo anterior pasó limpio
        db.commit()

        return {
            "status": "success",
            "message": "Sincronización completada con éxito",
            "resumen": {
                "variables_procesadas": len(payload.variables),
                "vehiculos_procesados": len(payload.vehiculos),
                "inspecciones_procesadas": len(payload.inspecciones),
                "inspeccion_vehiculos_procesadas": len(payload.inspeccion_vehiculos),
                "inspeccion_llantas_procesadas": len(payload.inspeccion_llantas)
            }
        }

    except Exception as e:
        # Si algo falla o salta la excepción de integridad, la base de datos hace ROLLBACK total.
        # Ningún registro huérfano quedará guardado en el servidor.
        db.rollback()
        raise e
        
from datetime import datetime, timedelta, timezone
from typing import Optional
from uuid import UUID

def obtener_datos_para_app(db: Session, ultima_sincronizacion: Optional[datetime], cliente_id: Optional[UUID] = None):

    server_timestamp = datetime.now(timezone.utc)
    limite_6_meses = server_timestamp - timedelta(days=180)
    
    fecha_maestra = ultima_sincronizacion if ultima_sincronizacion else datetime(1970, 1, 1, tzinfo=timezone.utc)

    # 2. Construir las consultas (esto se mantiene igual)
    q_clientes = db.query(Cliente)  
    q_variables = db.query(ClienteVariable)
    q_vehiculos = db.query(Vehiculo)
    q_inspecciones = db.query(Inspeccion)
    q_insp_veh = db.query(InspeccionVehiculo)
    q_insp_llantas = db.query(InspeccionLlanta)

    if cliente_id:
        q_clientes = q_clientes.filter(Cliente.id == cliente_id)  
        q_variables = q_variables.filter(ClienteVariable.cliente_id == cliente_id)
        q_vehiculos = q_vehiculos.filter(Vehiculo.cliente_id == cliente_id)
        q_inspecciones = q_inspecciones.filter(Inspeccion.cliente_id == cliente_id)
        
        q_insp_veh = q_insp_veh.join(Inspeccion).filter(Inspeccion.cliente_id == cliente_id)
        q_insp_llantas = q_insp_llantas.join(Inspeccion).filter(Inspeccion.cliente_id == cliente_id)

    clientes = q_clientes.filter(Cliente.updated_at >= fecha_maestra).all() 
    variables = q_variables.filter(ClienteVariable.created_at >= fecha_maestra).all()
    vehiculos = q_vehiculos.filter(Vehiculo.updated_at >= fecha_maestra).all()
    inspecciones = q_inspecciones.filter(Inspeccion.updated_at >= fecha_maestra).all()
    insp_vehiculos = q_insp_veh.filter(InspeccionVehiculo.created_at >= fecha_maestra).all()
    insp_llantas = q_insp_llantas.filter(InspeccionLlanta.updated_at >= fecha_maestra).all()

    # 4. Retornamos todo empacado en un diccionario que Pydantic convertirá en JSON
    return {
        "metadata": {
            "server_timestamp": server_timestamp, # La app debe guardar ESTA fecha
            "counts": {
                "clientes": len(clientes),
                "variables": len(variables),
                "vehiculos": len(vehiculos),
                "inspecciones": len(inspecciones),
                "inspeccion_vehiculos": len(insp_vehiculos),
                "inspeccion_llantas": len(insp_llantas)
            }
        },
        "clientes": clientes,  
        "variables": variables,
        "vehiculos": vehiculos,
        "inspecciones": inspecciones,
        "inspeccion_vehiculos": insp_vehiculos,
        "inspeccion_llantas": insp_llantas
    }