from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime, date
from uuid import UUID
from db.models import TipoVariableEnum # Asegúrate de importar tu Enum

# 0. Clientes
class ClienteSync(BaseModel):
    id: UUID
    nombre: str
    created_at: datetime
    updated_at: datetime

# 1. Variables
class ClienteVariableSync(BaseModel):
    id: UUID
    cliente_id: UUID
    tipo_variable: TipoVariableEnum
    nombre: str
    created_at: datetime

# 2. Vehículos
class VehiculoSync(BaseModel):
    id: UUID
    codigo_vehiculo: str
    cliente_id: UUID
    tipo_id: UUID
    marca_id: UUID
    no_llantas: int
    created_at: datetime
    updated_at: datetime

# 3. Inspección Base
class InspeccionSync(BaseModel):
    id: UUID
    cliente_id: UUID
    nombre: Optional[str] = None
    fecha_revision: date
    estado: str
    created_at: datetime
    updated_at: datetime

# 4. Inspección de Vehículos
class InspeccionVehiculoSync(BaseModel):
    id: UUID
    inspeccion_id: UUID
    vehiculo_id: UUID
    horometro: Optional[float] = None
    kilometraje: Optional[float] = None
    created_at: datetime

# 5. Inspección de Llantas
class InspeccionLlantaSync(BaseModel):
    id: UUID
    inspeccion_id: UUID
    vehiculo_id: UUID
    codigo_llanta: str
    fecha_montaje: Optional[date] = None
    horometro_montaje: Optional[float] = None
    kilometraje_montaje: Optional[float] = None
    tipo_llanta_id: Optional[UUID] = None
    marca_llanta_id: Optional[UUID] = None
    dimension_llanta_id: Optional[UUID] = None
    diseno_llanta_id: Optional[UUID] = None
    posicion: int
    presion: Optional[float] = None
    medida_int: Optional[float] = None
    medida_cent: Optional[float] = None
    medida_ext: Optional[float] = None
    observacion: Optional[str] = None
    created_at: datetime
    updated_at: datetime

# --- NUEVOS MODELOS PARA LA METADATA ---
class SyncCounts(BaseModel):
    clientes: int
    variables: int
    vehiculos: int
    inspecciones: int
    inspeccion_vehiculos: int
    inspeccion_llantas: int

class SyncMetadata(BaseModel):
    server_timestamp: datetime
    counts: SyncCounts

# --- TU PAYLOAD ACTUALIZADO ---
class AppSyncPayload(BaseModel):
    metadata: SyncMetadata  # Añadimos la metadata como campo obligatorio
    clientes: List[ClienteSync] = Field(default_factory=list) 
    variables: List[ClienteVariableSync] = Field(default_factory=list)
    vehiculos: List[VehiculoSync] = Field(default_factory=list)
    inspecciones: List[InspeccionSync] = Field(default_factory=list)
    inspeccion_vehiculos: List[InspeccionVehiculoSync] = Field(default_factory=list)
    inspeccion_llantas: List[InspeccionLlantaSync] = Field(default_factory=list)