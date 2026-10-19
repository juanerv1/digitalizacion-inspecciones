"""Sincronización con la app móvil: subida, descarga incremental e integridad."""
from datetime import datetime, timedelta, timezone

from conftest import CSV_EJEMPLO_TEST, construir_payload_sync, subir_csv


def test_subida_desde_la_app(client, cliente_id):
    payload = construir_payload_sync(cliente_id, n_vehiculos=3, llantas_por_vehiculo=2)
    response = client.post("/mobile/sync/send", json=payload)
    assert response.status_code == 200, response.text

    resumen = response.json()["resumen"]
    assert resumen["vehiculos_procesados"] == 3
    assert resumen["inspeccion_llantas_procesadas"] == 6

    # Lo subido por la app aparece en la plataforma web
    inspeccion = client.get(f"/inspection/client/{cliente_id}").json()[0]
    assert inspeccion["cantidad_vehiculos"] == 3
    assert inspeccion["cantidad_llantas"] == 6


def test_subida_es_idempotente(client, cliente_id):
    """Si la app reintenta el envío (p. ej. por un corte de red), no se duplican datos."""
    payload = construir_payload_sync(cliente_id)
    assert client.post("/mobile/sync/send", json=payload).status_code == 200
    assert client.post("/mobile/sync/send", json=payload).status_code == 200

    inspecciones = client.get(f"/inspection/client/{cliente_id}").json()
    assert len(inspecciones) == 1
    assert inspecciones[0]["cantidad_llantas"] == 4
    assert len(client.get(f"/client/{cliente_id}/vehiculos").json()) == 2


def test_subida_con_conteos_inconsistentes_es_rechazada(client, cliente_id):
    payload = construir_payload_sync(cliente_id)
    payload["metadata"]["counts"]["inspeccion_llantas"] += 1  # La app "dice" que envió una llanta más

    response = client.post("/mobile/sync/send", json=payload)
    assert response.status_code == 500
    assert "integridad" in response.json()["detail"].lower()

    # Rollback total: no se guardó nada
    assert client.get(f"/inspection/client/{cliente_id}").json() == []
    assert client.get(f"/client/{cliente_id}/vehiculos").json() == []


def test_subida_sin_metadata_responde_422(client, cliente_id):
    payload = construir_payload_sync(cliente_id)
    del payload["metadata"]
    assert client.post("/mobile/sync/send", json=payload).status_code == 422


def test_descarga_inicial_trae_todo_con_metadata(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST)

    response = client.get("/mobile/sync/download", params={"cliente_id": cliente_id})
    assert response.status_code == 200
    datos = response.json()

    assert len(datos["clientes"]) == 1
    assert len(datos["vehiculos"]) == 3
    assert len(datos["inspecciones"]) == 1
    assert len(datos["inspeccion_llantas"]) == 6

    # Los conteos declarados coinciden con lo enviado (la app los valida)
    counts = datos["metadata"]["counts"]
    for clave in ["clientes", "variables", "vehiculos", "inspecciones", "inspeccion_vehiculos", "inspeccion_llantas"]:
        assert counts[clave] == len(datos[clave]), clave
    assert datos["metadata"]["server_timestamp"]


def test_descarga_incremental_sin_cambios_esta_vacia(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST)
    manana = (datetime.now(timezone.utc) + timedelta(days=1)).isoformat()

    datos = client.get(
        "/mobile/sync/download",
        params={"cliente_id": cliente_id, "ultima_sincronizacion": manana},
    ).json()

    assert datos["vehiculos"] == []
    assert datos["inspeccion_llantas"] == []
    assert all(v == 0 for v in datos["metadata"]["counts"].values())


def test_descarga_filtrada_por_cliente(client, cliente_id):
    otro_id = client.post("/client/", json={"nombre": "Otro - Bogotá"}).json()["id"]
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST)
    subir_csv(client, otro_id, CSV_EJEMPLO_TEST)

    datos = client.get("/mobile/sync/download", params={"cliente_id": cliente_id}).json()
    assert {c["id"] for c in datos["clientes"]} == {cliente_id}
    assert all(v["cliente_id"] == cliente_id for v in datos["vehiculos"])
    assert len(datos["vehiculos"]) == 3


def test_descarga_sin_filtro_trae_todos_los_clientes(client, cliente_id):
    client.post("/client/", json={"nombre": "Otro - Bogotá"})
    datos = client.get("/mobile/sync/download").json()
    assert len(datos["clientes"]) == 2
