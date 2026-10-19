import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PantallaDetalleVehiculoInspeccion extends StatefulWidget {
  final VehiculoInspeccionResumen vehiculo; 

  const PantallaDetalleVehiculoInspeccion({
    super.key,
    required this.vehiculo,
  });

  @override
  State<PantallaDetalleVehiculoInspeccion> createState() => _PantallaDetalleVehiculoInspeccionState();
}

class _PantallaDetalleVehiculoInspeccionState extends State<PantallaDetalleVehiculoInspeccion> {
  List<LlantaInspeccionResumen> _llantasInspeccionadas = []; 
  late LlantaInspeccionResumen? _llantaSeleccionada; 
  bool _isLoading = true;
  int? _indicePosicionSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarDatosLlantas();
  }

  Future<void> _cargarDatosLlantas() async {
    setState(() => _isLoading = true);
    try {
      final datos = await getIt<AppDatabase>()
          .inspeccionLlantasDao
          .getLlantasDeVehiculoEnInspeccion(
            inspeccionId: widget.vehiculo.inspeccionId!, 
            vehiculoId: widget.vehiculo.vehiculoId,      
          );

      setState(() {
        _llantasInspeccionadas = datos;
        
        if (_llantasInspeccionadas.isNotEmpty) {
          _llantaSeleccionada = _llantasInspeccionadas.first;
          _indicePosicionSeleccionada = _llantaSeleccionada!.posicion; // Usamos ! porque sabemos que no es null aquí
        } else {
          // Si no hay llantas, nos aseguramos de que esto sea null
          _llantaSeleccionada = null; 
        }
      });
    } catch (e) {
      debugPrint('Error al cargar llantas: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículo: ${widget.vehiculo.codigoVehiculo}'),
        centerTitle: false,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : Column(
            children: [
              // 1. ENCABEZADO DEL VEHÍCULO (Reutilizando estilo)
              _construirEncabezadoVehiculo(),

              if (_llantasInspeccionadas.isEmpty) ...[
                
                // --- MENSAJE DE VACÍO ---
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.tire_repair, size: 64, color: AppColors.greyLight),
                        SizedBox(height: 16),
                        Text(
                          'No hay llantas inspeccionadas\nen este vehículo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: AppColors.greyDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else...[

              // 2. MINI MENÚ DESLIZABLE DE POSICIONES
              _construirSelectorPosiciones(),

              const Divider(height: 1, color: AppColors.greyLight),

              // 3. DETALLE DE LA LLANTA SELECCIONADA
              Expanded(
                child: _llantaSeleccionada == null
                    ? const Center(
                        child: Text(
                          'Selecciona una posición inspeccionada',
                          style: TextStyle(color: AppColors.greyDark),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: _construirDetalleLlanta(),
                      ),
                ),
              ],
            ]
          ),
    );
  }

  Widget _construirEncabezadoVehiculo() {
    // 1. Evaluamos horómetro y kilometraje de forma independiente
    List<String> lecturas = [];
    if (widget.vehiculo.kilometraje != null) {
      lecturas.add('${widget.vehiculo.kilometraje} Km');
    }
    if (widget.vehiculo.horometro != null) {
      lecturas.add('${widget.vehiculo.horometro} Hrs');
    }
    String medicion = lecturas.isEmpty ? 'Sin lectura' : lecturas.join(' | ');

    // 2. Construimos la interfaz mejorada
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05), // Fondo azulado muy tenue 
        border: Border(
          bottom: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5), width: 2),
        ),
      ),
      child: Row(
        children: [
          // Avatar o Ícono representativo
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            radius: 26,
            child: const Icon(Icons.directions_car, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          
          // Columna con los datos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Marca y Tipo en una sola línea destacada
                Text(
                  '${widget.vehiculo.nombreMarca ?? 'Marca desc.'} • ${widget.vehiculo.nombreTipo ?? 'Tipo desc.'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Fila inferior: Lectura a la izquierda, Llantas a la derecha
                Row(
                  children: [
                    const Icon(Icons.speed, size: 16, color: AppColors.greyDark),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        medicion,
                        style: const TextStyle(
                          color: AppColors.greyDark, 
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // Etiqueta (Chip) para resaltar la cantidad de llantas
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary, // Resalta con el azul profundo
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.vehiculo.noLlantas} Llantas',
                        style: const TextStyle(
                          color: AppColors.white, 
                          fontSize: 12, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirSelectorPosiciones() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.vehiculo.noLlantas,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          int numeroPosicion = index + 1;
          
          // Buscamos si esta posición fue inspeccionada
          final llantaEncontrada = _llantasInspeccionadas
              .where((l) => l.posicion == numeroPosicion)
              .firstOrNull;

          bool estaInspeccionada = llantaEncontrada != null;
          bool esLaSeleccionada = _indicePosicionSeleccionada == numeroPosicion;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text('Pos. $numeroPosicion'),
              selected: esLaSeleccionada,
              onSelected: estaInspeccionada 
                ? (selected) {
                    setState(() {
                      _indicePosicionSeleccionada = numeroPosicion;
                      _llantaSeleccionada = llantaEncontrada;
                    });
                  }
                : null, // Deshabilitado si no se inspeccionó
              selectedColor: AppColors.primary,
              disabledColor: AppColors.greyExtraLight,
              checkmarkColor: AppColors.white, // Aseguramos que el chulo se vea blanco
              labelStyle: TextStyle(
                color: esLaSeleccionada ? AppColors.white : (estaInspeccionada ? AppColors.black : AppColors.grey),
                fontWeight: estaInspeccionada ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: estaInspeccionada ? AppColors.primaryLight : AppColors.greyLight,
                  width: 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirDetalleLlanta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card de Información General de la Llanta

        // 1. Información General Organizada en Cuadrícula
        Card(
          elevation: 1,
          color: AppColors.surface, // Fondo blanco de tu paleta
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _filaDetalle('Código Llanta', _llantaSeleccionada!.codigoLlanta, icon: Icons.qr_code),
                _filaDetalle(
                  'Fecha de Montaje', 
                  _llantaSeleccionada!.fechaMontaje != null 
                      ? DateFormat('dd MMM yyyy').format(_llantaSeleccionada!.fechaMontaje!) 
                      : 'N/A', 
                  icon: Icons.calendar_month
                ),       
                const Divider(height: 24, color: AppColors.greyLight),
                Row(
                  children: [
                    Expanded(child: _itemDetalleGrilla('Marca', _llantaSeleccionada!.nombreMarca)),
                    Expanded(child: _itemDetalleGrilla('Diseño', _llantaSeleccionada!.nombreDiseno)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _itemDetalleGrilla('Dimensión', _llantaSeleccionada!.nombreDimension)),
                    Expanded(child: _itemDetalleGrilla('Tipo', _llantaSeleccionada!.nombreTipo)),
                  ],
                ),
                const SizedBox(height: 12),
                // --- NUEVOS CAMPOS AÑADIDOS AQUÍ ---
                Row(
                  children: [
                    Expanded(child: _itemDetalleGrilla('KM Montaje', _llantaSeleccionada!.kmMontaje?.toString())),
                    Expanded(child: _itemDetalleGrilla('Horómetro', _llantaSeleccionada!.horoMontaje?.toString())),
                  ],
                ),
                // -----------------------------------
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        const Text('Mediciones Técnicas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
        const SizedBox(height: 10),

        // 2. Presión y Medidas
        Card(
          elevation: 1,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Bloque de Presión (Usando AppColors.warning para llamar la atención en mediciones clave)
                Column(
                  children: [
                    const Icon(Icons.speed, color: AppColors.warning, size: 20),
                    const SizedBox(height: 2),
                    const Text('Presión', style: TextStyle(fontSize: 12, color: AppColors.grey)),
                    Text(
                      '${_llantaSeleccionada!.presion ?? 0} PSI', 
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.warning)
                    ),
                  ],
                ),
                
                // Separador vertical sutil
                Container(height: 40, width: 1, color: AppColors.greyLight),

                // Bloque de Medidas (Remanente)
                _puntoMedida('Externo', _llantaSeleccionada!.medidaExt),
                _puntoMedida('Central', _llantaSeleccionada!.medidaCent),
                _puntoMedida('Interno', _llantaSeleccionada!.medidaInt),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        const Text('Observaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
        const SizedBox(height: 10),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // Le damos un tono amarillo suave usando el warning con opacidad para denotar 'Atención/Nota'
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.warning)
          ),
          child: Text(
            _llantaSeleccionada!.observacion ?? 'Sin observaciones registradas.',
            style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.black),
          ),
        ),
      ],
    );
  }

  // --- Helpers de UI ---

  Widget _filaDetalle(String titulo, String valor, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 18, color: AppColors.greyDark),
          if (icon != null) const SizedBox(width: 8),
          Text('$titulo: ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
          Expanded(child: Text(valor, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.black))),
        ],
      ),
    );
  }

  Widget _puntoMedida(String label, double? valor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
        Text('${valor ?? 0} mm', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.black)),
      ],
    );
  }

// *Nota: Mantuve este widget afuera si lo tenías fuera de la clase, 
// pero usualmente es buena práctica meterlo dentro de la misma vista u organizarlo en un archivo aparte.
  Widget _itemDetalleGrilla(String titulo, String? valor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
          const SizedBox(height: 2),
          Text(valor ?? 'N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black)),
        ],
      );
  }
}