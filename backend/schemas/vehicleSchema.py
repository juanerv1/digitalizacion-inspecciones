from pydantic import BaseModel, ConfigDict
from typing import Union, Optional, List
from uuid import UUID
from datetime import datetime

# ==========================================
# Esquemas para Vehículos
# ==========================================

class VehiculoBase(BaseModel):
    codigo_vehiculo: str
    no_llantas: int
    # Permite recibir un UUID (opción existente) o un String (nueva opción)
    tipo: Union[UUID, str] 
    marca: Union[UUID, str]

class VehiculoCreate(VehiculoBase):
    pass

class VehiculoUpdate(BaseModel):
    # Todos los campos son opcionales para permitir actualizaciones parciales (PATCH/PUT)
    codigo_vehiculo: Optional[str] = None
    no_llantas: Optional[int] = None
    tipo: Optional[Union[UUID, str]] = None
    marca: Optional[Union[UUID, str]] = None

class VehiculoResponse(BaseModel):
    id: UUID
    codigo_vehiculo: str
    cliente_id: UUID
    tipo_id: UUID
    marca_id: UUID
    no_llantas: int
    created_at: datetime
    updated_at: datetime
    
    # --- NUEVO: Campos planos para el frontend ---
    tipo_nombre: Optional[str] = None
    marca_nombre: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)