/// JSON con la misma forma que responde GET /mobile/sync/download.
Map<String, dynamic> respuestaDescarga() => {
      'metadata': {
        'server_timestamp': '2026-05-10T15:30:00Z',
        'counts': {
          'clientes': 1,
          'variables': 2,
          'vehiculos': 1,
          'inspecciones': 1,
          'inspeccion_vehiculos': 1,
          'inspeccion_llantas': 1,
        },
      },
      'clientes': [
        {'id': 'c1', 'nombre': 'Cliente Demo - Valle', 'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-02T00:00:00Z'},
      ],
      'variables': [
        {'id': 'v1', 'cliente_id': 'c1', 'tipo_variable': 'TipoVehiculo', 'nombre': 'Montacargas', 'created_at': '2026-01-01T00:00:00Z'},
        {'id': 'v2', 'cliente_id': 'c1', 'tipo_variable': 'MarcaLlata', 'nombre': 'Taurex', 'created_at': '2026-01-01T00:00:00Z'},
      ],
      'vehiculos': [
        {'id': 'veh1', 'codigo_vehiculo': '101', 'cliente_id': 'c1', 'tipo_id': 'v1', 'marca_id': 'v1', 'no_llantas': 4, 'created_at': '2026-01-01T00:00:00Z', 'updated_at': '2026-01-01T00:00:00Z'},
      ],
      'inspecciones': [
        {'id': 'i1', 'cliente_id': 'c1', 'nombre': 'Inspección inicial', 'fecha_revision': '2026-03-27', 'estado': 'FINALIZADO', 'created_at': '2026-03-27T10:00:00Z', 'updated_at': '2026-03-27T10:00:00Z'},
      ],
      'inspeccion_vehiculos': [
        {'id': 'iv1', 'inspeccion_id': 'i1', 'vehiculo_id': 'veh1', 'horometro': 4120, 'kilometraje': null, 'created_at': '2026-03-27T10:00:00Z'},
      ],
      'inspeccion_llantas': [
        {
          'id': 'll1', 'inspeccion_id': 'i1', 'vehiculo_id': 'veh1', 'codigo_llanta': 'A-500',
          'fecha_montaje': '2024-03-14', 'horometro_montaje': 3512, 'kilometraje_montaje': null,
          'tipo_llanta_id': null, 'marca_llanta_id': 'v2', 'dimension_llanta_id': null, 'diseno_llanta_id': null,
          'posicion': 1, 'presion': 25, 'medida_int': 28.0, 'medida_cent': null, 'medida_ext': 33,
          'observacion': 'REGRABADO', 'created_at': '2026-03-27T10:00:00Z', 'updated_at': '2026-03-27T10:00:00Z',
        },
      ],
    };
