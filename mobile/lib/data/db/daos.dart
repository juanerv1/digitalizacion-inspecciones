import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:drift/drift.dart';

part 'daos.g.dart';

// --------------------------------------------------------------
// CLIENTES
// --------------------------------------------------------------

// 1. DAO para Variables
@DriftAccessor(tables: [Clientes, Vehiculos, Inspecciones])
class ClienteDao extends DatabaseAccessor<AppDatabase> with _$ClienteDaoMixin {
  ClienteDao(super.db);

  Future<void> upsert(ClientesCompanion entity) {
    return into(clientes).insertOnConflictUpdate(entity);
  }

  static const _queryEstadisticas = '''
    SELECT 
      c.id, 
      c.nombre,
      (SELECT COUNT(*) FROM vehiculos v WHERE v.cliente_id = c.id) AS cantidad_vehiculos,
      (SELECT COUNT(*) FROM inspecciones i WHERE i.cliente_id = c.id) AS cantidad_inspecciones,
      (SELECT MAX(fecha_revision) FROM inspecciones i2 WHERE i2.cliente_id = c.id) AS ultima_inspeccion
    FROM clientes c
    ORDER BY c.nombre ASC;
  ''';

  /// Retorna un Future con la lista estática (útil para un FutureBuilder simple)
  Stream<List<ClienteResumen>> watchClientesConEstadisticas() {
    return customSelect(
      _queryEstadisticas,
      readsFrom: {clientes, vehiculos, inspecciones},
    ).map((row) {
      return ClienteResumen(
        id: row.read<String>('id'),
        nombre: row.read<String>('nombre'),
        cantidadVehiculos: row.read<int>('cantidad_vehiculos'),
        cantidadInspecciones: row.read<int>('cantidad_inspecciones'),
        ultimaInspeccion: row.read<DateTime?>('ultima_inspeccion'),
      );
    }).watch();
  }
}

// 1. DAO para Variables
@DriftAccessor(tables: [ClienteVariables])
class ClienteVariablesDao extends DatabaseAccessor<AppDatabase> with _$ClienteVariablesDaoMixin {
  ClienteVariablesDao(super.db);

  Future<void> upsert(ClienteVariablesCompanion entity) {
    return into(clienteVariables).insertOnConflictUpdate(entity);
  }

  Future<List<String>> verificarNuevasVariables({
    required String clienteId,
    String? nombreTipoVehiculo,
    String? nombreMarcaVehiculo,
    String? nombreTipoLlanta,
    String? nombreMarcaLlanta,
    String? nombreDimensionLlanta,
    String? nombreDisenoLlanta,
  }) async {
    List<String> variablesNuevas = [];

    // Función auxiliar interna para no repetir código
    Future<void> revisar(String? nombre, TipoVariableEnum tipo, String etiqueta) async {
      if (nombre != null && nombre.trim().isNotEmpty) {
        final nombreLimpio = nombre.trim();
        final existe = await (select(clienteVariables)
              ..where((t) => t.clienteId.equals(clienteId))
              ..where((t) => t.tipoVariable.equals(tipo.name)) 
              ..where((t) => t.nombre.lower().equals(nombreLimpio.toLowerCase()))
              ..limit(1))
            .getSingleOrNull();

        if (existe == null) {
          // Agregamos la etiqueta y el nombre para que el mensaje en la UI sea claro
          variablesNuevas.add('$etiqueta: "${nombre.toUpperCase()}"');
        }
      }
    }

    // Revisiones de Vehículo
    await revisar(nombreTipoVehiculo, TipoVariableEnum.TipoVehiculo, 'Tipo de Vehículo');
    await revisar(nombreMarcaVehiculo, TipoVariableEnum.MarcaVehiculo, 'Marca de Vehículo');

    // Revisiones de Llanta
    await revisar(nombreTipoLlanta, TipoVariableEnum.TipoLlanta, 'Tipo de Llanta');
    await revisar(nombreMarcaLlanta, TipoVariableEnum.MarcaLlata, 'Marca de Llanta'); 
    await revisar(nombreDimensionLlanta, TipoVariableEnum.DimensionLlanta, 'Dimensión de Llanta');
    await revisar(nombreDisenoLlanta, TipoVariableEnum.DisenoLlanta, 'Diseño de Llanta');

    return variablesNuevas;
  }

  /// Busca si existe una coincidencia, y si no, la crea.
  Future<String> obtenerOCrearVariable({
    required String clienteId,
    required TipoVariableEnum tipoEnum,
    String? idProporcionado,
    String? nombreProporcionado,
  }) async {
    // Escenario 1: Nos enviaron el ID
    if (idProporcionado != null && idProporcionado.isNotEmpty) {
      return idProporcionado;
    }

    if (nombreProporcionado == null || nombreProporcionado.trim().isEmpty) {
      throw ArgumentError('Debe proporcionar un ID o un Nombre para la variable.');
    }

    final nombreLimpio = nombreProporcionado.trim();

    // Escenario 2: Buscar si ya existe (ignorando mayúsculas)
final variableExistente = await (select(clienteVariables)
          ..where((t) => t.clienteId.equals(clienteId))
          ..where((t) => t.tipoVariable.equals(tipoEnum.name)) 
          ..where((t) => t.nombre.lower().equals(nombreLimpio.toLowerCase()))
          ..limit(1)) // <--- ¡AQUÍ TAMBIÉN ERA CRÍTICO!
        .getSingleOrNull();

    if (variableExistente != null) {
      return variableExistente.id;
    }

    // Escenario 3: No existe, la creamos
    final nuevaVariable = ClienteVariablesCompanion.insert(
      clienteId: clienteId,
      tipoVariable: tipoEnum,
      nombre: nombreLimpio.toUpperCase(), 
      creadaLocal: const Value(true),
      pendienteSync: const Value(true),
    );

    final variableInsertada = await into(clienteVariables).insertReturning(nuevaVariable);
    return variableInsertada.id;
  }

  /// Obtiene una lista de variables de un cliente mapeada a ClienteVariableEntity
  Future<List<ClienteVariableEntity>> getVariablesPorClienteYTipo(
    String clienteId, 
    TipoVariableEnum tipoVariable,
  ) async {
    final resultadosDb = await (select(clienteVariables)
          ..where((tbl) => 
              tbl.clienteId.equals(clienteId) & 
              // Usamos .name para obtener "TipoVehiculo" en lugar de "TipoVariableEnum.TipoVehiculo"
              tbl.tipoVariable.equals(tipoVariable.name) 
          )
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.nombre, mode: OrderingMode.asc)
          ])
        ).get();

    return resultadosDb.map((fila) {
      return ClienteVariableEntity(
        id: fila.id,
        clienteId: fila.clienteId,
        tipoVariable: fila.tipoVariable, 
        nombre: fila.nombre,
      );
    }).toList();
  }

  Future<List<ClienteVariable>> obtenerPendientesSync() {
    return (select(clienteVariables)
          ..where((t) => t.pendienteSync.equals(true)))
        .get();
  }

  // 2. Marcar una lista específica de IDs como sincronizados (pendienteSync = false)
  Future<void> marcarComoSincronizados(List<String> ids) async {
    // Si la lista está vacía, no hacemos nada para evitar errores en SQL
    if (ids.isEmpty) return; 

    await (update(clienteVariables)
          ..where((t) => t.id.isIn(ids))) // Filtramos solo por los IDs que ya se enviaron
        .write(
      const ClienteVariablesCompanion(
        pendienteSync: Value(false),
      ),
    );
  }
}

// --------------------------------------------------------------
// VEHICULOS
// --------------------------------------------------------------

// 2. DAO para Vehículos
@DriftAccessor(tables: [Vehiculos, ClienteVariables, InspeccionVehiculos, InspeccionLlantas])
class VehiculosDao extends DatabaseAccessor<AppDatabase> with _$VehiculosDaoMixin {
  VehiculosDao(super.db);

  Future<void> upsert(VehiculosCompanion entity) {
    return into(vehiculos).insertOnConflictUpdate(entity);
  }

  Stream<List<VehiculoInspeccionResumen>> getVehiculosParaInspeccion({
    required String clienteId,
    required String inspeccionId,
  }) {
    const query = '''
      SELECT 
        v.id AS vehiculo_id,
        v.codigo_vehiculo,
        v.cliente_id,
        v.tipo_id,
        cv_tipo.nombre AS nombre_tipo,
        v.marca_id,
        cv_marca.nombre AS nombre_marca,
        v.no_llantas,
        iv.id AS inspeccion_vehiculo_id,
        iv.horometro,
        iv.kilometraje,
        IFNULL(il.cantidad_llantas, 0) AS cantidad_llantas_inspeccionadas
      FROM vehiculos v
      LEFT JOIN cliente_variables cv_tipo ON v.tipo_id = cv_tipo.id
      LEFT JOIN cliente_variables cv_marca ON v.marca_id = cv_marca.id
      -- LEFT JOIN clave: Solo trae los datos de inspección si coinciden con el ID actual
      LEFT JOIN inspeccion_vehiculos iv ON iv.vehiculo_id = v.id AND iv.inspeccion_id = ?
      -- Subquery para contar llantas de este vehículo en esta inspección específica
      LEFT JOIN (
        SELECT vehiculo_id, COUNT(*) as cantidad_llantas 
        FROM inspeccion_llantas 
        WHERE inspeccion_id = ? 
        GROUP BY vehiculo_id
      ) il ON il.vehiculo_id = v.id
      WHERE v.cliente_id = ?
      ORDER BY v.codigo_vehiculo ASC;
    ''';

    return customSelect(
      query,
      variables: [
        Variable.withString(inspeccionId), 
        Variable.withString(inspeccionId), 
        Variable.withString(clienteId)
      ],
      readsFrom: {vehiculos, clienteVariables, inspeccionVehiculos, inspeccionLlantas},
    ).map(_mapRowToResumen).watch();
  }

  /// DAO 2: Para la pantalla de "Historial de Inspección".
  /// Trae SOLO los vehículos que fueron inspeccionados en la inspección dada.
  Future<List<VehiculoInspeccionResumen>> getVehiculosInspeccionados(String inspeccionId) {
    const query = '''
      SELECT 
        v.id AS vehiculo_id,
        v.codigo_vehiculo,
        v.cliente_id,
        v.tipo_id,
        cv_tipo.nombre AS nombre_tipo,
        v.marca_id,
        cv_marca.nombre AS nombre_marca,
        v.no_llantas,
        iv.id AS inspeccion_vehiculo_id,
        iv.inspeccion_id,
        iv.horometro,
        iv.kilometraje,
        IFNULL(il.cantidad_llantas, 0) AS cantidad_llantas_inspeccionadas
      FROM inspeccion_vehiculos iv
      -- INNER JOIN: Obliga a que solo salgan vehículos que estén en inspeccion_vehiculos
      INNER JOIN vehiculos v ON v.id = iv.vehiculo_id
      LEFT JOIN cliente_variables cv_tipo ON v.tipo_id = cv_tipo.id
      LEFT JOIN cliente_variables cv_marca ON v.marca_id = cv_marca.id
      LEFT JOIN (
        SELECT vehiculo_id, COUNT(*) as cantidad_llantas 
        FROM inspeccion_llantas 
        WHERE inspeccion_id = ? 
        GROUP BY vehiculo_id
      ) il ON il.vehiculo_id = v.id
      WHERE iv.inspeccion_id = ?
      ORDER BY v.codigo_vehiculo ASC;
    ''';

    return customSelect(
      query,
      variables: [
        Variable.withString(inspeccionId), 
        Variable.withString(inspeccionId)
      ],
      readsFrom: {vehiculos, clienteVariables, inspeccionVehiculos, inspeccionLlantas},
    ).map(_mapRowToResumen).get();
  }

  Stream<VehiculoInspeccionResumen?> watchVehiculoInspeccionResumen({
    required String vehiculoId,
    required String inspeccionId,
  }) {
    const query = '''
      SELECT 
        v.id AS vehiculo_id,
        v.codigo_vehiculo,
        v.cliente_id,
        v.tipo_id,
        cv_tipo.nombre AS nombre_tipo,
        v.marca_id,
        cv_marca.nombre AS nombre_marca,
        v.no_llantas,
        iv.id AS inspeccion_vehiculo_id,
        iv.horometro,
        iv.kilometraje,
        IFNULL(il.cantidad_llantas, 0) AS cantidad_llantas_inspeccionadas
      FROM vehiculos v
      LEFT JOIN cliente_variables cv_tipo ON v.tipo_id = cv_tipo.id
      LEFT JOIN cliente_variables cv_marca ON v.marca_id = cv_marca.id
      -- Traemos los datos de inspección si coinciden con el ID actual
      LEFT JOIN inspeccion_vehiculos iv ON iv.vehiculo_id = v.id AND iv.inspeccion_id = ?
      -- Subquery para contar llantas de este vehículo en esta inspección específica
      LEFT JOIN (
        SELECT vehiculo_id, COUNT(*) as cantidad_llantas 
        FROM inspeccion_llantas 
        WHERE inspeccion_id = ? 
        GROUP BY vehiculo_id
      ) il ON il.vehiculo_id = v.id
      WHERE v.id = ? -- Filtramos directamente por el ID del vehículo
    ''';

    return customSelect(
      query,
      variables: [
        Variable.withString(inspeccionId), // Para el primer JOIN
        Variable.withString(inspeccionId), // Para la subquery
        Variable.withString(vehiculoId)    // Para el WHERE
      ],
      readsFrom: {vehiculos, clienteVariables, inspeccionVehiculos, inspeccionLlantas},
    ).map(_mapRowToResumen).watchSingleOrNull();
  }

// Función privada para no repetir el mapeo en ambos DAOs
  VehiculoInspeccionResumen _mapRowToResumen(QueryRow row) {
    return VehiculoInspeccionResumen(
      vehiculoId: row.read<String>('vehiculo_id'),
      // Cambiamos a String? por si el vehículo aún no tiene inspección (LEFT JOIN)
      inspeccionId: row.read<String?>('inspeccion_id'), 
      codigoVehiculo: row.read<String>('codigo_vehiculo'),
      clienteId: row.read<String>('cliente_id'),
      tipoId: row.read<String>('tipo_id'),
      nombreTipo: row.read<String?>('nombre_tipo'),
      marcaId: row.read<String>('marca_id'),
      nombreMarca: row.read<String?>('nombre_marca'),
      noLlantas: row.read<int>('no_llantas'),
      inspeccionVehiculoId: row.read<String?>('inspeccion_vehiculo_id'),
      horometro: row.read<double?>('horometro'),
      kilometraje: row.read<double?>('kilometraje'),
      cantidadLlantasInspeccionadas: row.read<int>('cantidad_llantas_inspeccionadas'),
    );
  }

  Future<String> crearVehiculoLocal({
    required String codigoVehiculo,
    required String clienteId,
    required int noLlantas,
    String? tipoId,
    String? nombreTipo,
    String? marcaId,
    String? nombreMarca,
  }) async {
    return transaction(() async {
      
      // 1. Resolver el ID del Tipo usando el DAO de variables
      final resolvedTipoId = await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: clienteId,
        tipoEnum: TipoVariableEnum.TipoVehiculo,
        idProporcionado: tipoId,
        nombreProporcionado: nombreTipo,
      );

      // 2. Resolver el ID de la Marca usando el DAO de variables
      final resolvedMarcaId = await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: clienteId,
        tipoEnum: TipoVariableEnum.MarcaVehiculo,
        idProporcionado: marcaId,
        nombreProporcionado: nombreMarca,
      );

      // 3. Crear el Vehículo
      final vehiculoCompanion = VehiculosCompanion.insert(
        codigoVehiculo: codigoVehiculo,
        clienteId: clienteId,
        tipoId: resolvedTipoId,
        marcaId: resolvedMarcaId,
        noLlantas: noLlantas,
        creadaLocal: const Value(true),   
        pendienteSync: const Value(true), 
      );

      final vehiculoInsertado = await into(vehiculos).insertReturning(vehiculoCompanion);
      return vehiculoInsertado.id;
    });
  }

  Future<List<Vehiculo>> obtenerPendientesSync() {
    return (select(vehiculos)
          ..where((t) => t.pendienteSync.equals(true)))
        .get();
  }

  // 2. Marcar una lista específica de IDs como sincronizados (pendienteSync = false)
  Future<void> marcarComoSincronizados(List<String> ids) async {
    // Si la lista está vacía, no hacemos nada para evitar errores en SQL
    if (ids.isEmpty) return; 

    await (update(vehiculos)
          ..where((t) => t.id.isIn(ids))) // Filtramos solo por los IDs que ya se enviaron
        .write(
      const VehiculosCompanion(
        pendienteSync: Value(false),
      ),
    );
  }
}

// --------------------------------------------------------------
// INSPECCIONES
// --------------------------------------------------------------

// 3. DAO para Inspecciones
@DriftAccessor(tables: [Inspecciones, InspeccionVehiculos, InspeccionLlantas])
class InspeccionesDao extends DatabaseAccessor<AppDatabase> with _$InspeccionesDaoMixin {
  InspeccionesDao(super.db);

  Future<void> upsert(InspeccionesCompanion entity) {
    return into(inspecciones).insertOnConflictUpdate(entity);
  }

  Future<String> crearNuevaInspeccion({
    required String clienteId,
    required String nombre,
    required DateTime fechaInspeccion,
  }) async {

    final nuevaInspeccion = InspeccionesCompanion.insert(
      clienteId: clienteId,
      nombre: Value(nombre),
      fechaRevision: fechaInspeccion,
      estado: const Value('PENDIENTE'), // Forzamos el estado inicial
      creadaLocal: const Value(true),    // Marcamos que se creó en el dispositivo
      pendienteSync: const Value(true), // Marcamos que debe subirse al servidor
    );

    final inspeccionInsertada = await into(inspecciones).insertReturning(nuevaInspeccion);    
    return inspeccionInsertada.id;
  }
  
  Stream<List<InspeccionResumen>> getInspeccionesPorCliente(String clienteId) {
    const query = '''
      SELECT 
        i.id, 
        i.cliente_id, 
        i.nombre, 
        i.fecha_revision,
        (SELECT COUNT(*) FROM inspeccion_vehiculos iv WHERE iv.inspeccion_id = i.id) AS cantidad_vehiculos,
        (SELECT COUNT(*) FROM inspeccion_llantas il WHERE il.inspeccion_id = i.id) AS cantidad_llantas,
        i.estado
      FROM inspecciones i
      WHERE i.cliente_id = ?
      ORDER BY i.fecha_revision DESC, i.created_at DESC;
    ''';

    return customSelect(
      query,
      variables: [Variable.withString(clienteId)], // Pasamos el UUID del cliente de forma segura
      readsFrom: {inspecciones, inspeccionVehiculos, inspeccionLlantas}, // Tablas a observar
    ).map((row) {
      return InspeccionResumen(
        id: row.read<String>('id'),
        clienteId: row.read<String>('cliente_id'),
        nombre: row.read<String?>('nombre'), // Es nullable en la tabla
        fechaRevision: row.read<DateTime>('fecha_revision'),
        cantidadVehiculos: row.read<int>('cantidad_vehiculos'),
        cantidadLlantas: row.read<int>('cantidad_llantas'),
        estado: row.read<String>('estado')
      );
    }).watch();
  }

  Stream<List<InspeccionResumen>> watchInspeccionesNoFinalizadas() {
    const query = '''
      SELECT 
        i.id, 
        i.cliente_id, 
        c.nombre AS cliente_nombre,
        i.nombre, 
        i.fecha_revision,
        i.estado,
        (SELECT COUNT(*) FROM inspeccion_vehiculos iv WHERE iv.inspeccion_id = i.id) AS cantidad_vehiculos,
        (SELECT COUNT(*) FROM inspeccion_llantas il WHERE il.inspeccion_id = i.id) AS cantidad_llantas
      FROM inspecciones i
      INNER JOIN clientes c ON i.cliente_id = c.id
      WHERE i.estado != 'FINALIZADO'
      ORDER BY i.fecha_revision DESC, i.created_at DESC;
    ''';

    return customSelect(
      query,
      readsFrom: {inspecciones, inspeccionVehiculos, inspeccionLlantas, clientes}, 
    ).map((row) {
      return InspeccionResumen(
        id: row.read<String>('id'),
        clienteId: row.read<String>('cliente_id'),
        clienteNombre: row.read<String?>('cliente_nombre'),
        nombre: row.read<String?>('nombre'), 
        fechaRevision: row.read<DateTime>('fecha_revision'),
        cantidadVehiculos: row.read<int>('cantidad_vehiculos'),
        cantidadLlantas: row.read<int>('cantidad_llantas'),
        estado: row.read<String>('estado')
      );
    }).watch(); 
  }

  Stream<InspeccionResumen?> watchInspeccionPorId({required String inspeccionId}) {
    const query = '''
      SELECT 
        i.id, 
        i.cliente_id, 
        i.nombre, 
        i.fecha_revision,
        i.estado,
        (SELECT COUNT(*) FROM inspeccion_vehiculos iv WHERE iv.inspeccion_id = i.id) AS cantidad_vehiculos,
        (SELECT COUNT(*) FROM inspeccion_llantas il WHERE il.inspeccion_id = i.id) AS cantidad_llantas
      FROM inspecciones i
      WHERE i.id = ? -- Buscamos exactamente el ID proporcionado
    ''';

    return customSelect(
      query,
      // Pasamos el ID a la consulta de forma segura
      variables: [Variable.withString(inspeccionId)], 
      readsFrom: {inspecciones, inspeccionVehiculos, inspeccionLlantas}, 
    ).map((row) {
      return InspeccionResumen(
        id: row.read<String>('id'),
        clienteId: row.read<String>('cliente_id'),
        nombre: row.read<String>('nombre'), // Es nullable en la tabla
        fechaRevision: row.read<DateTime>('fecha_revision'),
        cantidadVehiculos: row.read<int>('cantidad_vehiculos'),
        cantidadLlantas: row.read<int>('cantidad_llantas'),
        estado: row.read<String>('estado')
      );
    }).watchSingleOrNull(); // <--- EL CAMBIO: devuelve un solo objeto o null como Stream
  }

Future<String?> getInspeccionIdPorIndice({
    required String clienteId,
    required int index,
  }) async {
    // Validamos que no nos pasen un índice negativo
    if (index < 0) {
      throw ArgumentError('El índice no puede ser negativo.');
    }

    final query = select(inspecciones)
      // 1. Filtramos por cliente
      ..where((t) => t.clienteId.equals(clienteId))
      // 2. Ordenamos por fecha de revisión y luego por fecha de creación
      ..orderBy([
        (t) => OrderingTerm(expression: t.fechaRevision, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc), // <--- NUEVO: Segundo criterio
      ])
      // 3. Magia aquí: LIMIT 1 (trae un solo registro) y OFFSET (salta la cantidad del índice)
      ..limit(1, offset: index);

    // Obtenemos el registro (si existe) y retornamos solo su ID
    final inspeccion = await query.getSingleOrNull();
    return inspeccion?.id;
  }

  Future<void> finalizarInspeccion(String inspeccionId) async {
    // Usamos una transacción para asegurar que todo se haga o nada se haga
    await transaction(() async {
      
      // 1. Buscamos todos los vehículos únicos que tienen llantas registradas en esta inspección
      // Usamos selectOnly para traer solo la columna vehiculoId de forma única (DISTINCT)
      final queryLlantas = selectOnly(inspeccionLlantas, distinct: true)
        ..addColumns([inspeccionLlantas.vehiculoId])
        ..where(inspeccionLlantas.inspeccionId.equals(inspeccionId));

      final registrosLlantas = await queryLlantas.get();
      final vehiculosConLlantas = registrosLlantas.map((row) => row.read(inspeccionLlantas.vehiculoId)!).toList();

      // 2. Por cada vehículo encontrado, verificamos si ya existe en inspeccion_vehiculos
      for (final vId in vehiculosConLlantas) {
        final existe = await (select(inspeccionVehiculos)
              ..where((iv) => iv.inspeccionId.equals(inspeccionId) & iv.vehiculoId.equals(vId)))
            .getSingleOrNull();

        // 3. Si no existe el registro de vehículo, lo creamos con valores nulos
        if (existe == null) {
          await into(inspeccionVehiculos).insert(
            InspeccionVehiculosCompanion.insert(
              inspeccionId: inspeccionId,
              vehiculoId: vId,
              horometro: const Value(null),
              kilometraje: const Value(null),
              pendienteSync: const Value(true), 
            ),
          );
        }
      }

      // 4. Finalmente, actualizamos el estado de la inspección a FINALIZADO
      await (update(inspecciones)..where((t) => t.id.equals(inspeccionId))).write(
        InspeccionesCompanion(
          estado: const Value('FINALIZADO'),
          updatedAt: Value(DateTime.now()),
          pendienteSync: const Value(true),
        ),
      );
    });
  }

  // =========================================================
  // 2. FUNCIÓN PARA ELIMINAR EN CASCADA (Transacción)
  // =========================================================
  Future<void> eliminarInspeccionEnCascada(String inspeccionId) {
    // Usamos transaction() para que, si algo falla a la mitad, 
    // se reviertan los cambios y no queden datos corruptos.
    return transaction(() async {
      
      // 1. Primero eliminamos los "hijos" (Llantas)
      await (delete(inspeccionLlantas)
        ..where((t) => t.inspeccionId.equals(inspeccionId))).go();

      // 2. Luego eliminamos los otros "hijos" (Vehículo de la inspección)
      await (delete(inspeccionVehiculos)
        ..where((t) => t.inspeccionId.equals(inspeccionId))).go();

      // 3. Finalmente, eliminamos al "padre" (La inspección en sí)
      await (delete(inspecciones)
        ..where((t) => t.id.equals(inspeccionId))).go();
        
    });
  }

    Future<List<Inspeccion>> obtenerPendientesSync() {
    return (select(inspecciones)
          ..where((t) => t.pendienteSync.equals(true)))
        .get();
  }

  // 2. Marcar una lista específica de IDs como sincronizados (pendienteSync = false)
  Future<void> marcarComoSincronizados(List<String> ids) async {
    // Si la lista está vacía, no hacemos nada para evitar errores en SQL
    if (ids.isEmpty) return; 

    await (update(inspecciones)
          ..where((t) => t.id.isIn(ids))) // Filtramos solo por los IDs que ya se enviaron
        .write(
      const InspeccionesCompanion(
        pendienteSync: Value(false),
      ),
    );
  }
}

// --------------------------------------------------------------
// INSPECCIONES DE VEHICULO
// --------------------------------------------------------------

// 4. DAO para InspeccionVehiculos
@DriftAccessor(tables: [InspeccionVehiculos])
class InspeccionVehiculosDao extends DatabaseAccessor<AppDatabase> with _$InspeccionVehiculosDaoMixin {
  InspeccionVehiculosDao(super.db);

  Future<void> upsert(InspeccionVehiculosCompanion entity) {
    return into(inspeccionVehiculos).insertOnConflictUpdate(entity);
  }

  Stream<InspeccionVehiculo?> watchInspeccionVehiculo({
    required String inspeccionId,
    required String vehiculoId,
  }) {
    return (select(inspeccionVehiculos)
          ..where((t) => t.inspeccionId.equals(inspeccionId))
          ..where((t) => t.vehiculoId.equals(vehiculoId)))
        .watchSingleOrNull();
  }

  /// DAO con Future: Obtiene los datos de la inspección una sola vez.
  /// Ideal para cargar datos iniciales en un formulario de edición o vista de historial.
  Future<InspeccionVehiculo?> getInspeccionVehiculo({
    required String inspeccionId,
    required String vehiculoId,
  }) {
    return (select(inspeccionVehiculos)
          ..where((t) => t.inspeccionId.equals(inspeccionId))
          ..where((t) => t.vehiculoId.equals(vehiculoId))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<String> guardarInspeccionVehiculo({
    String? inspeccionVehiculoIdExistente, // Lo mantenemos por compatibilidad, pero la BD manda
    required String inspeccionId,
    required String vehiculoId,
    double? horometro,
    double? kilometraje,
  }) async {

    return transaction(() async {
      // --- NUEVO: Prevención de Error de Unicidad ---
      // Buscamos directamente en la BD si ya existe el registro para este vehículo en esta inspección
      final registroExistente = await (select(inspeccionVehiculos)
            ..where((t) => t.inspeccionId.equals(inspeccionId))
            ..where((t) => t.vehiculoId.equals(vehiculoId)))
          .getSingleOrNull();

      // Preparamos el Companion con los datos base
      final vehiculoCompanion = InspeccionVehiculosCompanion(
        inspeccionId: Value(inspeccionId),
        vehiculoId: Value(vehiculoId),
        horometro: Value(horometro),
        kilometraje: Value(kilometraje),
        pendienteSync: const Value(true), 
      );

      // Ejecutar Insert o Update basados en la VERDAD de la base de datos
      if (registroExistente != null) {
        // ACTUALIZAR REGISTRO EXISTENTE
        await (update(inspeccionVehiculos)
              ..where((t) => t.id.equals(registroExistente.id)))
            .write(vehiculoCompanion);
            
        return registroExistente.id;
        
      } else {
        // INSERTAR NUEVO REGISTRO
        final insertCompanion = vehiculoCompanion.copyWith(
          creadaLocal: const Value(true),
        );
        
        final registroInsertado = await into(inspeccionVehiculos).insertReturning(insertCompanion);
        return registroInsertado.id;
      }
    });
  }

  Future<List<InspeccionVehiculo>> obtenerPendientesSync() {
    return (select(inspeccionVehiculos)
          ..where((t) => t.pendienteSync.equals(true)))
        .get();
  }

  // 2. Marcar una lista específica de IDs como sincronizados (pendienteSync = false)
  Future<void> marcarComoSincronizados(List<String> ids) async {
    // Si la lista está vacía, no hacemos nada para evitar errores en SQL
    if (ids.isEmpty) return; 

    await (update(inspeccionVehiculos)
          ..where((t) => t.id.isIn(ids))) // Filtramos solo por los IDs que ya se enviaron
        .write(
      const InspeccionVehiculosCompanion(
        pendienteSync: Value(false),
      ),
    );
  }
}


// --------------------------------------------------------------
// INSPECCIONES DE LLANTA
// --------------------------------------------------------------

// 5. DAO para InspeccionLlantas
@DriftAccessor(tables: [InspeccionLlantas])
class InspeccionLlantasDao extends DatabaseAccessor<AppDatabase> with _$InspeccionLlantasDaoMixin {
  InspeccionLlantasDao(super.db);

  Future<void> upsert(InspeccionLlantasCompanion entity) {
    return into(inspeccionLlantas).insertOnConflictUpdate(entity);
  }

  Stream<List<LlantaInspeccionResumen>> watchLlantasDeVehiculoEnInspeccion({
    required String inspeccionId,
    required String vehiculoId,
  }) {
    const query = '''
      SELECT 
        il.id,
        il.inspeccion_id,
        il.vehiculo_id,
        il.fecha_montaje,
        il.horo_montaje,
        il.km_montaje,
        il.posicion,
        il.codigo_llanta,
        il.presion,
        il.medida_int,
        il.medida_cent,
        il.medida_ext,
        il.observacion,
        
        il.tipo_llanta_id,
        cv_tipo.nombre AS nombre_tipo,
        
        il.marca_llanta_id,
        cv_marca.nombre AS nombre_marca,
        
        il.dimension_llanta_id,
        cv_dim.nombre AS nombre_dimension,
        
        il.diseno_llanta_id,
        cv_diseno.nombre AS nombre_diseno
        
      FROM inspeccion_llantas il
      LEFT JOIN cliente_variables cv_tipo ON il.tipo_llanta_id = cv_tipo.id
      LEFT JOIN cliente_variables cv_marca ON il.marca_llanta_id = cv_marca.id
      LEFT JOIN cliente_variables cv_dim ON il.dimension_llanta_id = cv_dim.id
      LEFT JOIN cliente_variables cv_diseno ON il.diseno_llanta_id = cv_diseno.id
      WHERE il.inspeccion_id = ? AND il.vehiculo_id = ?
      ORDER BY il.posicion ASC;
    ''';

    return customSelect(
      query,
      variables: [
        Variable.withString(inspeccionId),
        Variable.withString(vehiculoId)
      ],
      // Drift vigilará estas tablas y emitirá un nuevo valor si algo cambia
      readsFrom: {inspeccionLlantas, clienteVariables},
    ).map((row) {
      return LlantaInspeccionResumen(
        id: row.read<String>('id'),
        inspeccionId: row.read<String>('inspeccion_id'),
        vehiculoId: row.read<String>('vehiculo_id'),
        posicion: row.read<int>('posicion'),
        codigoLlanta: row.read<String>('codigo_llanta'),
        fechaMontaje: row.read<DateTime?>('fecha_montaje'),
        horoMontaje: row.read<double?>('horo_montaje'),
        kmMontaje: row.read<double?>('km_montaje'),
        presion: row.read<double?>('presion'),
        medidaInt: row.read<double?>('medida_int'),
        medidaCent: row.read<double?>('medida_cent'),
        medidaExt: row.read<double?>('medida_ext'),
        observacion: row.read<String?>('observacion'),
        
        tipoLlantaId: row.read<String?>('tipo_llanta_id'),
        nombreTipo: row.read<String?>('nombre_tipo'),
        
        marcaLlantaId: row.read<String?>('marca_llanta_id'),
        nombreMarca: row.read<String?>('nombre_marca'),
        
        dimensionLlantaId: row.read<String?>('dimension_llanta_id'),
        nombreDimension: row.read<String?>('nombre_dimension'),
        
        disenoLlantaId: row.read<String?>('diseno_llanta_id'),
        nombreDiseno: row.read<String?>('nombre_diseno'),
      );
    }).watch(); // <-- .watch() es lo que lo convierte en un Stream reactivo
  }

  Future<List<LlantaInspeccionResumen>> getLlantasDeVehiculoEnInspeccion({
    required String inspeccionId,
    required String vehiculoId,
  }) {
    const query = '''
      SELECT 
        il.id,
        il.inspeccion_id,
        il.vehiculo_id,
        il.posicion,
        il.codigo_llanta,
        il.fecha_montaje,
        il.horo_montaje,
        il.km_montaje,
        il.presion,
        il.medida_int,
        il.medida_cent,
        il.medida_ext,
        il.observacion,
        
        il.tipo_llanta_id,
        cv_tipo.nombre AS nombre_tipo,
        
        il.marca_llanta_id,
        cv_marca.nombre AS nombre_marca,
        
        il.dimension_llanta_id,
        cv_dim.nombre AS nombre_dimension,
        
        il.diseno_llanta_id,
        cv_diseno.nombre AS nombre_diseno
        
      FROM inspeccion_llantas il
      LEFT JOIN cliente_variables cv_tipo ON il.tipo_llanta_id = cv_tipo.id
      LEFT JOIN cliente_variables cv_marca ON il.marca_llanta_id = cv_marca.id
      LEFT JOIN cliente_variables cv_dim ON il.dimension_llanta_id = cv_dim.id
      LEFT JOIN cliente_variables cv_diseno ON il.diseno_llanta_id = cv_diseno.id
      WHERE il.inspeccion_id = ? AND il.vehiculo_id = ?
      ORDER BY il.posicion ASC;
    ''';

    return customSelect(
      query,
      variables: [
        Variable.withString(inspeccionId),
        Variable.withString(vehiculoId)
      ],
      // readsFrom sigue siendo buena práctica por si llegara a cruzarse una sincro de fondo
      readsFrom: {inspeccionLlantas, clienteVariables}, 
    ).map((row) {
      return LlantaInspeccionResumen(
        id: row.read<String>('id'),
        inspeccionId: row.read<String>('inspeccion_id'),
        vehiculoId: row.read<String>('vehiculo_id'),
        posicion: row.read<int>('posicion'),
        codigoLlanta: row.read<String>('codigo_llanta'),
        fechaMontaje: row.read<DateTime?>('fecha_montaje'),
        horoMontaje: row.read<double?>('horo_montaje'),
        kmMontaje: row.read<double?>('km_montaje'),
        presion: row.read<double?>('presion'),
        medidaInt: row.read<double?>('medida_int'),
        medidaCent: row.read<double?>('medida_cent'),
        medidaExt: row.read<double?>('medida_ext'),
        observacion: row.read<String?>('observacion'),
        
        tipoLlantaId: row.read<String?>('tipo_llanta_id'),
        nombreTipo: row.read<String?>('nombre_tipo'),
        
        marcaLlantaId: row.read<String?>('marca_llanta_id'),
        nombreMarca: row.read<String?>('nombre_marca'),
        
        dimensionLlantaId: row.read<String?>('dimension_llanta_id'),
        nombreDimension: row.read<String?>('nombre_dimension'),
        
        disenoLlantaId: row.read<String?>('diseno_llanta_id'),
        nombreDiseno: row.read<String?>('nombre_diseno'),
      );
    }).get(); // <-- .get() es lo que ejecuta la consulta una sola vez
  }

  Future<List<LlantaInspeccionResumen>> getHistorialPrevioLlantasVehiculo({
    required String inspeccionActualId,
    required String vehiculoId,
  }) {
    const query = '''
      WITH Historial AS (
        SELECT 
          il.*,
          -- Agrupamos por posición y ordenamos por fecha (la más reciente primero)
          ROW_NUMBER() OVER(
            PARTITION BY il.posicion 
            ORDER BY i.fecha_revision DESC, il.created_at DESC
          ) as rn
        FROM inspeccion_llantas il
        -- Unimos con inspecciones para poder ordenar por la fecha real de la revisión
        INNER JOIN inspecciones i ON il.inspeccion_id = i.id
        WHERE il.vehiculo_id = ? AND il.inspeccion_id != ? 
      )
      SELECT 
        h.id,
        h.inspeccion_id,
        h.vehiculo_id,
        h.posicion,
        h.codigo_llanta,
        h.fecha_montaje,
        h.horo_montaje,
        h.km_montaje,
        h.presion,
        h.medida_int,
        h.medida_cent,
        h.medida_ext,
        h.observacion,
        
        h.tipo_llanta_id,
        cv_tipo.nombre AS nombre_tipo,
        
        h.marca_llanta_id,
        cv_marca.nombre AS nombre_marca,
        
        h.dimension_llanta_id,
        cv_dim.nombre AS nombre_dimension,
        
        h.diseno_llanta_id,
        cv_diseno.nombre AS nombre_diseno
        
      FROM Historial h
      LEFT JOIN cliente_variables cv_tipo ON h.tipo_llanta_id = cv_tipo.id
      LEFT JOIN cliente_variables cv_marca ON h.marca_llanta_id = cv_marca.id
      LEFT JOIN cliente_variables cv_dim ON h.dimension_llanta_id = cv_dim.id
      LEFT JOIN cliente_variables cv_diseno ON h.diseno_llanta_id = cv_diseno.id
      WHERE h.rn = 1 
      ORDER BY h.posicion ASC;
    ''';

    return customSelect(
      query,
      variables: [
        // ¡Ojo al orden! Primero vehiculoId y luego inspeccionActualId según los '?' en el WHERE
        Variable.withString(vehiculoId),
        Variable.withString(inspeccionActualId)
      ],
      // Añadimos 'inspecciones' a las tablas que se leen
      readsFrom: {inspeccionLlantas, inspecciones, clienteVariables}, 
    ).map((row) {
      return LlantaInspeccionResumen(
        id: row.read<String>('id'),
        inspeccionId: row.read<String>('inspeccion_id'),
        vehiculoId: row.read<String>('vehiculo_id'),
        posicion: row.read<int>('posicion'),
        codigoLlanta: row.read<String>('codigo_llanta'),
        fechaMontaje: row.read<DateTime?>('fecha_montaje'),
        horoMontaje: row.read<double?>('horo_montaje'),
        kmMontaje: row.read<double?>('km_montaje'),
        presion: row.read<double?>('presion'),
        medidaInt: row.read<double?>('medida_int'),
        medidaCent: row.read<double?>('medida_cent'),
        medidaExt: row.read<double?>('medida_ext'),
        observacion: row.read<String?>('observacion'),
        tipoLlantaId: row.read<String?>('tipo_llanta_id'),
        nombreTipo: row.read<String?>('nombre_tipo'),
        marcaLlantaId: row.read<String?>('marca_llanta_id'),
        nombreMarca: row.read<String?>('nombre_marca'),
        dimensionLlantaId: row.read<String?>('dimension_llanta_id'),
        nombreDimension: row.read<String?>('nombre_dimension'),
        disenoLlantaId: row.read<String?>('diseno_llanta_id'),
        nombreDiseno: row.read<String?>('nombre_diseno'),
      );
    }).get();
  }

  Future<String> guardarLlanta({
    required String clienteId, // Requerido para resolver variables
    required String inspeccionId,
    required String vehiculoId,
    required String codigoLlanta,
    required int posicion,
    DateTime? fechaMontaje,
    double? horoMontaje,
    double? kmMontaje,
    
    // IDs o Nombres de las variables
    String? tipoId, String? nombreTipo,
    String? marcaId, String? nombreMarca,
    String? dimensionId, String? nombreDimension,
    String? disenoId, String? nombreDiseno,
    
    // Medidas
    double? presion,
    double? medidaInt,
    double? medidaCent,
    double? medidaExt,
    String? observacion,
  }) async {
    return transaction(() async {
      
      // 1. Resolver todas las variables usando tu función inteligente compartida
      final resolvedTipoId = (nombreTipo != null || tipoId != null) ? await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: clienteId, tipoEnum: TipoVariableEnum.TipoLlanta, idProporcionado: tipoId, nombreProporcionado: nombreTipo) : null;
        
      final resolvedMarcaId = (nombreMarca != null || marcaId != null) ? await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: clienteId, tipoEnum: TipoVariableEnum.MarcaLlata, idProporcionado: marcaId, nombreProporcionado: nombreMarca) : null;

      final resolvedDimensionId = (nombreDimension != null || dimensionId != null) ? await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: clienteId, tipoEnum: TipoVariableEnum.DimensionLlanta, idProporcionado: dimensionId, nombreProporcionado: nombreDimension) : null;

      final resolvedDisenoId = (nombreDiseno != null || disenoId != null) ? await db.clienteVariablesDao.obtenerOCrearVariable(
        clienteId: clienteId, tipoEnum: TipoVariableEnum.DisenoLlanta, idProporcionado: disenoId, nombreProporcionado: nombreDiseno) : null;

      // 2. BUSQUEDA DE SEGURIDAD EN LA BD
      // Verificamos si ya existe una llanta registrada en esta misma posición para este vehículo en esta inspección.
      final llantaEnBd = await (select(inspeccionLlantas)
            ..where((t) => 
              t.inspeccionId.equals(inspeccionId) & 
              t.vehiculoId.equals(vehiculoId) & 
              t.posicion.equals(posicion))
            ..limit(1)) // <--- ¡AQUÍ ESTÁ LA MAGIA!
          .getSingleOrNull();

      // 3. Armar el Companion con los datos listos
      final llantaCompanion = InspeccionLlantasCompanion(
        inspeccionId: Value(inspeccionId),
        vehiculoId: Value(vehiculoId),
        codigoLlanta: Value(codigoLlanta),
        posicion: Value(posicion),
        fechaMontaje: Value(fechaMontaje),
        horoMontaje: Value(horoMontaje),
        kmMontaje: Value(kmMontaje),
        
        tipoLlantaId: Value(resolvedTipoId),
        marcaLlantaId: Value(resolvedMarcaId),
        dimensionLlantaId: Value(resolvedDimensionId),
        disenoLlantaId: Value(resolvedDisenoId),
        
        presion: Value(presion),
        medidaInt: Value(medidaInt),
        medidaCent: Value(medidaCent),
        medidaExt: Value(medidaExt),
        observacion: Value(observacion),
        
        // Forzamos actualización de fecha
        updatedAt: Value(DateTime.now()), 
        // Marcamos para sincronización
        pendienteSync: const Value(true), 
      );

      // 4. Ejecutar Insert o Update basado en la respuesta de la BD
      if (llantaEnBd != null) {
        // ACTUALIZAR (Ya existía el registro)
        await (update(inspeccionLlantas)
              ..where((t) => t.id.equals(llantaEnBd.id)))
            .write(llantaCompanion);
            
        return llantaEnBd.id;
      } else {
        // INSERTAR NUEVO (No existía previamente)
        final insertCompanion = llantaCompanion.copyWith(
          creadaLocal: const Value(true),
        );
        
        final llantaInsertada = await into(inspeccionLlantas).insertReturning(insertCompanion);
        return llantaInsertada.id;
      }
    });
  }

  Future<List<InspeccionLlanta>> obtenerPendientesSync() {
    return (select(inspeccionLlantas)
          ..where((t) => t.pendienteSync.equals(true)))
        .get();
  }

  // 2. Marcar una lista específica de IDs como sincronizados (pendienteSync = false)
  Future<void> marcarComoSincronizados(List<String> ids) async {
    // Si la lista está vacía, no hacemos nada para evitar errores en SQL
    if (ids.isEmpty) return; 

    await (update(inspeccionLlantas)
          ..where((t) => t.id.isIn(ids))) // Filtramos solo por los IDs que ya se enviaron
        .write(
      const InspeccionLlantasCompanion(
        pendienteSync: Value(false),
      ),
    );
  }
}

// --------------------------------------------------------------
// SINCRONIZACIÓN
// --------------------------------------------------------------

@DriftAccessor(tables: [SyncData])
class SyncDataDao extends DatabaseAccessor<AppDatabase> with _$SyncDataDaoMixin {

  SyncDataDao(super.db);

  /// Obtiene la fecha del último sync exitoso ordenando por el ID más reciente.
  /// Si no existe un sync previo, retorna el 1 de Enero de 1970 para traer todo el histórico.
  Future<DateTime> getLastSuccessfulSync() async {
    final row = await (select(syncData)
          ..orderBy([(t) => OrderingTerm.desc(t.id)]) // Ordena de mayor a menor ID
          ..limit(1))
        .getSingleOrNull();

    // Si row es null o su fecha es null, retorna 1970-01-01 (Epoch)
    return row?.lastSuccessfulSync ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Inserta un nuevo registro con la fecha del sync
  Future<void> insertLastSync(DateTime date) async {
    await into(syncData).insert(
      SyncDataCompanion(
        lastSuccessfulSync: Value(date),
      ),
    );
  }

  /// (Opcional) resetear sync — útil para debug
  Future<void> clearSync() async {
    await delete(syncData).go();
  }
}
