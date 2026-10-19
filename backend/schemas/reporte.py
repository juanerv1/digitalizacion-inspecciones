from pydantic import BaseModel, ConfigDict
from uuid import UUID
from datetime import date, datetime
from typing import Optional
    
class ReportePlataformaCreate(BaseModel):
    cliente_id: UUID
    nombre: str | None = None     
    observacion: str | None = None 
    fecha_revision: date

class InspeccionResumenResponse(BaseModel):
    id: UUID
    nombre: Optional[str] = None
    fecha_revision: date
    estado: str
    created_at: datetime
    # Campos calculados
    cantidad_vehiculos: int
    cantidad_llantas: int

    model_config = ConfigDict(from_attributes=True)