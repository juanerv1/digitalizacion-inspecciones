import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspeccion_proceso.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PantallaInspecciones extends StatefulWidget {
  const PantallaInspecciones({super.key});

  @override
  State<PantallaInspecciones> createState() => _PantallaInspeccionesState();
}

class _PantallaInspeccionesState extends State<PantallaInspecciones> {
  String _terminoBusqueda = '';
  
  // Declaramos el stream
  late Stream<List<InspeccionResumen>> _inspeccionesStream; 

  @override
  void initState() {
    super.initState();
    // Inicializamos el stream conectándolo con el DAO modificado
    _inspeccionesStream = getIt<AppDatabase>().inspeccionesDao.watchInspeccionesNoFinalizadas();
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
      appBar: AppBar(title: const Text('Inspecciones Activas'), centerTitle: false),
      body: Column(
        children: [
          // BARRA DE BÚSQUEDA
          _construirBarraBusqueda(
            hintText: 'Buscar inspección...',
            onChanged: (valor) => setState(() => _terminoBusqueda = valor),
          ),
          
          // LISTA REACTIVA (StreamBuilder)
          Expanded(
            child: StreamBuilder<List<InspeccionResumen>>(
              stream: _inspeccionesStream,
              builder: (context, snapshot) {
                // 1. Cargando datos por primera vez
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Manejo de errores
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
                }

                // 3. Obtenemos los datos frescos
                final todasLasInspecciones = snapshot.data ?? [];

                // 4. Aplicamos el filtro de búsqueda en memoria
                final inspeccionesFiltradas = todasLasInspecciones.where((inspeccion) {
                  final nombre = inspeccion.nombre?.toLowerCase() ?? 'sin nombre asignado';
                  return nombre.contains(_terminoBusqueda.toLowerCase());
                }).toList();

                // 5. Estado vacío
                if (inspeccionesFiltradas.isEmpty) {
                  return const Center(child: Text('No hay inspecciones para mostrar.'));
                }

                // 6. Lista construida
                return ListView.builder(
                  itemCount: inspeccionesFiltradas.length,
                  itemBuilder: (context, index) {
                    final insp = inspeccionesFiltradas[index];
                    final fecha = DateFormat('dd MMM yyyy').format(insp.fechaRevision);
                    final colorBorde = AppColors.warning; 

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 1,
                      color: AppColors.surface, // Fondo blanco definido en tu paleta
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colorBorde, 
                          width: 1.5, 
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorBorde.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.pending_actions, 
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
                            // --- NUEVO: Nombre del cliente ---
                            Text(
                              'Cliente: ${insp.clienteNombre ?? 'Desconocido'}',
                              style: const TextStyle(
                                color: AppColors.greyDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // --- Estadísticas y Fecha ---
                            Text(
                              'Fecha: $fecha\nVehículos: ${insp.cantidadVehiculos} | Llantas: ${insp.cantidadLlantas}',
                              style: const TextStyle(color: AppColors.greyDark),
                            ),
                            const SizedBox(height: 6),
                            // --- Estado ---
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
                        
                        // --- NUEVO MENU TRAILING ---
                        trailing: PopupMenuButton<String>(
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
                        // ---------------------------
                        
                        onTap: () {
                          if (insp.estado == 'PENDIENTE') {
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
    );
  }

  Widget _construirBarraBusqueda({required String hintText, required ValueChanged<String> onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}