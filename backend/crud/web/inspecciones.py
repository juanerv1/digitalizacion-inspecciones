import pandas as pd
import io
from uuid import UUID
from db.models import Cliente, ClienteVariable, Inspeccion, InspeccionLlanta, InspeccionVehiculo, Vehiculo
from sqlalchemy.orm import Session, aliased
from sqlalchemy import func

def generar_excel_inspeccion(db: Session, inspeccion_id: UUID):
    # 1. Validar que la inspección exista
    inspeccion = db.query(Inspeccion).filter(Inspeccion.id == inspeccion_id).first()
    if not inspeccion:
        return None, None # Retornamos None para que la API sepa que debe lanzar un 404

    # 2. Obtener TODAS las variables del cliente
    variables_db = db.query(ClienteVariable).filter(ClienteVariable.cliente_id == inspeccion.cliente_id).all()
    nombres_vars = {var.id: var.nombre for var in variables_db}

    def get_var_nombre(var_id):
        return nombres_vars.get(var_id, "-") if var_id else "-"

    # 3. Consulta maestra
    resultados = db.query(
        InspeccionLlanta, Vehiculo, InspeccionVehiculo
    ).join(
        Vehiculo, InspeccionLlanta.vehiculo_id == Vehiculo.id
    ).outerjoin(
        InspeccionVehiculo, 
        (InspeccionVehiculo.inspeccion_id == inspeccion_id) & 
        (InspeccionVehiculo.vehiculo_id == Vehiculo.id)
    ).filter(
        InspeccionLlanta.inspeccion_id == inspeccion_id
    ).order_by(
        Vehiculo.codigo_vehiculo, InspeccionLlanta.posicion
    ).all()

    # 4. Construir la lista para Pandas
    datos_excel = []
    for llanta, vehiculo, insp_veh in resultados:
        fecha_montaje_str = llanta.fecha_montaje.strftime("%Y-%m-%d") if llanta.fecha_montaje else "-"

        fila = {
            "Vehículo Codigo": vehiculo.codigo_vehiculo,
            "Marca Vehiculo": get_var_nombre(vehiculo.marca_id),
            "Tipo Vehiculo": get_var_nombre(vehiculo.tipo_id),
            "Horómetro": insp_veh.horometro if insp_veh and insp_veh.horometro is not None else "-",
            "kilometraje": insp_veh.kilometraje if insp_veh and insp_veh.kilometraje is not None else "-",
            "Posición": llanta.posicion,
            "Cód. Llanta": llanta.codigo_llanta,
            "Dimensión": get_var_nombre(llanta.dimension_llanta_id),
            "Diseño": get_var_nombre(llanta.diseno_llanta_id),
            "Marca": get_var_nombre(llanta.marca_llanta_id),
            "Tipo": get_var_nombre(llanta.tipo_llanta_id),
            "Fecha de Montaje": fecha_montaje_str,
            "Horo Montaje": llanta.horometro_montaje if llanta.horometro_montaje is not None else "-",
            "Km Montaje": llanta.kilometraje_montaje if llanta.kilometraje_montaje is not None else "-",            "Med. Ext": llanta.medida_ext if llanta.medida_ext is not None else "-",
            "Med. Cent": llanta.medida_cent if llanta.medida_cent is not None else "-",
            "Med. Int": llanta.medida_int if llanta.medida_int is not None else "-",
            "Presión": llanta.presion if llanta.presion is not None else "-",
            "Observaciones": llanta.observacion if llanta.observacion else "-"
        }
        datos_excel.append(fila)

    columnas = ["Vehículo Codigo", "Marca Vehiculo", "Tipo Vehiculo", "Horómetro", "kilometraje", "Posición", "Cód. Llanta", "Dimensión", "Diseño", "Marca", "Tipo", "Fecha de Montaje","Horo Montaje","Km Montaje", "Med. Ext", "Med. Cent", "Med. Int", "Presión", "Observaciones"]
    
    if not datos_excel:
        df = pd.DataFrame(columns=columnas)
    else:
        df = pd.DataFrame(datos_excel)

    # 5. Escribir al buffer de memoria
    buffer = io.BytesIO()
    with pd.ExcelWriter(buffer, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Reporte')
        
        # Auto-ajuste de columnas
        worksheet = writer.sheets['Reporte']
        for col in worksheet.columns:
            max_length = 0
            column = col[0].column_letter
            for cell in col:
                try:
                    if len(str(cell.value)) > max_length:
                        max_length = len(str(cell.value))
                except:
                    pass
            worksheet.column_dimensions[column].width = (max_length + 2)

    buffer.seek(0)

    # 6. Preparar nombre del archivo
    nombre_seguro = inspeccion.nombre.replace(" ", "_") if inspeccion.nombre else "reporte"
    fecha_hoy = pd.Timestamp.now().strftime("%Y%m%d")
    filename = f"Inspeccion_{nombre_seguro}_{fecha_hoy}.xlsx"

    return buffer, filename

def kardex_flota_cliente(db: Session, cliente_id: UUID):
    cliente = db.query(Cliente).filter(Cliente.id == cliente_id).first()
    if not cliente:
        return None, None # Retornamos None para que la API sepa que debe lanzar un 404

    # 1. Obtener TODAS las variables del cliente
    variables_db = db.query(ClienteVariable).filter(ClienteVariable.cliente_id == cliente.id).all()
    nombres_vars = {var.id: var.nombre for var in variables_db}

    def get_var_nombre(var_id):
        return nombres_vars.get(var_id, "-") if var_id else "-"

    # 2. Crear la subconsulta con ROW_NUMBER
    subquery = db.query(
        InspeccionLlanta,
        func.row_number().over(
            partition_by=[InspeccionLlanta.vehiculo_id, InspeccionLlanta.posicion],
            order_by=InspeccionLlanta.created_at.desc()
        ).label('rn')
    ).join(
        Vehiculo, InspeccionLlanta.vehiculo_id == Vehiculo.id
    ).filter(
        Vehiculo.cliente_id == cliente_id
    ).subquery()

    # 3. Crear un alias del modelo basado en la subconsulta
    LlantaReciente = aliased(InspeccionLlanta, subquery)

    # 4. Consulta Maestra (¡MODIFICADA AQUÍ!)
    resultados = db.query(
        LlantaReciente, Vehiculo, InspeccionVehiculo, Inspeccion # <-- Añadido Inspeccion
    ).join(
        Vehiculo, LlantaReciente.vehiculo_id == Vehiculo.id
    ).join(
        Inspeccion, LlantaReciente.inspeccion_id == Inspeccion.id # <-- Join con Inspeccion
    ).outerjoin(
        InspeccionVehiculo, 
        (InspeccionVehiculo.inspeccion_id == LlantaReciente.inspeccion_id) & 
        (InspeccionVehiculo.vehiculo_id == Vehiculo.id)
    ).filter(
        subquery.c.rn == 1 
    ).order_by(
        Vehiculo.codigo_vehiculo, LlantaReciente.posicion
    ).all()

    # 5. Construir la lista para Pandas (¡MODIFICADO AQUÍ!)
    datos_excel = []
    # Añadimos 'inspeccion' al desempaquetado del for
    for llanta, vehiculo, insp_veh, inspeccion in resultados: 
        fecha_montaje_str = llanta.fecha_montaje.strftime("%Y-%m-%d") if llanta.fecha_montaje else "-"
        fecha_inspeccion_str = inspeccion.fecha_revision.strftime("%Y-%m-%d") if inspeccion.fecha_revision else "-"

        fila = {
            "Vehículo Codigo": vehiculo.codigo_vehiculo,
            "Marca Vehiculo": get_var_nombre(vehiculo.marca_id),
            "Tipo Vehiculo": get_var_nombre(vehiculo.tipo_id),
            "Horómetro": insp_veh.horometro if insp_veh and insp_veh.horometro is not None else "-",
            "kilometraje": insp_veh.kilometraje if insp_veh and insp_veh.kilometraje is not None else "-",
            "Posición": llanta.posicion,
            "Cód. Llanta": llanta.codigo_llanta,
            "Dimensión": get_var_nombre(llanta.dimension_llanta_id),
            "Diseño": get_var_nombre(llanta.diseno_llanta_id),
            "Marca": get_var_nombre(llanta.marca_llanta_id),
            "Tipo": get_var_nombre(llanta.tipo_llanta_id),
            "Fecha de Montaje": fecha_montaje_str,
            "Horo Montaje": llanta.horometro_montaje if llanta.horometro_montaje is not None else "-",
            "Km Montaje": llanta.kilometraje_montaje if llanta.kilometraje_montaje is not None else "-",            
            "Med. Ext": llanta.medida_ext if llanta.medida_ext is not None else "-",
            "Med. Cent": llanta.medida_cent if llanta.medida_cent is not None else "-",
            "Med. Int": llanta.medida_int if llanta.medida_int is not None else "-",
            "Presión": llanta.presion if llanta.presion is not None else "-",
            "Observaciones": llanta.observacion if llanta.observacion else "-",
            "Nombre Inspección": inspeccion.nombre if inspeccion.nombre else "-", # <-- Nuevo Campo
            "Fecha Inspección": fecha_inspeccion_str # <-- Extraído de Inspeccion.fecha_revision
        }
        datos_excel.append(fila)

    # Añadimos "Nombre Inspección" a la lista de columnas
    columnas = [
        "Vehículo Codigo", "Marca Vehiculo", "Tipo Vehiculo", "Horómetro", "kilometraje", 
        "Posición", "Cód. Llanta", "Dimensión", "Diseño", "Marca", "Tipo", "Fecha de Montaje",
        "Horo Montaje","Km Montaje", "Med. Ext", "Med. Cent", "Med. Int", "Presión", 
        "Observaciones", "Nombre Inspección", "Fecha Inspección"
    ]
    
    if not datos_excel:
        df = pd.DataFrame(columns=columnas)
    else:
        df = pd.DataFrame(datos_excel)

    # 6. Escribir al buffer de memoria
    buffer = io.BytesIO()
    with pd.ExcelWriter(buffer, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Reporte')
        
        # Auto-ajuste de columnas
        worksheet = writer.sheets['Reporte']
        for col in worksheet.columns:
            max_length = 0
            column = col[0].column_letter
            for cell in col:
                try:
                    if len(str(cell.value)) > max_length:
                        max_length = len(str(cell.value))
                except:
                    pass
            worksheet.column_dimensions[column].width = (max_length + 2)

    buffer.seek(0)

    # 7. Preparar nombre del archivo
    nombre_seguro = cliente.nombre.replace(" ", "_") if cliente.nombre else "reporte"
    fecha_hoy = pd.Timestamp.now().strftime("%Y%m%d")
    filename = f"Kardex_Flota_{nombre_seguro}_{fecha_hoy}.xlsx"

    return buffer, filename