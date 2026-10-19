import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspeccion_proceso_detalle.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PantallaDetalleInspeccionProceso extends StatefulWidget {

  final InspeccionResumen inspeccion; 

  const PantallaDetalleInspeccionProceso({
    super.key,
    required this.inspeccion,
  });

  @override
  State<PantallaDetalleInspeccionProceso> createState() => _PantallaDetalleInspeccionProcesoState();
}
class _PantallaDetalleInspeccionProcesoState extends State<PantallaDetalleInspeccionProceso> {
  String _terminoBusqueda = '';
  
  // 1. Declaramos el Stream
  late Stream<List<VehiculoInspeccionResumen>> _vehiculosStream; 
  late Stream<InspeccionResumen?> _inspeccionStream; 

  @override
  void initState() {
    super.initState();
    // 2. Inicializamos el Stream una sola vez en el initState.
    // IMPORTANTE: Asegúrate de tener o crear el método 'watchVehiculosParaInspeccion' 
    // en tu DAO (que use .watch() en lugar de .get())
    _vehiculosStream = getIt<AppDatabase>()
        .vehiculosDao
        .getVehiculosParaInspeccion(
          clienteId: widget.inspeccion.clienteId, 
          inspeccionId: widget.inspeccion.id,
        );

    _inspeccionStream = getIt<AppDatabase>().inspeccionesDao.watchInspeccionPorId(
      inspeccionId: widget.inspeccion.id
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Inspección'),
        centerTitle: false,
      ),
      // El StreamBuilder ahora envuelve todo el contenido de la pantalla
      body: StreamBuilder<List<VehiculoInspeccionResumen>>(
        stream: _vehiculosStream,
        builder: (context, snapshot) {
          // 1. Manejo de estado de carga general
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          // 2. Manejo de errores
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
          }

          final vehiculosDb = snapshot.data ?? [];

          // 3. Filtrado local
          final vehiculosFiltrados = vehiculosDb.where((vehiculo) {
            final codigo = vehiculo.codigoVehiculo.toLowerCase();
            final marca = vehiculo.nombreMarca?.toLowerCase() ?? '';
            final busqueda = _terminoBusqueda.toLowerCase();
            return codigo.contains(busqueda) || marca.contains(busqueda);
          }).toList();

          // 4. Construcción de la interfaz ya con los datos disponibles
          return Column(
            children: [
              // 1. SECCIÓN DE RESUMEN DE LA INSPECCIÓN (Ahora es reactivo)
              // NOTA: Si modificas el método para recibir la lista, puedes usar: _construirEncabezadoInspeccion(vehiculosDb)
              _construirEncabezadoInspeccion(),

              const Divider(height: 1, color: AppColors.greyLight),

              // 2. BARRA DE BÚSQUEDA
              _construirBarraBusqueda(
                hintText: 'Buscar por código o marca...',
                onChanged: (valor) => setState(() => _terminoBusqueda = valor),
              ),

              // 3. LISTADO DE VEHÍCULOS
              Expanded(
                child: vehiculosFiltrados.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay vehículos que coincidan.',
                          style: TextStyle(color: AppColors.greyDark),
                        ),
                      )
                    : ListView.builder(
                        itemCount: vehiculosFiltrados.length,
                        itemBuilder: (context, index) {
                          final vehiculo = vehiculosFiltrados[index];
                          return _construirCardVehiculo(vehiculo);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarModalNuevoVehiculo(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Nuevo Vehículo'),
      ),
    );
  }
  Widget _construirEncabezadoInspeccion() {
    return StreamBuilder<InspeccionResumen?>(
      stream: _inspeccionStream,
      builder: (context, snapshot) {
        // Usamos los datos frescos si existen, si no, usamos los que llegaron por constructor (para evitar parpadeos)
        final inspeccionActual = snapshot.data ?? widget.inspeccion;
        
        final fecha = DateFormat('dd MMM yyyy').format(inspeccionActual.fechaRevision);

        return Container(
          // Redujimos el padding vertical a 12 (antes 16)
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: AppColors.primary.withValues(alpha: 0.05),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Fila superior: Título a la izquierda, Fecha a la derecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      inspeccionActual.nombre ?? 'Inspección sin nombre',
                      style: const TextStyle(
                        fontSize: 18, // Un poco más compacto
                        fontWeight: FontWeight.bold, 
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Por si el nombre es muy largo
                    ),
                  ),
                  const SizedBox(width: 8),
                  // La fecha ahora va al lado derecho
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(fecha, style: const TextStyle(fontSize: 12, color: AppColors.greyDark)),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12), // Espaciado menor
              
              // 2. Fila inferior: Estadísticas acomodadas horizontalmente
              Row(
                children: [
                  _construirMiniStat(
                    icono: Icons.directions_car,
                    valor: '${inspeccionActual.cantidadVehiculos} Vehículos',
                  ),
                  const SizedBox(width: 24),
                  _construirMiniStat(
                    icono: Icons.tire_repair,
                    valor: '${inspeccionActual.cantidadLlantas} Llantas revisadas',
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
  // --- Nuevo Helper para ahorrar espacio vertical ---
  Widget _construirMiniStat({required IconData icono, required String valor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600, 
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _construirBarraBusqueda({
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        ),
      ),
    );
  }

  Widget _construirCardVehiculo(VehiculoInspeccionResumen vehiculo) { 
    final tipo = vehiculo.nombreTipo ?? 'Tipo desc.';
    final marca = vehiculo.nombreMarca ?? 'Marca desc.';
    
    List<String> lecturas = [];
    if (vehiculo.kilometraje != null) {
      lecturas.add('${vehiculo.kilometraje} Km');
    } else {
      lecturas.add('- Km');
    }

    if (vehiculo.horometro != null) {
      lecturas.add('${vehiculo.horometro} Hrs');
    } else {
      lecturas.add('- Hrs');
    }
    
    String medicion = lecturas.isEmpty ? 'Sin lectura' : lecturas.join(' | ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: vehiculo.estaInspeccionado ? Colors.transparent : AppColors.error,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12), 
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaDetalleVehiculoInspeccionFinalizada(
                vehiculo: vehiculo,
                inspeccionId: widget.inspeccion.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FILA 1: Título del Vehículo y Estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vehículo: ${vehiculo.codigoVehiculo}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  Icon(
                    vehiculo.estaInspeccionado ? Icons.check_circle : Icons.error_outline,
                    color: vehiculo.estaInspeccionado ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
              const Divider(color: AppColors.greyLight),
              
              // FILA 2: Marca, Tipo y Conteo de Llantas
              Row(
                children: [
                  // Agrupamos Marca y Tipo en un Expanded para que no empujen el contador de llantas
                  Expanded(
                    flex: 4, 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marca: $marca', 
                          style: const TextStyle(color: AppColors.greyDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tipo: $tipo', 
                          style: const TextStyle(color: AppColors.greyDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Contador de llantas alineado a la derecha
                  Text(
                    'Llantas: ${vehiculo.cantidadLlantasInspeccionadas} / ${vehiculo.noLlantas}',
                    style: TextStyle(
                      color: vehiculo.cantidadLlantasInspeccionadas == vehiculo.noLlantas 
                          ? AppColors.success 
                          : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // FILA 3: Lecturas abajo ocupando todo el ancho disponible
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.greyLight.withValues(alpha: 0.2), // Un fondo sutil para destacar la lectura
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.speed, size: 16, color: AppColors.greyDark),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Lecturas: $medicion', 
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Protección final por si el número es masivo
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }  // --- Lógica de Nuevo Vehículo ---

  void _mostrarModalNuevoVehiculo(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final codigoController = TextEditingController();
    final llantasController = TextEditingController();
    
    // Controladores para atrapar el texto de los Autocomplete
    TextEditingController? tipoController;
    TextEditingController? marcaController;

    // 1. Cargamos las variables existentes de forma rápida para el autocompletado
    final db = getIt<AppDatabase>(); // Ajusta según cómo obtengas tu DB
    final clienteId = widget.inspeccion.clienteId; // Asumiendo que tienes widget.inspeccion

    final tiposExistentes = await db.clienteVariablesDao.getVariablesPorClienteYTipo(
      clienteId, TipoVariableEnum.TipoVehiculo,
    );
    final marcasExistentes = await db.clienteVariablesDao.getVariablesPorClienteYTipo(
      clienteId, TipoVariableEnum.MarcaVehiculo,
    );


    // Mapeamos solo los nombres para la búsqueda
    final nombresTipos = tiposExistentes.map((e) => e.nombre).toList();
    final nombresMarcas = marcasExistentes.map((e) => e.nombre).toList();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom, 
            left: 20, right: 20, top: 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Agregar Nuevo Vehículo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo: Código Vehículo
                  TextFormField(
                    controller: codigoController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Código / Placa del Vehículo',
                      labelStyle: const TextStyle(color: AppColors.greyDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo: Tipo (Autocomplete)
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) return nombresTipos;
                      return nombresTipos.where((tipo) => 
                        tipo.toLowerCase().contains(textEditingValue.text.toLowerCase())
                      );
                    },
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      tipoController = controller; // Guardamos la referencia
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Vehículo (Ej. Camión, Tractomula)',
                          hintText: 'Selecciona o escribe uno nuevo',
                          labelStyle: const TextStyle(color: AppColors.greyDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.greyDark),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Marca (Autocomplete)
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) return nombresMarcas;
                      return nombresMarcas.where((marca) => 
                        marca.toLowerCase().contains(textEditingValue.text.toLowerCase())
                      );
                    },
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      marcaController = controller; 
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Marca de Vehículo',
                          hintText: 'Selecciona o escribe una nueva',
                          labelStyle: const TextStyle(color: AppColors.greyDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.greyDark),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Número de Llantas
                  TextFormField(
                    controller: llantasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Número de Llantas',
                      labelStyle: const TextStyle(color: AppColors.greyDark),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Requerido';
                      if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Ingrese un número válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botones del Modal
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(modalContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.greyDark,
                            side: const BorderSide(color: AppColors.greyLight),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus(); 
                              
                              final codigo = codigoController.text.trim();
                              final llantas = int.parse(llantasController.text.trim());
                              final tipo = tipoController!.text.trim();
                              final marca = marcaController!.text.trim();

                              // 2. Verificamos si hay variables nuevas antes de mostrar el diálogo
                              final variablesNuevas = await db.clienteVariablesDao.verificarNuevasVariables(
                                clienteId: clienteId,
                                nombreTipoVehiculo: tipo,
                                nombreMarcaVehiculo: marca,
                              );

                              if (!modalContext.mounted) return;
                              // 3. Mostramos la confirmación pasándole las variables nuevas
                              _mostrarDialogoConfirmacionVehiculo(
                                context: modalContext, 
                                codigo: codigo,
                                llantas: llantas,
                                tipo: tipo,
                                marca: marca,
                                variablesNuevas: variablesNuevas,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogoConfirmacionVehiculo({
    required BuildContext context, 
    required String codigo,
    required int llantas,
    required String tipo,
    required String marca,
    required List<String> variablesNuevas,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.directions_car, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Confirmar Vehículo'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Se creará el vehículo con los siguientes datos:'),
              const SizedBox(height: 12),
              _itemConfirmacion('Código/Placa:', codigo),
              _itemConfirmacion('Llantas:', llantas.toString()),
              _itemConfirmacion('Tipo:', tipo),
              _itemConfirmacion('Marca:', marca),
              
              // Sección de advertencia de Variables Nuevas
              if (variablesNuevas.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.new_releases, size: 16, color: AppColors.warning),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Se crearán las siguientes variables nuevas:',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warning),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...variablesNuevas.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('• $v', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                      )),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.greyDark)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Cerrar Dialog
                Navigator.pop(context); // Cerrar BottomSheet

                try {
                  final db = getIt<AppDatabase>();
                  
                  await db.vehiculosDao.crearVehiculoLocal(
                    codigoVehiculo: codigo,
                    clienteId: widget.inspeccion.clienteId, // Ajusta si tu variable se llama distinto
                    noLlantas: llantas,
                    nombreTipo: tipo, 
                    nombreMarca: marca,
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Vehículo creado exitosamente'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text('Error al crear el vehículo: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Sí, crear'),
            ),
          ],
        );
      },
    );
  }

  // Si no tienes este helper en el archivo, agrégalo:
  Widget _itemConfirmacion(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$titulo ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
          Expanded(child: Text(valor, style: const TextStyle(color: AppColors.greyDark))),
        ],
      ),
    );
  }
}

