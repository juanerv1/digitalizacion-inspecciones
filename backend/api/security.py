from fastapi import Security, HTTPException, status, Depends
from fastapi.security.api_key import APIKeyHeader
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os
import httpx
from jose import jwt

# Nombre del header que esperaremos
API_KEY_NAME = "X-API-KEY"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

# Esta llave debe estar en tus variables de entorno de Render
API_KEY = os.getenv("API_KEY_SECRET")

async def get_api_key(api_key_header: str = Security(api_key_header)):
    # Si API_KEY_SECRET no está configurada, se rechaza todo (evita que None == None autorice)
    if API_KEY and api_key_header == API_KEY:
        return api_key_header
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="No tienes permiso para acceder a este recurso. API Key inválida."
    )

security = HTTPBearer()

# URL de tu instancia de Clerk (Dashboard > Frontend API URL), definida en .env
CLERK_ISSUER = os.getenv("CLERK_ISSUER", "").rstrip("/")

def get_clerk_jwks():
    # Obtiene las llaves criptográficas de Clerk para validar el token
    jwks_url = f"{CLERK_ISSUER}/.well-known/jwks.json"
    response = httpx.get(jwks_url)
    return response.json()

def verificar_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    try:
        jwks = get_clerk_jwks()
        unverified_header = jwt.get_unverified_header(token)
        
        # Buscar la llave correcta
        rsa_key = {}
        for key in jwks["keys"]:
            if key["kid"] == unverified_header["kid"]:
                rsa_key = key
                break
                
        if rsa_key:
            payload = jwt.decode(
                token,
                rsa_key,
                algorithms=["RS256"],
                issuer=CLERK_ISSUER,
                options={"verify_aud": False}  # Clerk no incluye "aud" por defecto
            )
            return payload # Contiene el ID del usuario
    except Exception as e:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")
        
    raise HTTPException(status_code=401, detail="No se pudo validar la firma")