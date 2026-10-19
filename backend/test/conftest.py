import os
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path

import pytest

# 1. Variables de entorno ANTES de importar la app:
#    db/base.py crea el engine al importarse y api/security.py lee la API Key al importarse.
TEST_DIR = Path(__file__).resolve().parent
TEST_DB_PATH = TEST_DIR / "test_database.db"
TEST_API_KEY = "test-api-key"

os.environ["DATABASE_URL"] = f"sqlite:///{TEST_DB_PATH}"
os.environ["API_KEY_SECRET"] = TEST_API_KEY

sys.path.insert(0, str(TEST_DIR.parent))

from fastapi.testclient import TestClient  # noqa: E402
from sqlalchemy import create_engine, pool  # noqa: E402
from sqlalchemy.orm import sessionmaker  # noqa: E402

from main import app  # noqa: E402
from db.base import get_db  # noqa: E402
from db.models import Base  # noqa: E402
from api.security import verificar_token  # noqa: E402

DATA_DIR = TEST_DIR / "data"
CSV_EJEMPLO_TEST = DATA_DIR / "ejemplo_kartex.csv"
CSV_EJEMPLO_REPO = TEST_DIR.parent.parent / "csv_files" / "ejemplo_inspeccion.csv"

# 2. Base de datos SQLite para pruebas (rápida y desechable)
engine = create_engine(
    f"sqlite:///{TEST_DB_PATH}",
    connect_args={"check_same_thread": False},
    poolclass=pool.StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


def override_verificar_token():
    """Simula un usuario autenticado en Clerk sin llamar a la red."""
    return {"sub": "user_test"}


app.dependency_overrides[get_db] = override_get_db


@pytest.fixture(autouse=True)
def base_de_datos_limpia():
    """Cada test arranca con las tablas vacías: los tests no dependen del orden."""
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="session", autouse=True)
def eliminar_archivo_bd():
    yield
    engine.dispose()
    if TEST_DB_PATH.exists():
        TEST_DB_PATH.unlink()


@pytest.fixture
def db_session():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture
def client():
    """Cliente HTTP autenticado: endpoints web con Clerk simulado y header X-API-KEY válido."""
    app.dependency_overrides[verificar_token] = override_verificar_token
    with TestClient(app, headers={"X-API-KEY": TEST_API_KEY}) as c:
        yield c
    app.dependency_overrides.pop(verificar_token, None)


@pytest.fixture
def anon_client():
    """Cliente HTTP sin credenciales, para probar la seguridad."""
    app.dependency_overrides.pop(verificar_token, None)
    with TestClient(app) as c:
        yield c


@pytest.fixture
def cliente_id(client):
    response = client.post("/client/", json={"nombre": "Cliente Demo - Valle"})
    assert response.status_code == 200
    return response.json()["id"]


def subir_csv(client, cliente_id, ruta_csv, nombre="Inspección CSV", fecha="2026-03-27"):
    with open(ruta_csv, "rb") as f:
        return client.post(
            "/inspection/",
            data={"cliente_id": cliente_id, "nombre": nombre, "fecha_revision": fecha},
            files={"file": (Path(ruta_csv).name, f, "text/csv")},
        )


def construir_payload_sync(cliente_id, n_vehiculos=2, llantas_por_vehiculo=2, estado="FINALIZADO"):
    """Arma un payload como el que envía la app, con la metadata de conteos coherente."""
    ahora = datetime.now(timezone.utc).isoformat()
    tipo_id, marca_id, marca_llanta_id = (str(uuid.uuid4()) for _ in range(3))
    inspeccion_id = str(uuid.uuid4())

    variables = [
        {"id": tipo_id, "cliente_id": cliente_id, "tipo_variable": "TipoVehiculo", "nombre": "Montacargas", "created_at": ahora},
        {"id": marca_id, "cliente_id": cliente_id, "tipo_variable": "MarcaVehiculo", "nombre": "Norvik", "created_at": ahora},
        {"id": marca_llanta_id, "cliente_id": cliente_id, "tipo_variable": "MarcaLlata", "nombre": "Taurex", "created_at": ahora},
    ]
    vehiculos, insp_vehiculos, llantas = [], [], []
    for v in range(n_vehiculos):
        vehiculo_id = str(uuid.uuid4())
        vehiculos.append({
            "id": vehiculo_id, "codigo_vehiculo": f"V-{v + 1}", "cliente_id": cliente_id,
            "tipo_id": tipo_id, "marca_id": marca_id, "no_llantas": llantas_por_vehiculo,
            "created_at": ahora, "updated_at": ahora,
        })
        insp_vehiculos.append({
            "id": str(uuid.uuid4()), "inspeccion_id": inspeccion_id, "vehiculo_id": vehiculo_id,
            "horometro": 1000.0 + v, "kilometraje": None, "created_at": ahora,
        })
        for p in range(llantas_por_vehiculo):
            llantas.append({
                "id": str(uuid.uuid4()), "inspeccion_id": inspeccion_id, "vehiculo_id": vehiculo_id,
                "codigo_llanta": f"LL-{v + 1}-{p + 1}", "fecha_montaje": "2025-01-15",
                "marca_llanta_id": marca_llanta_id, "posicion": p + 1, "presion": 35.0,
                "medida_ext": 20.0, "medida_cent": 19.0, "medida_int": 18.0, "observacion": None,
                "created_at": ahora, "updated_at": ahora,
            })

    inspecciones = [{
        "id": inspeccion_id, "cliente_id": cliente_id, "nombre": "Inspección App",
        "fecha_revision": "2026-01-10", "estado": estado, "created_at": ahora, "updated_at": ahora,
    }]

    return {
        "metadata": {
            "server_timestamp": ahora,
            "counts": {
                "clientes": 0,
                "variables": len(variables),
                "vehiculos": len(vehiculos),
                "inspecciones": len(inspecciones),
                "inspeccion_vehiculos": len(insp_vehiculos),
                "inspeccion_llantas": len(llantas),
            },
        },
        "variables": variables,
        "vehiculos": vehiculos,
        "inspecciones": inspecciones,
        "inspeccion_vehiculos": insp_vehiculos,
        "inspeccion_llantas": llantas,
    }
