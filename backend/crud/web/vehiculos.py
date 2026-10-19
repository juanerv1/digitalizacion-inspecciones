from sqlalchemy.orm import Session, joinedload
from uuid import UUID
from typing import List, Dict, Union
from db.models import ClienteVariable, TipoVariableEnum, Vehiculo
from schemas.variableSchema import ClienteVariableResponse
from schemas.vehicleSchema import VehiculoCreate, VehiculoUpdate

# Importamos la función de apoyo que creamos antes
from crud.utils.helpers import procesar_variable_dinamica 

def get_variables_vehiculo(db: Session, cliente_id: UUID) -> Dict[str, list]:
    tipos_requeridos = [TipoVariableEnum.TIPO_VEHICULO, TipoVariableEnum.MARCA_VEHICULO]
    
    variables = db.query(ClienteVariable).filter(
        ClienteVariable.cliente_id == cliente_id,
        ClienteVariable.tipo_variable.in_(tipos_requeridos)
    ).all()

    respuesta = {
        TipoVariableEnum.TIPO_VEHICULO.value: [],
        TipoVariableEnum.MARCA_VEHICULO.value: []
    }
    for var in variables:
        respuesta[var.tipo_variable.value].append(var)
    return respuesta


def get_vehiculos_por_cliente(db: Session, cliente_id: UUID) -> List[Vehiculo]:
    return (
        db.query(Vehiculo)
        # --- NUEVO: Carga ansiosa (Eager Loading) de las relaciones ---
        .options(
            joinedload(Vehiculo.tipo_rel),
            joinedload(Vehiculo.marca_rel)
        )
        .filter(Vehiculo.cliente_id == cliente_id)
        .all()
    )


def create_vehiculo(db: Session, cliente_id: UUID, vehiculo_in: VehiculoCreate) -> Vehiculo:
    tipo_id = procesar_variable_dinamica(
        db, cliente_id, TipoVariableEnum.TIPO_VEHICULO, vehiculo_in.tipo
    )
    marca_id = procesar_variable_dinamica(
        db, cliente_id, TipoVariableEnum.MARCA_VEHICULO, vehiculo_in.marca
    )

    nuevo_vehiculo = Vehiculo(
        codigo_vehiculo=vehiculo_in.codigo_vehiculo,
        cliente_id=cliente_id,
        tipo_id=tipo_id,
        marca_id=marca_id,
        no_llantas=vehiculo_in.no_llantas
    )
    db.add(nuevo_vehiculo)
    db.commit()
    db.refresh(nuevo_vehiculo)
    return nuevo_vehiculo


def update_vehiculo(db: Session, cliente_id: UUID, vehiculo_id: UUID, vehiculo_in: VehiculoUpdate) -> Vehiculo | None:
    vehiculo_db = db.query(Vehiculo).filter(
        Vehiculo.id == vehiculo_id, Vehiculo.cliente_id == cliente_id
    ).first()

    if not vehiculo_db:
        return None

    if vehiculo_in.codigo_vehiculo is not None:
        vehiculo_db.codigo_vehiculo = vehiculo_in.codigo_vehiculo
    if vehiculo_in.no_llantas is not None:
        vehiculo_db.no_llantas = vehiculo_in.no_llantas

    if vehiculo_in.tipo is not None:
        vehiculo_db.tipo_id = procesar_variable_dinamica(
            db, cliente_id, TipoVariableEnum.TIPO_VEHICULO, vehiculo_in.tipo
        )
    if vehiculo_in.marca is not None:
        vehiculo_db.marca_id = procesar_variable_dinamica(
            db, cliente_id, TipoVariableEnum.MARCA_VEHICULO, vehiculo_in.marca
        )

    db.commit()
    db.refresh(vehiculo_db)
    return vehiculo_db