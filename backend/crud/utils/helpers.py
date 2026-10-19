import datetime
import datetime

def formatear_fecha_kartex(fecha_str):
    # Si viene vacía, retornamos directamente el nulo (None)
    if not fecha_str or str(fecha_str).strip() in ['-', '', 'nan', 'None', 'NaT']:
        return None

    fecha_str = str(fecha_str).strip().lower()

    # Reemplazamos los meses por su NÚMERO. 
    # Esto evita totalmente el problema del idioma del sistema.
    MESES = {
        'ene': '01', 'feb': '02', 'mar': '03', 'abr': '04',
        'may': '05', 'jun': '06', 'jul': '07', 'ago': '08',
        'sep': '09', 'oct': '10', 'nov': '11', 'dic': '12',
        # Abreviaturas en inglés que difieren del español (Excel en inglés)
        'jan': '01', 'apr': '04', 'aug': '08', 'dec': '12'
    }

    for es, num in MESES.items():
        if es in fecha_str:
            fecha_str = fecha_str.replace(es, num)
            break

    # Como ahora todo es numérico (ej. 07-05-25), usamos %m
    formatos = [
        "%d-%m-%y",   # 07-05-25 (antes 07-may-25)
        "%d-%m-%Y",   # 13-10-2023
        "%Y-%m-%d",   # 2023-10-13 (formato de base de datos típico por si acaso)
        "%d/%m/%Y",   # 13/10/2023 (con barras por si acaso)
    ]

    for formato in formatos:
        try:
            return datetime.datetime.strptime(fecha_str, formato).date()
        except ValueError: # Es mejor especificar ValueError que dejar un except suelto
            continue

    print(f"Formato no reconocido: {fecha_str}")
    return None

# =================================================================
# 2. FUNCIONES DE APOYO (Helpers)
# =================================================================
from typing import Union
from uuid import UUID
from sqlalchemy.orm import Session
from db.models import ClienteVariable, TipoVariableEnum


def procesar_variable_dinamica(
    db: Session, 
    cliente_id: UUID, 
    tipo_enum: TipoVariableEnum, 
    variable_input: Union[UUID, str]
) -> UUID:
    """
    Evalúa si la entrada es un UUID (ya existe) o un string (nueva/buscar).
    Retorna el UUID definitivo a guardar en el vehículo.
    """
    # Si el frontend ya mandó un UUID, lo usamos directamente
    if isinstance(variable_input, UUID):
        return variable_input

    # Pydantic entrega los UUID del JSON como texto (Union[UUID, str]): si el texto
    # es el id de una variable existente del cliente, se reutiliza
    try:
        posible_id = UUID(str(variable_input).strip())
        existente = db.query(ClienteVariable).filter(
            ClienteVariable.id == posible_id,
            ClienteVariable.cliente_id == cliente_id,
        ).first()
        if existente:
            return existente.id
    except ValueError:
        pass
    
    # Si es un string, aplicamos la lógica de limpieza y búsqueda/creación
    nombre_str = str(variable_input).strip()
    
    if not nombre_str or nombre_str.lower() in ['-', 'nan', 'none', 'null']:
        nombre = "N/A"
    else:
        nombre = nombre_str

    # Buscar si ya existe por nombre ignorando mayúsculas/minúsculas (ilike)
    variable_db = db.query(ClienteVariable).filter(
        ClienteVariable.cliente_id == cliente_id,
        ClienteVariable.tipo_variable == tipo_enum,
        ClienteVariable.nombre.ilike(nombre) 
    ).first()

    # Si no existe, la creamos al vuelo
    if not variable_db:
        variable_db = ClienteVariable(
            cliente_id=cliente_id,
            tipo_variable=tipo_enum,
            nombre=nombre
        )
        db.add(variable_db)
        db.flush() # CRÍTICO: Obtiene el ID generado en la misma transacción
        
    return variable_db.id
