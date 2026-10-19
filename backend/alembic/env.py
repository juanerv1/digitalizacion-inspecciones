import os 
from logging.config import fileConfig
from sqlalchemy import engine_from_config, pool
from alembic import context

# Objeto de configuración de Alembic
config = context.config

# Configurar logs
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# --- IMPORTACIÓN DE TUS MODELOS ---
from db.base import Base  
import db.models          
# ----------------------------------

target_metadata = Base.metadata

def get_url():
    """Obtiene la URL de la base de datos desde las variables de entorno."""
    return os.getenv("DATABASE_URL")

def run_migrations_offline() -> None:
    """Modo Offline: Para generar scripts SQL sin conectarse a la BD."""
    url = get_url() # Usamos la URL del entorno
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    """Modo Online: Se conecta a la BD y aplica los cambios directamente."""
    
    # 1. Obtenemos la sección de configuración del .ini
    configuration = config.get_section(config.config_ini_section, {})
    
    # 2. Sobrescribimos la URL con la de nuestra variable de entorno (Docker)
    configuration["sqlalchemy.url"] = get_url()

    # 3. Creamos el motor de conexión
    connectable = engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()

# Lógica de ejecución
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()