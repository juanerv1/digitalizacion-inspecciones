import uuid
import csv
from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
from db.models import Cliente
from schemas.cliente import ClienteCreate, ClienteUpdate
from fastapi import UploadFile


def crear_cliente(db: Session, cliente_in: ClienteCreate):
    # **cliente_in.model_dump() desempaca el schema directamente al modelo
    db_cliente = Cliente(**cliente_in.model_dump())
    db.add(db_cliente)
    db.commit()
    db.refresh(db_cliente)
    return db_cliente



def get_cliente_por_id(db: Session, cliente_id: uuid.UUID):
    return db.query(Cliente).filter(Cliente.id == cliente_id).first()



def listar_clientes(db: Session):
    # Ordena primero por activo (True baja antes que False) y luego alfabéticamente por nombre
    return db.query(Cliente).order_by(
        asc(Cliente.nombre)
    ).all()



def actualizar_cliente(db: Session, cliente_id: uuid.UUID, cliente_in: ClienteUpdate):
    db_cliente = get_cliente_por_id(db, cliente_id)
    if not db_cliente:
        return None
    
    # exclude_unset=True ignora los campos que el usuario no envió en la petición
    datos_actualizar = cliente_in.model_dump(exclude_unset=True)
    for key, value in datos_actualizar.items():
        setattr(db_cliente, key, value) # Actualiza dinámicamente el atributo
        
    db.commit()
    db.refresh(db_cliente)
    return db_cliente
