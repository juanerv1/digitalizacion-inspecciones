"""Funciones de normalización usadas en la carga masiva por CSV."""
import uuid
from datetime import date

import numpy as np
import pytest

from crud.utils.helpers import formatear_fecha_kartex, procesar_variable_dinamica
from crud.web.reporteWeb import clean_num
from db.models import Cliente, ClienteVariable, TipoVariableEnum


# ---------------------------------------------------------------------------
# formatear_fecha_kartex
# ---------------------------------------------------------------------------
@pytest.mark.parametrize("entrada, esperado", [
    ("14/03/2024", date(2024, 3, 14)),
    ("1/04/2023", date(2023, 4, 1)),
    ("13-10-2023", date(2023, 10, 13)),
    ("2023-10-13", date(2023, 10, 13)),
    ("07-may-25", date(2025, 5, 7)),
    ("01-ene-24", date(2024, 1, 1)),
    ("26-Apr-23", date(2023, 4, 26)),  # Mes abreviado en inglés que coincide con español
])
def test_formatear_fecha_formatos_soportados(entrada, esperado):
    assert formatear_fecha_kartex(entrada) == esperado


@pytest.mark.parametrize("entrada", [None, "", "-", " - ", "nan", "None", "NaT"])
def test_formatear_fecha_valores_vacios_retornan_none(entrada):
    assert formatear_fecha_kartex(entrada) is None


def test_formatear_fecha_formato_invalido_retorna_none():
    assert formatear_fecha_kartex("fecha rara") is None


# ---------------------------------------------------------------------------
# clean_num
# ---------------------------------------------------------------------------
@pytest.mark.parametrize("entrada, esperado", [
    (35, 35.0),
    ("42", 42.0),
    ("12.5", 12.5),
    (np.int64(7), 7.0),
])
def test_clean_num_convierte_a_float(entrada, esperado):
    resultado = clean_num(entrada)
    assert resultado == esperado
    assert type(resultado) is float


@pytest.mark.parametrize("entrada", [None, np.nan, "-", "VI", ""])
def test_clean_num_valores_no_numericos_retornan_none(entrada):
    assert clean_num(entrada) is None


# ---------------------------------------------------------------------------
# procesar_variable_dinamica (catálogos por cliente)
# ---------------------------------------------------------------------------
@pytest.fixture
def cliente_db(db_session):
    cliente = Cliente(nombre="Cliente Catálogos")
    db_session.add(cliente)
    db_session.commit()
    return cliente


def _variables(db_session, cliente_id):
    return db_session.query(ClienteVariable).filter(ClienteVariable.cliente_id == cliente_id).all()


def test_variable_nueva_se_crea(db_session, cliente_db):
    var_id = procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.MARCA_LLANTA, "Taurex")
    variables = _variables(db_session, cliente_db.id)
    assert len(variables) == 1
    assert variables[0].id == var_id
    assert variables[0].nombre == "Taurex"


def test_variable_existente_se_reutiliza_sin_importar_mayusculas(db_session, cliente_db):
    id1 = procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.MARCA_LLANTA, "Taurex")
    id2 = procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.MARCA_LLANTA, "  TAUREX ")
    assert id1 == id2
    assert len(_variables(db_session, cliente_db.id)) == 1


def test_mismo_nombre_en_otro_tipo_crea_variable_distinta(db_session, cliente_db):
    id1 = procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.MARCA_LLANTA, "Orlyn")
    id2 = procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.MARCA_VEHICULO, "Orlyn")
    assert id1 != id2


@pytest.mark.parametrize("vacio", ["-", "", "nan", "None"])
def test_valores_vacios_se_normalizan_a_na(db_session, cliente_db, vacio):
    procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.TIPO_LLANTA, vacio)
    assert _variables(db_session, cliente_db.id)[0].nombre == "N/A"


def test_uuid_se_retorna_sin_consultar(db_session, cliente_db):
    existente = uuid.uuid4()
    assert procesar_variable_dinamica(db_session, cliente_db.id, TipoVariableEnum.TIPO_LLANTA, existente) == existente
    assert _variables(db_session, cliente_db.id) == []
