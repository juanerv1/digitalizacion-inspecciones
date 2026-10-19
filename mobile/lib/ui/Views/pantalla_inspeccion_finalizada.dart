import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspeccion_finalizada_detalle.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PantallaDetalleInspeccionFinalizada extends StatefulWidget {

  final InspeccionResumen inspeccion; 

  const PantallaDetalleInspeccionFinalizada({
    super.key,
    required this.inspeccion,
  });

  @override
  State<PantallaDetalleInspeccionFinalizada> createState() => _PantallaDetalleInspeccionFinalizadaState();
}

class _PantallaDetalleInspeccionFinalizadaState extends State<PantallaDetalleInspeccionFinalizada> {
  String _terminoBusqueda = '';
  List<VehiculoInspeccionResumen> _vehiculos = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  Future<void> _cargarVehiculos() async {
    setState(() => _isLoading = true);
    try {

      final datos = await getIt<AppDatabase>()
          .vehiculosDao
          .getVehiculosInspeccionados(widget.inspeccion.id);


      setState(() {
        _vehiculos = datos;
      });
    } catch (e) {
      debugPrint('Error al cargar los vehículos de la inspección: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrado local en memoria por código de vehículo o marca
    final vehiculosFiltrados = _vehiculos.where((vehiculo) {
      final codigo = vehiculo.codigoVehiculo.toLowerCase();
      final marca = vehiculo.nombreMarca?.toLowerCase() ?? '';
      final busqueda = _terminoBusqueda.toLowerCase();
      return codigo.contains(busqueda) || marca.contains(busqueda);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Inspección'),
        centerTitle: false,
        // Eliminamos el color verde forzado; ahora hereda automáticamente 
        // AppColors.primary y AppColors.white desde el tema global en main.dart
      ),
      body: Column(
        children: [
          // 1. SECCIÓN DE RESUMEN DE LA INSPECCIÓN
          _construirEncabezadoInspeccion(),

          const Divider(height: 1, color: AppColors.greyLight),

          // 2. BARRA DE BÚSQUEDA
          _construirBarraBusqueda(
            hintText: 'Buscar por código o marca...',
            onChanged: (valor) => setState(() => _terminoBusqueda = valor),
          ),

          // 3. LISTADO DE VEHÍCULOS
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : vehiculosFiltrados.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay vehículos en esta inspección.',
                          style: TextStyle(color: AppColors.greyDark),
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _cargarVehiculos, // Asumo que tienes este método
                        child: ListView.builder(
                          itemCount: vehiculosFiltrados.length,
                          itemBuilder: (context, index) {
                            final vehiculo = vehiculosFiltrados[index];
                            return _construirCardVehiculo(vehiculo);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _construirEncabezadoInspeccion() {
    final fecha = DateFormat('dd MMM yyyy').format(widget.inspeccion.fechaRevision);

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
                  widget.inspeccion.nombre ?? 'Inspección sin nombre',
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
                valor: '${widget.inspeccion.cantidadVehiculos} Vehículos',
              ),
              const SizedBox(width: 24),
              _construirMiniStat(
                icono: Icons.tire_repair,
                valor: '${widget.inspeccion.cantidadLlantas} Llantas revisadas',
              ),
            ],
          ),
        ],
      ),
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
              builder: (context) => PantallaDetalleVehiculoInspeccion(
                vehiculo: vehiculo,
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
}