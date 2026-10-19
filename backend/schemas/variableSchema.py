from db.models import TipoVariableEnum
from pydantic import BaseModel, ConfigDict
from datetime import datetime
from uuid import UUID
from typing import List, Optional


class ClienteVariableResponse(BaseModel):
    id: UUID
    cliente_id: UUID
    tipo_variable: TipoVariableEnum
    nombre: str
    created_at: datetime

    # Permite a Pydantic leer datos directamente de modelos de SQLAlchemy (Pydantic V2)
    model_config = ConfigDict(from_attributes=True)