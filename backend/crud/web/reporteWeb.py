import io
import pandas as pd
from crud.utils.helpers import formatear_fecha_kartex, procesar_variable_dinamica
from fastapi import UploadFile, HTTPException
from schemas.reporte import ReportePlataformaCreate
from sqlalchemy import func, distinct
from sqlalchemy.orm import Session
from db.models import (
    Cliente, Inspeccion, InspeccionVehiculo, InspeccionLlanta, 
    Vehiculo, ClienteVariable, TipoVariableEnum
)
from db.models import Inspeccion, InspeccionVehiculo, InspeccionLlanta

from uuid import UUID
from typing import List, Dict, Any


def clean_num(val):
    """Convierte valores de Pandas/NumPy a float de Python o None si es NaN."""
    num = pd.to_numeric(val, errors='coerce')
    # pd.isna captura tanto NaN como None
    return float(num) if pd.notna(num) else None


def procesar_kartex_pandas(db: Session, reporte_data: ReportePlataformaCreate, file: UploadFile):
    try:
        # --- 1. CREACION DE LA INSPECCIÓN ---
        nueva_inspeccion = Inspeccion(
            cliente_id=reporte_data.cliente_id,
            nombre=reporte_data.nombre,
            fecha_revision=reporte_data.fecha_revision,
            estado="FINALIZADO"
        )
        db.add(nueva_inspeccion)
        db.flush() 

        # --- 2. LECTURA Y LIMPIEZA DEL DATAFRAME ---
        file.file.seek(0)
        content = file.file.read()
        
        # Los códigos se leen como texto: si una celda está vacía, Pandas convertiría
        # la columna a float y "500" terminaría guardado como "500.0"
        tipos_texto = {'Equipo': str, 'Codigo Llanta': str}

        try:
            # 1. Intento estándar: asume que el archivo viene en UTF-8
            df = pd.read_csv(io.BytesIO(content), sep=None, engine='python', encoding='utf-8', dtype=tipos_texto)
        except UnicodeDecodeError:
            # 2. Contingencia: si explota por caracteres como la Ñ o tildes, lo lee como Latin-1
            df = pd.read_csv(io.BytesIO(content), sep=None, engine='python', encoding='latin-1', dtype=tipos_texto)
        
        # Limpieza de nombres de columnas

        df = df.rename(columns={
            'Diseño': 'Diseno',
            'diseño': 'Diseno',
            'Dimensión': 'Dimension', # Aprovechamos de proteger 'Dimensión' por si acaso
            'dimensión': 'Dimension'
        })
        
        df.columns = [" ".join(str(col).split()) for col in df.columns]
        df.columns = df.columns.str.replace(r'[^\w\s.#]', '', regex=True).str.strip()

        # --- NUEVO: RELLENAR VALORES NULOS ---
        # Evitamos que el groupby borre filas y protegemos la creación de variables
        columnas_vehiculo = ['Equipo', 'Tipo Equipo', 'Marca Equipo']
        columnas_llanta = ['Tipo Llanta', 'Marca', 'Diseno', 'Dimension']
        
        for col in columnas_vehiculo + columnas_llanta:
            if col in df.columns:
                df[col] = df[col].fillna("-")

        # --- 3. PROCESAMIENTO DE VEHICULOS E INSPECCIONES ---
        equipos_grouped = df.groupby(['Equipo', 'Tipo Equipo', 'Marca Equipo'])

        # VAMOS A IMPRIMIR ESTO PARA DEPURAR EL TEST
        print(f"\n--- DEBUG PANDAS ---")
        print(f"Total de filas leídas del CSV: {len(df)}")
        print(f"Grupos de vehículos detectados: {len(equipos_grouped)}")
        print(f"--------------------\n")

        for (codigo_v, tipo_v_nom, marca_v_nom), group in equipos_grouped:
            
            # 3.1 Obtener IDs de variables para el Vehículo usando nuestro Enum
            t_v_id = procesar_variable_dinamica(db, reporte_data.cliente_id, TipoVariableEnum.TIPO_VEHICULO, tipo_v_nom)
            m_v_id = procesar_variable_dinamica(db, reporte_data.cliente_id, TipoVariableEnum.MARCA_VEHICULO, marca_v_nom)
            
            # 3.2 Buscar o Crear Vehículo
            vehiculo_db = db.query(Vehiculo).filter(
                Vehiculo.codigo_vehiculo == str(codigo_v),
                Vehiculo.cliente_id == reporte_data.cliente_id,
                Vehiculo.no_llantas == int(group['Posicion'].max()), 
                Vehiculo.tipo_id == t_v_id,
                Vehiculo.marca_id == m_v_id
            ).first()

            if not vehiculo_db:
                vehiculo_db = Vehiculo(
                    codigo_vehiculo=str(codigo_v),
                    cliente_id=reporte_data.cliente_id,
                    no_llantas=int(group['Posicion'].max()),
                    tipo_id=t_v_id,   
                    marca_id=m_v_id   
                )
                db.add(vehiculo_db)
                db.flush()
            
            # 3.3 Crear Inspección de Vehículo
            primer_reg = group.iloc[0]
            inspeccion_v = InspeccionVehiculo(
                inspeccion_id=nueva_inspeccion.id,
                vehiculo_id=vehiculo_db.id,
                horometro=clean_num(primer_reg.get('Horometro')),
                kilometraje=clean_num(primer_reg.get('Kilometraje'))
            )
            db.add(inspeccion_v)

            # --- 4. PROCESAMIENTO DE LLANTAS ---
            for _, row in group.iterrows():
                
                # 4.1 Obtener IDs de variables para la Llanta usando nuestro Enum
                t_ll_id = procesar_variable_dinamica(db, reporte_data.cliente_id, TipoVariableEnum.TIPO_LLANTA, row.get('Tipo Llanta'))
                m_ll_id = procesar_variable_dinamica(db, reporte_data.cliente_id, TipoVariableEnum.MARCA_LLANTA, row.get('Marca'))
                d_ll_id = procesar_variable_dinamica(db, reporte_data.cliente_id, TipoVariableEnum.DISENO_LLANTA, row.get('Diseno'))
                dim_ll_id = procesar_variable_dinamica(db, reporte_data.cliente_id, TipoVariableEnum.DIMENSION_LLANTA, row.get('Dimension'))

                # 4.2 Obtener código base de la llanta
                raw_cod = row.get('Codigo Llanta')
                posicion_actual = int(row['Posicion'])

                if not raw_cod or str(raw_cod).strip() in ['-', '', 'None', 'nan']:
                    fecha_str = nueva_inspeccion.fecha_revision.strftime("%d%m%y")
                    cod_ll = f"{nueva_inspeccion.id.hex[:4].upper()}{fecha_str}{codigo_v}{posicion_actual}"
                else:
                    cod_ll = str(raw_cod).strip()

                # 4.3 CREACION DE INSPECCION DE LLANTA
                inspeccion_ll = InspeccionLlanta(
                    inspeccion_id=nueva_inspeccion.id,
                    vehiculo_id=vehiculo_db.id,
                    codigo_llanta=cod_ll, 
                    fecha_montaje=formatear_fecha_kartex(row.get('Fecha de Montaje')),
                    horometro_montaje=clean_num(row.get('Horo Montaje')),
                    kilometraje_montaje=clean_num(row.get('Km Montaje')),
                    tipo_llanta_id=t_ll_id,
                    marca_llanta_id=m_ll_id,
                    dimension_llanta_id=dim_ll_id,
                    diseno_llanta_id=d_ll_id,
                    
                    posicion=posicion_actual,
                    presion=clean_num(row.get('PSI')),
                    medida_ext=clean_num(row.get('Ext')),
                    medida_cent=clean_num(row.get('Cen')),
                    medida_int=clean_num(row.get('Int')),
                    observacion=str(row['Observaciones']) if pd.notna(row.get('Observaciones')) else None
                )
                db.add(inspeccion_ll)

        # Confirmamos la transacción
        db.commit()

        # Consulta final para retornar éxito (Ajusta según necesites)
        total_vehiculos_bd = db.query(Vehiculo).filter(Vehiculo.cliente_id == nueva_inspeccion.cliente_id).count()
        total_llantas_bd = db.query(InspeccionLlanta).filter(InspeccionLlanta.inspeccion_id == nueva_inspeccion.id).count()

        return {
            "status": "success",
            "mensaje": "Reporte procesado correctamente",
            "vehiculos_guardados": total_vehiculos_bd,
            "llantas_guardadas": total_llantas_bd
        }

    except Exception as e:
        db.rollback()
        # Manejo de error (asegúrate de registrarlo o lanzarlo según tu API)
        raise e
    
def get_resumen_inspecciones(db: Session, cliente_id: UUID) -> List[Dict[str, Any]]:
    resultados = db.query(
        Inspeccion,
        func.count(distinct(InspeccionVehiculo.id)).label("cantidad_vehiculos"),
        func.count(distinct(InspeccionLlanta.id)).label("cantidad_llantas")
    ).outerjoin(
        InspeccionVehiculo, Inspeccion.id == InspeccionVehiculo.inspeccion_id
    ).outerjoin(
        InspeccionLlanta, Inspeccion.id == InspeccionLlanta.inspeccion_id
    ).filter(
        Inspeccion.cliente_id == cliente_id
    ).group_by(
        Inspeccion.id
    ).order_by(
        Inspeccion.fecha_revision.desc()
    ).all()

    inspecciones_formateadas = []
    for inspeccion, cant_vehiculos, cant_llantas in resultados:
        inspecciones_formateadas.append({
            "id": inspeccion.id,
            "nombre": inspeccion.nombre,
            "fecha_revision": inspeccion.fecha_revision,
            "estado": inspeccion.estado,
            "created_at": inspeccion.created_at,
            "cantidad_vehiculos": cant_vehiculos,
            "cantidad_llantas": cant_llantas
        })
    return inspecciones_formateadas

def obtener_preview_inspeccion(db: Session, inspeccion_id: UUID) -> dict | None:
    # 1. Buscar la inspección base
    inspeccion = db.query(Inspeccion).filter(Inspeccion.id == inspeccion_id).first()
    if not inspeccion:
        return None

    # 2. Obtener métricas de vehículos asociados
    insp_vehiculos = db.query(InspeccionVehiculo).filter(InspeccionVehiculo.inspeccion_id == inspeccion_id).all()
    vehiculo_ids = [iv.vehiculo_id for iv in insp_vehiculos]
    vehiculos_maestro = db.query(Vehiculo).filter(Vehiculo.id.in_(vehiculo_ids)).all() if vehiculo_ids else []

    # 3. Obtener las llantas registradas en esta inspección
    insp_llantas = db.query(InspeccionLlanta).filter(InspeccionLlanta.inspeccion_id == inspeccion_id).all()

    # 4. Mapeo inteligente de variables { id_variable: nombre_variable }
    variables_cliente = db.query(ClienteVariable).filter(ClienteVariable.cliente_id == inspeccion.cliente_id).all()
    mapa_variables = {str(var.id): var.nombre for var in variables_cliente}

    cliente = db.query(Cliente).filter(Cliente.id == inspeccion.cliente_id).first()

    # 5. Construir respuesta de llantas
    llantas_procesadas = []
    for ll in insp_llantas:
        def extraer_valor(campo):
            if campo is None: return None
            return campo.get("parsedValue") if isinstance(campo, dict) else campo

        llantas_procesadas.append({
            "id": str(ll.id),
            "vehiculo_id": str(ll.vehiculo_id),
            "codigo_llanta": ll.codigo_llanta,
            "posicion": ll.posicion,
            "fecha_montaje": ll.fecha_montaje.isoformat() if ll.fecha_montaje else None,
            "kilometraje_montaje": ll.kilometraje_montaje,
            "horometro_montaje": ll.horometro_montaje,
            "presion": ll.presion,
            "medida_int": extraer_valor(ll.medida_int),
            "medida_cent": extraer_valor(ll.medida_cent),
            "medida_ext": extraer_valor(ll.medida_ext),
            "observacion": ll.observacion,
            "marca_llanta": mapa_variables.get(str(ll.marca_llanta_id), "N/A"),
            "diseno_llanta": mapa_variables.get(str(ll.diseno_llanta_id), "N/A"),
            "dimension_llanta": mapa_variables.get(str(ll.dimension_llanta_id), "N/A"),
            "tipo_llanta": mapa_variables.get(str(ll.tipo_llanta_id), "N/A"),
        })

    return {
        "inspeccion": inspeccion,
        "cliente": cliente,
        "vehiculos": [
            {
                "id": str(v.id),
                "codigo_vehiculo": v.codigo_vehiculo,
                "no_llantas": v.no_llantas,
                # NUEVO: Resueltos con el mismo mapa de memoria
                "marca_vehiculo": mapa_variables.get(str(v.marca_id), "N/A"),
                "tipo_vehiculo": mapa_variables.get(str(v.tipo_id), "N/A"),
                "metricas": next((iv for iv in insp_vehiculos if iv.vehiculo_id == v.id), None)
            }
            for v in vehiculos_maestro
        ],
        "llantas": llantas_procesadas
    }