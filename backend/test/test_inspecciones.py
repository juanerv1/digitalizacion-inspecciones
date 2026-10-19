"""Carga masiva por CSV, consulta de inspecciones y reportes en Excel."""
import io
import uuid

import pandas as pd
import pytest

from conftest import CSV_EJEMPLO_REPO, CSV_EJEMPLO_TEST, construir_payload_sync, subir_csv

XLSX = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"


def _primera_inspeccion(client, cliente_id):
    response = client.get(f"/inspection/client/{cliente_id}")
    assert response.status_code == 200
    return response.json()[0]


# ---------------------------------------------------------------------------
# Carga masiva por CSV
# ---------------------------------------------------------------------------
def test_csv_de_pruebas_crea_vehiculos_y_llantas(client, cliente_id):
    response = subir_csv(client, cliente_id, CSV_EJEMPLO_TEST)
    assert response.status_code == 200
    assert response.json()["status"] == "success"

    inspeccion = _primera_inspeccion(client, cliente_id)
    assert inspeccion["cantidad_vehiculos"] == 3
    assert inspeccion["cantidad_llantas"] == 6
    assert inspeccion["estado"] == "FINALIZADO"


requiere_csv_repo = pytest.mark.skipif(
    not CSV_EJEMPLO_REPO.exists(), reason="csv_files/ no está disponible (p. ej. dentro del contenedor)"
)


@requiere_csv_repo
def test_csv_de_ejemplo_del_repositorio(client, cliente_id):
    """El archivo documentado en el README debe cargarse sin errores."""
    response = subir_csv(client, cliente_id, CSV_EJEMPLO_REPO)
    assert response.status_code == 200

    inspeccion = _primera_inspeccion(client, cliente_id)
    assert inspeccion["cantidad_vehiculos"] == 8
    assert inspeccion["cantidad_llantas"] == 32

    vehiculos = client.get(f"/client/{cliente_id}/vehiculos").json()
    assert {v["codigo_vehiculo"] for v in vehiculos} == {str(c) for c in range(101, 109)}
    assert all(v["no_llantas"] == 4 for v in vehiculos)


@requiere_csv_repo
def test_csv_crea_catalogos_del_cliente(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_REPO)
    catalogo = client.get(f"/client/{cliente_id}/variables/vehicle-form").json()
    tipos = {v["nombre"] for v in catalogo["TipoVehiculo"]}
    assert tipos == {"Montacargas", "Cargador frontal", "Minicargador"}


def test_cargar_dos_veces_no_duplica_vehiculos(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST, nombre="Primera")
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST, nombre="Segunda", fecha="2026-04-27")

    assert len(client.get(f"/inspection/client/{cliente_id}").json()) == 2
    assert len(client.get(f"/client/{cliente_id}/vehiculos").json()) == 3


def test_inspecciones_se_ordenan_por_fecha_descendente(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST, nombre="Antigua", fecha="2025-01-01")
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST, nombre="Reciente", fecha="2026-01-01")
    nombres = [i["nombre"] for i in client.get(f"/inspection/client/{cliente_id}").json()]
    assert nombres == ["Reciente", "Antigua"]


def test_llanta_sin_codigo_recibe_codigo_generado(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_TEST)
    inspeccion = _primera_inspeccion(client, cliente_id)
    preview = client.get(f"/inspection/{inspeccion['id']}/preview").json()

    codigos = [ll["codigo_llanta"] for ll in preview["llantas"]]
    assert all(codigos), "Ninguna llanta debe quedar sin código"
    # Los códigos numéricos se conservan como texto (regresión: "500" no debe quedar "500.0")
    assert {"500", "558", "501", "502", "503"} <= set(codigos)
    # En el CSV de pruebas la llanta del equipo 2, posición 1 no tiene código: se genera uno
    generados = [c for c in codigos if c not in {"500", "558", "501", "502", "503"}]
    assert len(generados) == 1
    assert generados[0].endswith("21")  # ...{equipo}{posición}


def test_csv_soporta_separador_coma_y_punto_y_coma(client, cliente_id):
    contenido = (
        "Equipo;Tipo Equipo;Marca Equipo;Posicion;Codigo Llanta;Tipo Llanta;Dimension;Diseno;Marca;"
        "Fecha de Montaje;Kilometraje;Horometro;Ext;Cen;Int;PSI;Observaciones\n"
        "X1;Tractor;Kalder;1;A1;N;18.4-34;R1;Orlyn;14/03/2024;-;500;30;;28;20;OK\n"
    )
    response = client.post(
        "/inspection/",
        data={"cliente_id": cliente_id, "fecha_revision": "2026-03-27"},
        files={"file": ("inline.csv", io.BytesIO(contenido.encode("latin-1")), "text/csv")},
    )
    assert response.status_code == 200
    assert _primera_inspeccion(client, cliente_id)["cantidad_llantas"] == 1


def test_csv_invalido_no_deja_inspeccion_a_medias(client, cliente_id):
    """Si el archivo falla a mitad de proceso se hace rollback total."""
    contenido = "Columna;Otra\n1;2\n"
    with pytest.raises(Exception):
        client.post(
            "/inspection/",
            data={"cliente_id": cliente_id, "fecha_revision": "2026-03-27"},
            files={"file": ("malo.csv", io.BytesIO(contenido.encode()), "text/csv")},
        )
    assert client.get(f"/inspection/client/{cliente_id}").json() == []


def test_subir_csv_sin_archivo_responde_422(client, cliente_id):
    response = client.post("/inspection/", data={"cliente_id": cliente_id, "fecha_revision": "2026-03-27"})
    assert response.status_code == 422


# ---------------------------------------------------------------------------
# Consulta y reportes
# ---------------------------------------------------------------------------
@requiere_csv_repo
def test_preview_de_inspeccion(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_REPO)
    inspeccion = _primera_inspeccion(client, cliente_id)

    response = client.get(f"/inspection/{inspeccion['id']}/preview")
    assert response.status_code == 200
    preview = response.json()
    assert len(preview["vehiculos"]) == 8
    assert len(preview["llantas"]) == 32

    llanta = next(ll for ll in preview["llantas"] if ll["observacion"] == "CORTE EN COSTADO")
    assert llanta["marca_llanta"] == "Orlyn"
    assert llanta["dimension_llanta"] == "33X12-20"


def test_preview_de_inspeccion_inexistente_responde_404(client):
    assert client.get(f"/inspection/{uuid.uuid4()}/preview").status_code == 404


def test_descargar_excel_de_inspeccion(client, cliente_id):
    payload = construir_payload_sync(cliente_id, n_vehiculos=1, llantas_por_vehiculo=1)
    assert client.post("/mobile/sync/send", json=payload).status_code == 200
    inspeccion_id = payload["inspecciones"][0]["id"]

    response = client.get(f"/inspection/{inspeccion_id}/excel")
    assert response.status_code == 200
    assert XLSX in response.headers["content-type"]
    assert "attachment; filename=" in response.headers["content-disposition"]

    # Si Pandas puede leerlo, el archivo es un Excel válido
    df = pd.read_excel(io.BytesIO(response.content))
    for columna in ["Vehículo Codigo", "Marca Vehiculo", "Horómetro", "Cód. Llanta", "Med. Ext"]:
        assert columna in df.columns
    assert df.iloc[0]["Cód. Llanta"] == "LL-1-1"
    assert df.iloc[0]["Horómetro"] == 1000.0
    assert df.iloc[0]["Marca Vehiculo"] == "Norvik"


def test_descargar_excel_de_inspeccion_inexistente_responde_404(client):
    assert client.get(f"/inspection/{uuid.uuid4()}/excel").status_code == 404


@requiere_csv_repo
def test_descargar_kardex_de_flota(client, cliente_id):
    subir_csv(client, cliente_id, CSV_EJEMPLO_REPO)
    response = client.get(f"/inspection/kardex/{cliente_id}/excel")
    assert response.status_code == 200
    assert XLSX in response.headers["content-type"]
    assert len(pd.read_excel(io.BytesIO(response.content))) > 0


def test_kardex_de_cliente_inexistente_responde_404(client):
    assert client.get(f"/inspection/kardex/{uuid.uuid4()}/excel").status_code == 404
