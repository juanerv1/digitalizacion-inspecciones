import unicodedata
from urllib.parse import quote
# =================================================================
# 1. IMPORTACIONES
# =================================================================
# Librerías Estándar
from typing import List, Dict, Union
from uuid import UUID
from datetime import date

# Terceros (FastAPI, SQLAlchemy)
from api.security import verificar_token
from crud.web.inspecciones import generar_excel_inspeccion, kardex_flota_cliente
from crud.web.vehiculos import create_vehiculo, get_variables_vehiculo, get_vehiculos_por_cliente, update_vehiculo
from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form, status
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session

# Modulos Locales (BD, Modelos, Esquemas)
from db.base import get_db
from schemas.cliente import ClienteCreate, ClienteResponse, ClienteUpdate
from schemas.variableSchema import ClienteVariableResponse
from schemas.vehicleSchema import VehiculoCreate, VehiculoResponse, VehiculoUpdate
from schemas.reporte import InspeccionResumenResponse, ReportePlataformaCreate

# CRUDs Locales
from crud.web.clientes import (
    actualizar_cliente,
    crear_cliente,
    get_cliente_por_id,
    listar_clientes,
)
from crud.web.reporteWeb import get_resumen_inspecciones, obtener_preview_inspeccion, procesar_kartex_pandas

# =================================================================
# 3. DEFINICIÓN DE ROUTERS
# =================================================================
clients_router = APIRouter(prefix="/client", tags=["Admin - Clientes"] , dependencies=[Depends(verificar_token)])

# =================================================================
# 4. ENDPOINTS: CLIENTES (CRUD Básico)
# =================================================================

@clients_router.post("/", response_model=ClienteResponse)
def createClients(cliente: ClienteCreate, db: Session = Depends(get_db)):
    try:
        return crear_cliente(db=db, cliente_in=cliente)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error al crear cliente")

@clients_router.get("/", response_model=list[ClienteResponse])
def getAllClients(db: Session = Depends(get_db)):
    return listar_clientes(db)

@clients_router.get("/{cliente_id}", response_model=ClienteResponse)
def getClient(cliente_id: UUID, db: Session = Depends(get_db)):
    cliente = get_cliente_por_id(db, cliente_id)
    if not cliente:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    return cliente

@clients_router.patch("/{cliente_id}", response_model=ClienteResponse)
def editClient(cliente_id: UUID, cliente: ClienteUpdate, db: Session = Depends(get_db)):
    cliente_actualizado = actualizar_cliente(db, cliente_id, cliente)
    if not cliente_actualizado:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    return cliente_actualizado


# =================================================================
# 5. ENDPOINTS: CLIENTES -> VARIABLES Y VEHÍCULOS
# =================================================================
@clients_router.get("/{cliente_id}/variables/vehicle-form", response_model=Dict[str, List[ClienteVariableResponse]])
def obtener_variables_formulario_vehiculo(cliente_id: UUID, db: Session = Depends(get_db)):
    return get_variables_vehiculo(db, cliente_id)


@clients_router.get("/{cliente_id}/vehiculos", response_model=List[VehiculoResponse])
def listar_vehiculos(cliente_id: UUID, db: Session = Depends(get_db)):
    return get_vehiculos_por_cliente(db, cliente_id)


@clients_router.post("/{cliente_id}/vehiculos", response_model=VehiculoResponse, status_code=status.HTTP_201_CREATED)
def crear_vehiculo(cliente_id: UUID, vehiculo_in: VehiculoCreate, db: Session = Depends(get_db)):
    try:
        return create_vehiculo(db, cliente_id, vehiculo_in)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Error al crear vehículo: {str(e)}")


@clients_router.put("/{cliente_id}/vehiculos/{vehiculo_id}", response_model=VehiculoResponse)
def editar_vehiculo(cliente_id: UUID, vehiculo_id: UUID, vehiculo_in: VehiculoUpdate, db: Session = Depends(get_db)):
    try:
        vehiculo = update_vehiculo(db, cliente_id, vehiculo_id, vehiculo_in)
        if not vehiculo:
            raise HTTPException(status_code=404, detail="Vehículo no encontrado para este cliente")
        return vehiculo
    except Exception as e:
        db.rollback()
        if isinstance(e, HTTPException):
            raise e
        raise HTTPException(status_code=400, detail=f"Error al actualizar vehículo: {str(e)}")


# =================================================================
# ENDPOINTS: INSPECCIONES Y REPORTES
# =================================================================

def content_disposition(filename: str) -> str:
    """Header de descarga seguro para nombres con tildes o ñ (RFC 6266)."""
    ascii_name = unicodedata.normalize("NFKD", filename).encode("ascii", "ignore").decode()
    return f'attachment; filename="{ascii_name}"; filename*=UTF-8\'\'{quote(filename)}'


reportes_router = APIRouter(prefix="/inspection", tags=["Admin - inspection"], dependencies=[Depends(verificar_token)])

@reportes_router.post("/")
def createInspectionManual(
    cliente_id: UUID = Form(...),
    nombre: str = Form(None),
    fecha_revision: date = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    reporte = ReportePlataformaCreate(
        cliente_id=cliente_id, 
        nombre=nombre, 
        fecha_revision=fecha_revision
    )
    return procesar_kartex_pandas(db, reporte, file)


@reportes_router.get("/client/{cliente_id}", response_model=List[InspeccionResumenResponse])
def listar_inspecciones_por_cliente(cliente_id: UUID, db: Session = Depends(get_db)):
    return get_resumen_inspecciones(db, cliente_id)

@reportes_router.get("/{inspeccion_id}/preview")
def previsualizar_inspeccion(inspeccion_id: UUID, db: Session = Depends(get_db)):
    # Ejecutamos la consulta en la capa CRUD
    datos_preview = obtener_preview_inspeccion(db, inspeccion_id=inspeccion_id)
    
    # Si la capa CRUD no encontró la inspección, la API dispara el error 404
    if not datos_preview:
        raise HTTPException(
            status_code=404, 
            detail="La inspección solicitada no existe o no cuenta con datos válidos."
        )
        
    return datos_preview

@reportes_router.get("/{inspeccion_id}/excel")
def descargar_excel_inspeccion(inspeccion_id: UUID, db: Session = Depends(get_db)):
    """
    Descarga los datos de una inspección específica en formato Excel.
    """
    buffer, filename = generar_excel_inspeccion(db, inspeccion_id)
    
    if not buffer:
        raise HTTPException(status_code=404, detail="Inspección no encontrada")

    headers = {'Content-Disposition': content_disposition(filename)}

    return StreamingResponse(
        buffer, 
        headers=headers, 
        media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )

@reportes_router.get("/kardex/{cliente_id}/excel")
def descargar_kardex_cliente(cliente_id: UUID, db: Session = Depends(get_db)):
    """
    Descarga los datos de una inspección específica en formato Excel.
    """
    buffer, filename = kardex_flota_cliente(db, cliente_id)
    
    if not buffer:
        raise HTTPException(status_code=404, detail="Inspección no encontrada")

    headers = {'Content-Disposition': content_disposition(filename)}

    return StreamingResponse(
        buffer, 
        headers=headers, 
        media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )

