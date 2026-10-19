from datetime import datetime
from typing import Optional
from uuid import UUID

from crud.app.sync import obtener_datos_para_app, procesar_sincronizacion_app
from fastapi import APIRouter, Depends, HTTPException, Query
from schemas.sync import AppSyncPayload
from sqlalchemy.orm import Session
from db.base import get_db
from api.security import get_api_key

mobile_router = APIRouter(prefix="/mobile", tags=["Admin - mobile"], dependencies=[Depends(get_api_key)]) 

@mobile_router.post("/sync/send")
def sincronizar_desde_app(payload: AppSyncPayload, db: Session = Depends(get_db)):
    try:
        resultado = procesar_sincronizacion_app(db, payload)
        return resultado
    except Exception as e:
        print(f"Error de sincronización: {e}") 
        raise HTTPException(
            status_code=500,
            detail=f"Error sincronizando los datos de la app: {str(e)}"
        )
    

@mobile_router.get("/sync/download", response_model=AppSyncPayload)
def descargar_datos_hacia_app(
    ultima_sincronizacion: Optional[datetime] = Query(None, description="Fecha de la última sincronización en formato ISO. Si es nulo, es una instalación limpia."),
    cliente_id: Optional[UUID] = Query(None, description="ID del cliente para filtrar los datos"),
    db: Session = Depends(get_db)
):
    """
    Endpoint que la App móvil llama para bajarse los datos.
    Aplica una restricción de máximo 6 meses de antigüedad para las inspecciones.
    """
    datos = obtener_datos_para_app(db, ultima_sincronizacion, cliente_id)
    return datos