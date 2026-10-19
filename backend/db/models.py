import uuid
import enum
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Integer, Enum, Date, Float, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

# Asegúrate de importar Base desde tu archivo de conexión
from db.base import Base 

# ==========================================
# 1. Definición de ENUMs (Python Enum)
# ==========================================
class TipoVariableEnum(enum.Enum):
    TIPO_VEHICULO = "TipoVehiculo"
    MARCA_VEHICULO = "MarcaVehiculo"
    DIMENSION_LLANTA = "DimensionLlanta"
    DISENO_LLANTA = "DisenoLlanta"
    MARCA_LLANTA = "MarcaLlata"
    TIPO_LLANTA = "TipoLlanta"

# ==========================================
# 2. Modelos (Tablas)
# ==========================================

class Cliente(Base):
    __tablename__ = "clientes"

    # Atributos
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    nombre = Column(String(100), nullable=False)

    # Tiempo
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relaciones
    variables = relationship("ClienteVariable", back_populates="cliente", cascade="all, delete-orphan")
    vehiculos = relationship("Vehiculo", back_populates="cliente", cascade="all, delete-orphan")
    inspecciones = relationship("Inspeccion", back_populates="cliente", cascade="all, delete-orphan")


class ClienteVariable(Base):
    __tablename__ = "cliente_variables" 

    # Atributos
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    cliente_id = Column(UUID(as_uuid=True), ForeignKey("clientes.id", ondelete="CASCADE"), nullable=False)
    tipo_variable = Column(Enum(TipoVariableEnum), nullable=False)
    nombre = Column(String(50), nullable=False) 

    # Tiempo
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Relaciones
    cliente = relationship("Cliente", back_populates="variables")


class Vehiculo(Base):
    __tablename__ = "vehiculos"

    # Atributos
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    codigo_vehiculo = Column(String(20), nullable=False) 
    cliente_id = Column(UUID(as_uuid=True), ForeignKey("clientes.id", ondelete="CASCADE"), nullable=False)
    
    # MODIFICADO: Agregado ondelete="CASCADE"
    tipo_id = Column(UUID(as_uuid=True), ForeignKey("cliente_variables.id", ondelete="CASCADE"), nullable=False)
    marca_id = Column(UUID(as_uuid=True), ForeignKey("cliente_variables.id", ondelete="CASCADE"), nullable=False)
    
    no_llantas = Column(Integer, nullable=False)

    # Tiempo
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relaciones
    cliente = relationship("Cliente", back_populates="vehiculos")
    tipo_rel = relationship("ClienteVariable", foreign_keys=[tipo_id])
    marca_rel = relationship("ClienteVariable", foreign_keys=[marca_id])
    inspecciones_historico = relationship("InspeccionVehiculo", back_populates="vehiculo", cascade="all, delete-orphan")

    @property
    def tipo_nombre(self) -> str | None:
        return self.tipo_rel.nombre if self.tipo_rel else None

    @property
    def marca_nombre(self) -> str | None:
        return self.marca_rel.nombre if self.marca_rel else None

class Inspeccion(Base):
    __tablename__ = "inspecciones" 

    # Atributos
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    cliente_id = Column(UUID(as_uuid=True), ForeignKey("clientes.id", ondelete="CASCADE"), nullable=False)
    nombre = Column(String(100))
    fecha_revision = Column(Date, nullable=False)
    estado = Column(String(20), nullable=False, default="FINALIZADO")

    # Tiempos
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relaciones
    cliente = relationship("Cliente", back_populates="inspecciones")
    vehiculos = relationship("InspeccionVehiculo", back_populates="inspeccion", cascade="all, delete-orphan")
    llantas = relationship("InspeccionLlanta", back_populates="inspeccion", cascade="all, delete-orphan")


class InspeccionVehiculo(Base):
    __tablename__ = "inspeccion_vehiculos"

    # Atributos
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    inspeccion_id = Column(UUID(as_uuid=True), ForeignKey("inspecciones.id", ondelete="CASCADE"), nullable=False)
    vehiculo_id = Column(UUID(as_uuid=True), ForeignKey("vehiculos.id", ondelete="CASCADE"), nullable=False)
    horometro = Column(Float, nullable=True) 
    kilometraje = Column(Float, nullable=True)

    # Tiempos
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Constraints
    __table_args__ = (
        UniqueConstraint("inspeccion_id", "vehiculo_id", name="uq_inspeccion_vehiculo"),
    )

    # Relaciones
    inspeccion = relationship("Inspeccion", back_populates="vehiculos")
    vehiculo = relationship("Vehiculo", back_populates="inspecciones_historico")


class InspeccionLlanta(Base):
    __tablename__ = "inspeccion_llantas"

    # Atributos
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    inspeccion_id = Column(UUID(as_uuid=True), ForeignKey("inspecciones.id", ondelete="CASCADE"), nullable=False)
    vehiculo_id = Column(UUID(as_uuid=True), ForeignKey("vehiculos.id", ondelete="CASCADE"), nullable=False)
    codigo_llanta = Column(String(50), nullable=False)
    fecha_montaje = Column(Date)
    
    # MODIFICADO: Agregado ondelete="CASCADE" a todas las variables
    tipo_llanta_id = Column(UUID(as_uuid=True), ForeignKey("cliente_variables.id", ondelete="CASCADE"))
    marca_llanta_id = Column(UUID(as_uuid=True), ForeignKey("cliente_variables.id", ondelete="CASCADE"))
    dimension_llanta_id = Column(UUID(as_uuid=True), ForeignKey("cliente_variables.id", ondelete="CASCADE"))
    diseno_llanta_id = Column(UUID(as_uuid=True), ForeignKey("cliente_variables.id", ondelete="CASCADE"))
    
    posicion = Column(Integer, nullable=False)
    horometro_montaje = Column(Float, nullable=True) 
    kilometraje_montaje = Column(Float, nullable=True)
    presion = Column(Float, nullable=True) 
    medida_int = Column(Float, nullable=True)  
    medida_cent = Column(Float, nullable=True) 
    medida_ext = Column(Float, nullable=True)  
    observacion = Column(String, nullable=True)

    # Tiempos
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # RELACIONES 
    inspeccion = relationship("Inspeccion", back_populates="llantas")
    vehiculo = relationship("Vehiculo") 
    tipo_rel = relationship("ClienteVariable", foreign_keys=[tipo_llanta_id])
    marca_rel = relationship("ClienteVariable", foreign_keys=[marca_llanta_id])
    dimension_rel = relationship("ClienteVariable", foreign_keys=[dimension_llanta_id])
    diseno_rel = relationship("ClienteVariable", foreign_keys=[diseno_llanta_id])

    __table_args__ = (
        UniqueConstraint("inspeccion_id", "vehiculo_id", "posicion", name="uq_inspeccion_llanta_posicion"),
    )