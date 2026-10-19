"""Autenticación: la web exige JWT de Clerk y la app móvil exige X-API-KEY."""
import pytest

from conftest import TEST_API_KEY


def test_health_es_publico(anon_client):
    response = anon_client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


@pytest.mark.parametrize("ruta", ["/client/", "/inspection/client/00000000-0000-0000-0000-000000000000"])
def test_endpoints_web_sin_token_son_rechazados(anon_client, ruta):
    response = anon_client.get(ruta)
    assert response.status_code in (401, 403)


def test_endpoint_web_con_token_invalido_responde_401(anon_client):
    # El token no tiene formato JWT: debe fallar sin intentar validar la firma
    response = anon_client.get("/client/", headers={"Authorization": "Bearer token-falso"})
    assert response.status_code == 401


def test_sync_movil_sin_api_key_responde_403(anon_client):
    response = anon_client.get("/mobile/sync/download")
    assert response.status_code == 403


def test_sync_movil_con_api_key_incorrecta_responde_403(anon_client):
    response = anon_client.get("/mobile/sync/download", headers={"X-API-KEY": "otra-llave"})
    assert response.status_code == 403


def test_sync_movil_con_api_key_correcta_responde_200(anon_client):
    response = anon_client.get("/mobile/sync/download", headers={"X-API-KEY": TEST_API_KEY})
    assert response.status_code == 200


def test_api_key_no_configurada_rechaza_peticiones_sin_header(anon_client, monkeypatch):
    # Regresión: si API_KEY_SECRET falta, una petición sin header no debe autorizarse (None == None)
    monkeypatch.setattr("api.security.API_KEY", None)
    response = anon_client.get("/mobile/sync/download")
    assert response.status_code == 403
