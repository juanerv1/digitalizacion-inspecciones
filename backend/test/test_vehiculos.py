"""Endpoints de vehículos y catálogos dinámicos del cliente."""
from datetime import datetime, timezone
from unittest.mock import patch
from uuid import uuid4

MOCK_CLIENTE_ID = str(uuid4())
MOCK_VEHICULO_ID = str(uuid4())
MOCK_VEHICULO_RESPONSE = {
    "id": MOCK_VEHICULO_ID,
    "codigo_vehiculo": "TRAC-001",
    "cliente_id": MOCK_CLIENTE_ID,
    "tipo_id": str(uuid4()),
    "marca_id": str(uuid4()),
    "no_llantas": 4,
    "created_at": datetime.now(timezone.utc).isoformat(),
    "updated_at": datetime.now(timezone.utc).isoformat(),
}


# ---------------------------------------------------------------------------
# Unitarias
# ---------------------------------------------------------------------------
@patch("api.web.create_vehiculo")
def test_crear_vehiculo_mock(mock_create, client):
    mock_create.return_value = MOCK_VEHICULO_RESPONSE
    payload = {"codigo_vehiculo": "TRAC-001", "no_llantas": 4, "tipo": "Tractor", "marca": "Kalder"}
    response = client.post(f"/client/{MOCK_CLIENTE_ID}/vehiculos", json=payload)
    assert response.status_code == 201
    assert response.json()["codigo_vehiculo"] == "TRAC-001"


@patch("api.web.update_vehiculo", return_value=None)
def test_editar_vehiculo_inexistente_mock_responde_404(mock_update, client):
    response = client.put(f"/client/{MOCK_CLIENTE_ID}/vehiculos/{uuid4()}", json={"no_llantas": 6})
    assert response.status_code == 404


# ---------------------------------------------------------------------------
# Integración
# ---------------------------------------------------------------------------
def _crear_vehiculo(client, cliente_id, codigo="MC-01", tipo="Montacargas", marca="Norvik", llantas=4):
    return client.post(
        f"/client/{cliente_id}/vehiculos",
        json={"codigo_vehiculo": codigo, "no_llantas": llantas, "tipo": tipo, "marca": marca},
    )


def test_crear_vehiculo_crea_tipo_y_marca_en_el_catalogo(client, cliente_id):
    response = _crear_vehiculo(client, cliente_id)
    assert response.status_code == 201
    assert response.json()["no_llantas"] == 4

    catalogo = client.get(f"/client/{cliente_id}/variables/vehicle-form").json()
    assert [v["nombre"] for v in catalogo["TipoVehiculo"]] == ["Montacargas"]
    assert [v["nombre"] for v in catalogo["MarcaVehiculo"]] == ["Norvik"]


def test_vehiculos_con_misma_marca_reutilizan_la_variable(client, cliente_id):
    v1 = _crear_vehiculo(client, cliente_id, codigo="MC-01").json()
    v2 = _crear_vehiculo(client, cliente_id, codigo="MC-02", marca="NORVIK").json()
    assert v1["marca_id"] == v2["marca_id"]

    catalogo = client.get(f"/client/{cliente_id}/variables/vehicle-form").json()
    assert len(catalogo["MarcaVehiculo"]) == 1


def test_crear_vehiculo_con_uuid_de_variable_existente(client, cliente_id):
    v1 = _crear_vehiculo(client, cliente_id).json()
    v2 = _crear_vehiculo(client, cliente_id, codigo="MC-02", tipo=v1["tipo_id"], marca=v1["marca_id"]).json()
    assert (v2["tipo_id"], v2["marca_id"]) == (v1["tipo_id"], v1["marca_id"])


def test_listar_vehiculos_incluye_nombres_de_tipo_y_marca(client, cliente_id):
    _crear_vehiculo(client, cliente_id, codigo="MC-01")
    _crear_vehiculo(client, cliente_id, codigo="CF-01", tipo="Cargador frontal", marca="Kalder")

    vehiculos = client.get(f"/client/{cliente_id}/vehiculos").json()
    por_codigo = {v["codigo_vehiculo"]: v for v in vehiculos}
    assert por_codigo["MC-01"]["tipo_nombre"] == "Montacargas"
    assert por_codigo["CF-01"]["marca_nombre"] == "Kalder"


def test_vehiculos_de_otro_cliente_no_se_listan(client, cliente_id):
    otro_id = client.post("/client/", json={"nombre": "Otro - Bogotá"}).json()["id"]
    _crear_vehiculo(client, otro_id)
    assert client.get(f"/client/{cliente_id}/vehiculos").json() == []


def test_editar_vehiculo_parcialmente(client, cliente_id):
    vehiculo = _crear_vehiculo(client, cliente_id).json()
    response = client.put(f"/client/{cliente_id}/vehiculos/{vehiculo['id']}", json={"no_llantas": 6})
    assert response.status_code == 200
    assert response.json()["no_llantas"] == 6
    assert response.json()["codigo_vehiculo"] == "MC-01"


def test_editar_vehiculo_cambiando_marca_por_texto(client, cliente_id):
    vehiculo = _crear_vehiculo(client, cliente_id).json()
    response = client.put(f"/client/{cliente_id}/vehiculos/{vehiculo['id']}", json={"marca": "Veltra"})
    assert response.status_code == 200
    assert response.json()["marca_id"] != vehiculo["marca_id"]


def test_editar_vehiculo_de_otro_cliente_responde_404(client, cliente_id):
    otro_id = client.post("/client/", json={"nombre": "Otro - Bogotá"}).json()["id"]
    vehiculo = _crear_vehiculo(client, otro_id).json()
    response = client.put(f"/client/{cliente_id}/vehiculos/{vehiculo['id']}", json={"no_llantas": 2})
    assert response.status_code == 404


def test_crear_vehiculo_sin_campos_obligatorios_responde_422(client, cliente_id):
    response = client.post(f"/client/{cliente_id}/vehiculos", json={"codigo_vehiculo": "X"})
    assert response.status_code == 422
