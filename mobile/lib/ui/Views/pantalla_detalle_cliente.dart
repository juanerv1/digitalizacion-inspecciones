import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspeccion_finalizada.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspeccion_proceso.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class PantallaDetalleCliente extends StatefulWidget {
  // Recibimos el cliente desde la pantalla anterior para pintar el encabezado rápido
  final ClienteResumen cliente; 

  const PantallaDetalleCliente({
    super.key,
    required this.cliente,
  });

  @override
  State<PantallaDetalleCliente> createState() => _PantallaDetalleClienteState();
}

class _PantallaDetalleClienteState extends State<PantallaDetalleCliente> {
  String _terminoBusqueda = '';
  // ignore: unused_field
  bool _isLoading = true;
  late Stream<List<InspeccionResumen>> _inspeccionesStream;

  @override
  void initState() {
    super.initState();
    // Asignamos el stream directamente, sin await ni setState
    _inspeccionesStream = getIt<AppDatabase>()
        .inspeccionesDao
        .getInspeccionesPorCliente(widget.cliente.id);
  }

  Future<void> _cargarInspecciones() async {
    setState(() => _isLoading = true);
    try {

      final datos = getIt<AppDatabase>()
          .inspeccionesDao
          .getInspeccionesPorCliente(widget.cliente.id);

      setState(() {
        _inspeccionesStream = datos;
      });
    } catch (e) {
      debugPrint('Error al cargar inspecciones del cliente: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

    // --- MODAL PARA FINALIZAR ---
  Future<void> _confirmarFinalizar(BuildContext context, String inspeccionId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar Inspección'),
        content: const Text(
          '¿Estás seguro de que deseas finalizar esta inspección? Cambiará su estado a FINALIZADO y ya no aparecerá en esta lista.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Finalizar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      await getIt<AppDatabase>().inspeccionesDao.finalizarInspeccion(inspeccionId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspección finalizada correctamente'), backgroundColor: AppColors.success),
        );
      }
    }
  }

  // --- MODAL PARA ELIMINAR ---
  Future<void> _confirmarEliminar(BuildContext context, String inspeccionId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Inspección'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta inspección? Se borrarán de forma permanente todos los vehículos y llantas asociados. Esta acción no se puede deshacer.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      await getIt<AppDatabase>().inspeccionesDao.eliminarInspeccionEnCascada(inspeccionId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspección eliminada'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente.nombre),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 1. SECCIÓN DE RESUMEN DEL CLIENTE
          _construirEncabezadoCliente(),

          const Divider(height: 1, color: AppColors.greyLight),

          // 2. BARRA DE BÚSQUEDA
          _construirBarraBusqueda(
            hintText: 'Buscar inspección...',
            onChanged: (valor) => setState(() => _terminoBusqueda = valor),
          ),

          // 3. LISTADO DE INSPECCIONES REACTIVO (StreamBuilder)
          Expanded(
            child: StreamBuilder<List<InspeccionResumen>>(
              stream: _inspeccionesStream,
              builder: (context, snapshot) {
                // Estado de carga inicial
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                // Manejo de error
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
                }

                // Datos recibidos del Stream
                final todasLasInspecciones = snapshot.data ?? [];

                // Filtrado local en memoria
                final inspeccionesFiltradas = todasLasInspecciones.where((inspeccion) {
                  final nombre = inspeccion.nombre?.toLowerCase() ?? 'sin nombre asignado';
                  return nombre.contains(_terminoBusqueda.toLowerCase());
                }).toList();

                // Estado vacío
                if (inspeccionesFiltradas.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay inspecciones para este cliente.',
                      style: TextStyle(color: AppColors.greyDark),
                    ),
                  );
                }

                // Lista construida
                return ListView.builder(
                  itemCount: inspeccionesFiltradas.length,
                  itemBuilder: (context, index) {
                    final insp = inspeccionesFiltradas[index];
                    final fecha = DateFormat('dd MMM yyyy').format(insp.fechaRevision);

                    // Evaluamos el estado
                    final esFinalizado = insp.estado == 'FINALIZADO';
                    final colorBorde = esFinalizado ? AppColors.success : AppColors.warning; 

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 1,
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colorBorde, 
                          width: 2.0, 
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorBorde.withValues(alpha: 0.1),
                          child: Icon(
                            esFinalizado ? Icons.check_circle : Icons.pending_actions, 
                            color: colorBorde,
                          ),
                        ),
                        title: Text(
                          insp.nombre ?? 'Inspección sin nombre', 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          )
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Fecha: $fecha\nVehículos: ${insp.cantidadVehiculos} | Llantas: ${insp.cantidadLlantas}',
                              style: const TextStyle(color: AppColors.greyDark),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              insp.estado,
                              style: TextStyle(
                                color: colorBorde,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        
                        // --- MENU CONDICIONAL ---
                        trailing: esFinalizado 
                          ? null // Si está finalizado, no mostramos nada
                          : PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.greyDark),
                              onSelected: (String result) {
                                if (result == 'finalizar') {
                                  _confirmarFinalizar(context, insp.id);
                                } else if (result == 'eliminar') {
                                  _confirmarEliminar(context, insp.id);
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'finalizar',
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                                      SizedBox(width: 12),
                                      Text('Finalizar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'eliminar',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                      SizedBox(width: 12),
                                      Text('Eliminar'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        
                        onTap: () {
                          if (insp.estado == 'FINALIZADO') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaDetalleInspeccionFinalizada(
                                  inspeccion: insp, 
                                ),
                              ),
                            );
                          } else if (insp.estado == 'PENDIENTE') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaDetalleInspeccionProceso(
                                  inspeccion: insp, 
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<List<InspeccionResumen>>(
        stream: _inspeccionesStream,
        builder: (context, snapshot) {
          // Obtenemos la lista actual de inspecciones del snapshot
          final inspecciones = snapshot.data ?? [];

          // Verificamos si existe al menos una inspección con estado 'PENDIENTE'
          // .any devuelve true en cuanto encuentra la primera coincidencia
          bool tieneInspeccionPendiente = inspecciones.any(
            (ins) => ins.estado == 'PENDIENTE'
          );

          return FloatingActionButton.extended(
            // Si tiene una pendiente, el onPressed es null (se deshabilita automáticamente)
            onPressed: tieneInspeccionPendiente 
                ? null 
                : () => _mostrarModalNuevaInspeccion(context),
            
            // Cambiamos el color a gris si está deshabilitado para que sea visualmente claro
            backgroundColor: tieneInspeccionPendiente 
                ? AppColors.greyLight 
                : AppColors.primary,
            
            foregroundColor: AppColors.white,
            icon: const Icon(Icons.add),
            
            // Opcional: Cambiar el texto para informar al usuario por qué está bloqueado
            label: Text(tieneInspeccionPendiente 
                ? 'Inspección en curso...' 
                : 'Nueva Inspección'
            ),
          );
        },
      ),
    );
  }
  // --- Widgets Auxiliares ---

  Widget _construirEncabezadoCliente() {
    final fechaUltima = widget.cliente.ultimaInspeccion != null
        ? DateFormat('dd MMM yyyy').format(widget.cliente.ultimaInspeccion!)
        : 'Ninguna';

    return Container(
      padding: const EdgeInsets.all(16.0),
      // Usamos el color primario con una opacidad muy baja para dar el tono sutil azulado
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _construirDatoEstatistico(
            titulo: 'Vehículos',
            valor: widget.cliente.cantidadVehiculos.toString(),
            icono: Icons.directions_car,
          ),
          _construirDatoEstatistico(
            titulo: 'Inspecciones',
            valor: widget.cliente.cantidadInspecciones.toString(),
            icono: Icons.assignment_turned_in,
          ),
          _construirDatoEstatistico(
            titulo: 'Última Rev.',
            valor: fechaUltima,
            icono: Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _construirDatoEstatistico({
    required String titulo,
    required String valor,
    required IconData icono,
  }) {
    return Column(
      children: [
        Icon(icono, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        Text(
          titulo,
          style: const TextStyle(fontSize: 12, color: AppColors.greyDark),
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
        style: const TextStyle(color: AppColors.black), // Texto que escribe el usuario
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          filled: true,
          fillColor: AppColors.greyExtraLight, // Fondo acorde a la paleta
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // --- Lógica de Nueva Inspección --- //Clases del modal


void _mostrarModalNuevaInspeccion(BuildContext context) {
    // Controladores para el estado del formulario
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController();
    DateTime fechaSeleccionada = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Importante para que el teclado no tape el formulario
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste para el teclado
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Crear Nueva Inspección',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo: Nombre de la Inspección
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la Inspección',
                        labelStyle: const TextStyle(color: AppColors.greyDark),
                        hintText: 'Ej. Revisión Mensual Flota A',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Selector de Fecha
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fecha de Inspección', style: TextStyle(color: AppColors.greyDark)),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy').format(fechaSeleccionada),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      trailing: const Icon(Icons.calendar_month, color: AppColors.primary),
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: fechaSeleccionada,
                          // <--- EL CAMBIO: Restringimos la fecha mínima a la fecha actual
                          firstDate: DateTime.now(), 
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary, 
                                  onPrimary: AppColors.white, 
                                  onSurface: AppColors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (fecha != null) {
                          setStateModal(() => fechaSeleccionada = fecha);
                        }
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
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Cerramos el teclado
                                FocusScope.of(context).unfocus(); 
                                // Mostramos la confirmación
                                _mostrarDialogoConfirmacion(
                                  context: modalContext, 
                                  nombre: nombreController.text.trim(), 
                                  fecha: fechaSeleccionada,
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
            );
          },
        );
      },
    );
  }

  void _mostrarDialogoConfirmacion({
    required BuildContext context, 
    required String nombre, 
    required DateTime fecha
  }) {
    final fechaStr = DateFormat('dd MMM yyyy').format(fecha);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Confirmar'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Deseas crear la siguiente inspección?'),
              const SizedBox(height: 16),
              _itemConfirmacion('Cliente:', widget.cliente.nombre), // Asumiendo que el cliente tiene la propiedad 'nombre'
              _itemConfirmacion('Nombre:', nombre),
              _itemConfirmacion('Fecha:', fechaStr),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.greyDark)),
            ),
            ElevatedButton(
              onPressed: () async {
                // 1. Cerramos el Dialogo de confirmación
                Navigator.pop(dialogContext);
                
                // 2. Cerramos el BottomSheet del formulario
                Navigator.pop(context);

                // 3. Ejecutamos la lógica de base de datos
                try {
                  getIt<AppDatabase>().inspeccionesDao.crearNuevaInspeccion
                  (
                    clienteId: widget.cliente.id, 
                    nombre: nombre, 
                    fechaInspeccion: fecha,
                  );

                  // 4. Refrescamos la lista de inspecciones de la pantalla
                  _cargarInspecciones();

                  // 5. Mostramos un mensaje de éxito
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Inspección creada exitosamente'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al crear la inspección'),
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

  // Pequeño helper para el texto del dialog
  Widget _itemConfirmacion(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
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


