from pydantic import BaseModel, ConfigDict
from typing import Optional
from uuid import UUID
from datetime import datetime, date

class ClienteCreate(BaseModel):
    nombre: str

class ClienteUpdate(BaseModel):
    nombre: Optional[str] = None

class ClienteResponse(BaseModel):
    id: UUID
    nombre: str
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)