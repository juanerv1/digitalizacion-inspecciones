from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import os

# --- 1. Importaciones de Base de Datos ---
from db.base import engine
from db.models import Base 

# --- 2. Importaciones de Routers ---
from api.web import clients_router, reportes_router
from api.mobile import mobile_router

# --- 3. Creación de Tablas ---


# --- 4. Inicialización de la App ---
# La documentación interactiva (/docs) solo se expone si ENABLE_DOCS=true
docs_habilitados = os.getenv("ENABLE_DOCS", "false").lower() == "true"
app = FastAPI(
    title="API Digitalización de Inspecciones",
    docs_url="/docs" if docs_habilitados else None,
    redoc_url=None,
    openapi_url="/openapi.json" if docs_habilitados else None
)

origins_env = os.getenv("FRONTEND_URL", "*")

origins = [origin.strip() for origin in origins_env.split(",")]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- 6. Routers y Endpoints base ---
@app.get("/health")
def health_check():
    return {"status": "healthy"}

app.include_router(clients_router)
app.include_router(reportes_router)
app.include_router(mobile_router)