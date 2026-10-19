"""Endpoints de clientes: pruebas unitarias (capa CRUD simulada) e integración (BD real)."""
from datetime import datetime, timezone
from unittest.mock import patch
from uuid import uuid4

MOCK_CLIENTE_ID = str(uuid4())
MOCK_CLIENTE_RESPONSE = {
    "id": MOCK_CLIENTE_ID,
    "nombre": "Cliente Demo - Valle",
    "created_at": datetime.now(timezone.utc).isoformat(),
    "updated_at": datetime.now(timezone.utc).isoformat(),
}


# ---------------------------------------------------------------------------
# Unitarias: la capa CRUD se reemplaza por un mock
# ---------------------------------------------------------------------------
@patch("api.web.crear_cliente")
def test_create_client_mock(mock_crear, client):
    mock_crear.return_value = MOCK_CLIENTE_RESPONSE
    response = client.post("/client/", json={"nombre": "Cliente Demo - Valle"})
    assert response.status_code == 200
    assert response.json()["nombre"] == "Cliente Demo - Valle"
    mock_crear.assert_called_once()


@patch("api.web.crear_cliente", side_effect=Exception("fallo de BD"))
def test_create_client_error_de_bd_responde_400(mock_crear, client):
    response = client.post("/client/", json={"nombre": "X"})
    assert response.status_code == 400


@patch("api.web.get_cliente_por_id", return_value=None)
def test_get_client_not_found_mock(mock_get, client):
    response = client.get(f"/client/{uuid4()}")
    assert response.status_code == 404


# ---------------------------------------------------------------------------
# Integración: base de datos SQLite real
# ---------------------------------------------------------------------------
def test_crear_y_obtener_cliente(client):
    creado = client.post("/client/", json={"nombre": "Ingenio Demo - Bogotá"}).json()
    assert creado["nombre"] == "Ingenio Demo - Bogotá"
    assert {"id", "created_at", "updated_at"} <= creado.keys()

    obtenido = client.get(f"/client/{creado['id']}")
    assert obtenido.status_code == 200
    assert obtenido.json() == creado


def test_listar_clientes(client):
    for nombre in ["Alfa - Valle", "Beta - Medellín", "Gamma - Bogotá"]:
        client.post("/client/", json={"nombre": nombre})

    response = client.get("/client/")
    assert response.status_code == 200
    nombres = {c["nombre"] for c in response.json()}
    assert nombres == {"Alfa - Valle", "Beta - Medellín", "Gamma - Bogotá"}


def test_listar_clientes_vacio(client):
    assert client.get("/client/").json() == []


def test_crear_cliente_sin_nombre_responde_422(client):
    response = client.post("/client/", json={})
    assert response.status_code == 422


def test_editar_cliente(client, cliente_id):
    response = client.patch(f"/client/{cliente_id}", json={"nombre": "Nombre Nuevo - Valle"})
    assert response.status_code == 200
    assert response.json()["nombre"] == "Nombre Nuevo - Valle"
    assert client.get(f"/client/{cliente_id}").json()["nombre"] == "Nombre Nuevo - Valle"


def test_editar_cliente_inexistente_responde_404(client):
    response = client.patch(f"/client/{uuid4()}", json={"nombre": "X"})
    assert response.status_code == 404


def test_id_con_formato_invalido_responde_422(client):
    response = client.get("/client/no-es-un-uuid")
    assert response.status_code == 422
