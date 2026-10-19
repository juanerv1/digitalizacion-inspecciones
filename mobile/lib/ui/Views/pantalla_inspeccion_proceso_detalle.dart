import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/data/db/tables.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PantallaDetalleVehiculoInspeccionFinalizada extends StatefulWidget {
  final VehiculoInspeccionResumen vehiculo; 
  final String inspeccionId;

  const PantallaDetalleVehiculoInspeccionFinalizada({
    super.key,
    required this.vehiculo,
    required this.inspeccionId,
  });

  @override
  State<PantallaDetalleVehiculoInspeccionFinalizada> createState() => _PantallaDetalleVehiculoInspeccionFinalizadaState();
}

class _PantallaDetalleVehiculoInspeccionFinalizadaState extends State<PantallaDetalleVehiculoInspeccionFinalizada> {
  
  // ==========================================
  // 1. VARIABLES Y CONTROLADORES
  // ==========================================
  
  // Streams
  late Stream<VehiculoInspeccionResumen?> _vehiculoStream;
  late Stream<List<LlantaInspeccionResumen>> _llantasStream;
  List<LlantaInspeccionResumen> _llantasActualesList = [];
  List<LlantaInspeccionResumen> _llantasPreviasList = [];

  // Estado de la UI
  bool _isLoading = true;
  int _indicePosicionSeleccionada = 1; // Por defecto seleccionamos la posición 1
  String? _llantaIdExistente; // Para saber si al guardar hacemos UPDATE o INSERT

  // Controladores del formulario
  final _formKey = GlobalKey<FormState>();
  final _codigoCtrl = TextEditingController();
  final _dimensionCtrl = TextEditingController();
  final _disenoCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _tipoCtrl = TextEditingController();
  final _presionCtrl = TextEditingController();
  final _medidaIntCtrl = TextEditingController();
  final _medidaCentCtrl = TextEditingController();
  final _medidaExtCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _horoMontajeCtrl = TextEditingController();
  final _kmMontajeCtrl = TextEditingController();

  List<String> _nombresDimensiones = [];
  List<String> _nombresDisenos = [];
  List<String> _nombresMarcas = [];
  List<String> _nombresTipos = [];

  // ==========================================
  // 2. CICLO DE VIDA (INIT & DISPOSE)
  // ==========================================

// ==========================================
  // 2. CICLO DE VIDA (INIT & DISPOSE)
  // ==========================================

  @override
  void initState() {
    super.initState();
    final db = getIt<AppDatabase>();

    // 1. Stream del Vehículo
    _vehiculoStream = db.vehiculosDao.watchVehiculoInspeccionResumen(
      inspeccionId: widget.inspeccionId,
      vehiculoId: widget.vehiculo.vehiculoId, 
    );

    // 2. Stream de las Llantas
    _llantasStream = db.inspeccionLlantasDao.watchLlantasDeVehiculoEnInspeccion(
      inspeccionId: widget.inspeccionId,
      vehiculoId: widget.vehiculo.vehiculoId,
    );

    // Mantenemos la lista actualizada en tiempo real
    _llantasStream.listen((lista) {
      if (mounted) {
        setState(() {
          _llantasActualesList = lista;
        });
      }
    });

    // 3. Llamamos a la inicialización asíncrona
    _inicializarDatos();
  }

  // --- NUEVA FUNCIÓN ASÍNCRONA ---
  Future<void> _inicializarDatos() async {
    // Aseguramos que la pantalla muestre carga
    setState(() => _isLoading = true);

    // 1. Esperamos a que carguen las variables
    await _cargarVariables();
    
    // 2. ESPERAMOS a que cargue el historial de llantas de la inspección pasada
    await _cargarLlantasPrevias();

    // 3. ESPERAMOS a que el stream emita su primer valor para saber si ya hay llantas guardadas hoy
    _llantasActualesList = await _llantasStream.first;

    // 4. AHORA SÍ, con todas las listas llenas, precargamos la posición 1
    await _cargarDatosParaPosicion(_indicePosicionSeleccionada);

    // Quitamos la pantalla de carga
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _fechaCtrl.dispose();
    _horoMontajeCtrl.dispose();
    _kmMontajeCtrl.dispose();
    _tipoCtrl.dispose();
    _marcaCtrl.dispose();
    _presionCtrl.dispose();
    _medidaIntCtrl.dispose();
    _medidaCentCtrl.dispose();
    _medidaExtCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

// Llámala cada vez que el usuario seleccione una posición diferente
  Future<void> _cargarDatosParaPosicion(int posicion) async {
    // Buscamos si hay datos en ambas listas
    final llantaActual = _llantasActualesList.where((l) => l.posicion == posicion).firstOrNull;
    final llantaPrevia = _llantasPreviasList.where((l) => l.posicion == posicion).firstOrNull;

    // Guardamos el ID solo si es de la actual (para saber si es UPDATE o INSERT)
    _llantaIdExistente = llantaActual?.id; 

    // --- MAGIA AQUÍ ---
    // Definimos de dónde vamos a sacar TODOS los datos sin mezclar.
    // Si existe la actual, la fuente será la actual. Si no, será la previa.
    final llantaFuente = llantaActual ?? llantaPrevia;

    // Helper para convertir cualquier tipo numérico o dinámico a String de forma segura
    String valorAString(dynamic valor) => valor?.toString() ?? '';

    // Ahora llenamos los controladores usando ÚNICAMENTE la 'llantaFuente'.
    _codigoCtrl.text = llantaFuente?.codigoLlanta ?? '';
    
    // CORRECCIÓN FECHA: Convertimos el DateTime a String (formato YYYY-MM-DD) antes de asignarlo al controlador
    _fechaCtrl.text = llantaFuente?.fechaMontaje != null 
        ? llantaFuente!.fechaMontaje!.toIso8601String().split('T')[0] 
        : '';
    
    // NUEVOS CAMPOS: Añadidos los controladores faltantes mapeados correctamente
    _horoMontajeCtrl.text = valorAString(llantaFuente?.horoMontaje);
    _kmMontajeCtrl.text = valorAString(llantaFuente?.kmMontaje);

    _dimensionCtrl.text = llantaFuente?.nombreDimension ?? '';
    _disenoCtrl.text = llantaFuente?.nombreDiseno ?? '';
    _marcaCtrl.text = llantaFuente?.nombreMarca ?? '';
    _tipoCtrl.text = llantaFuente?.nombreTipo ?? '';
    
    _presionCtrl.text = valorAString(llantaFuente?.presion);
    _medidaExtCtrl.text = valorAString(llantaFuente?.medidaExt);
    _medidaCentCtrl.text = valorAString(llantaFuente?.medidaCent);
    _medidaIntCtrl.text = valorAString(llantaFuente?.medidaInt);
    
    _obsCtrl.text = llantaFuente?.observacion ?? '';
    
    // Actualizamos la UI
    setState(() {
      _indicePosicionSeleccionada = posicion;
    });
  }

  // ==========================================
  // 3. BUILD PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Inspección: ${widget.vehiculo.codigoVehiculo}')),
      body: StreamBuilder<List<LlantaInspeccionResumen>>(
        stream: _llantasStream,
        initialData: const [],
        builder: (context, snapshotLlantas) {
          final llantasGuardadas = snapshotLlantas.data ?? [];

          // Actualización automática de controladores al cambiar de posición o cargar datos
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_llantaIdExistente == null && llantasGuardadas.isNotEmpty) {
              final llantaActual = llantasGuardadas
                  .where((l) => l.posicion == _indicePosicionSeleccionada)
                  .firstOrNull;
              if (llantaActual != null && _codigoCtrl.text.isEmpty) {
                _actualizarFormularioConLlanta(llantaActual);
              }
            }
          });

          return Column(
            children: [
              // --- ENCABEZADO REACTIVO ---
              // Escucha los cambios en el kilometraje/horómetro del vehículo
              StreamBuilder<VehiculoInspeccionResumen?>(
                stream: _vehiculoStream,
                builder: (context, snapshotVehiculo) {
                  // Si el stream ya nos dio datos (data) usamos esos.
                  // Si el stream todavía está cargando (es null), usamos el que pasaste por constructor.
                  final vehiculoActual = snapshotVehiculo.data ?? widget.vehiculo;

                  // Le pasamos el vehículo seguro, sin usar "!"
                  return _construirEncabezadoVehiculo(vehiculoActual);
                },
              ),
              
              // --- SELECTOR DE POSICIONES ---
              _construirSelectorPosiciones(),
              
              const Divider(),
              
              // --- FORMULARIO DE INSPECCIÓN DE LLANTA ---
              Expanded(
                child: SingleChildScrollView(
                  child: _construirFormulario(),
                ),
              ),
              
              // --- BOTÓN DE GUARDADO ---
              Builder(
                builder: (context) {
                  final bool yaInspeccionada = llantasGuardadas.any(
                    (l) => l.posicion == _indicePosicionSeleccionada
                  );

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        // Cambiamos el icono para dar mejor contexto visual
                        icon: Icon(yaInspeccionada ? Icons.update : Icons.save),
                        // Cambiamos el texto dinámicamente
                        label: Text(
                          yaInspeccionada ? 'ACTUALIZAR LLANTA' : 'GUARDAR LLANTA', 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        style: ElevatedButton.styleFrom(
                          // Opcional: Puedes cambiar el color si es actualizar (ej. AppColors.warning) para que resalte, o mantener el primary
                          backgroundColor: AppColors.primary, 
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          )
                        ),
                        onPressed: _ejecutarGuardado,
                      ),
                    ),
                  );
                }
              )
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // 4. CONSTRUCTORES DE WIDGETS (UI)
  // ==========================================


  Future<InspeccionVehiculo?> _obtenerLecturasPrevias(VehiculoInspeccionResumen vehiculoActual) async {
    try {
      final db = getIt<AppDatabase>();
      
      final prevInspeccionId = await db.inspeccionesDao.getInspeccionIdPorIndice(
        clienteId: vehiculoActual.clienteId, 
        index: 1, 
      );

      if (prevInspeccionId != null) {
        return await db.inspeccionVehiculosDao.getInspeccionVehiculo(
          inspeccionId: prevInspeccionId,
          vehiculoId: vehiculoActual.vehiculoId, 
        );
      }
    } catch (e) {
      debugPrint('Error obteniendo lectura previa: $e');
    }
    return null;
  }

  Widget _construirEncabezadoVehiculo(VehiculoInspeccionResumen vehiculoActual) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5), width: 2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            radius: 26,
            child: const Icon(Icons.directions_car, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehiculoActual.nombreMarca ?? 'Marca desc.'} • ${vehiculoActual.nombreTipo ?? 'Tipo desc.'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centrado con el botón de edición
                  children: [
                    Expanded(
                      child: FutureBuilder<InspeccionVehiculo?>(
                        future: _obtenerLecturasPrevias(vehiculoActual),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Cargando lecturas...', style: TextStyle(color: AppColors.greyDark, fontSize: 12));
                          }

                          if (snapshot.hasError) {
                            return const Text('Error al cargar', style: TextStyle(color: AppColors.error, fontSize: 12));
                          }

                          final previas = snapshot.data;

                          // Helper para formatear el texto: si es nulo muestra "-"
                          String formatoLectura(double? valor, String unidad) {
                            return valor != null ? '$valor $unidad' : '-';
                          }

                          final kmActualStr = formatoLectura(vehiculoActual.kilometraje, 'Km');
                          final hrsActualStr = formatoLectura(vehiculoActual.horometro, 'Hrs');
                          
                          final kmPrevioStr = formatoLectura(previas?.kilometraje, 'Km');
                          final hrsPrevioStr = formatoLectura(previas?.horometro, 'Hrs');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // HILERA SUPERIOR: Datos Actuales
                              Row(
                                children: [
                                  Text(
                                    'Act Km: $kmActualStr',
                                    style: const TextStyle(
                                      color: AppColors.black, 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 16), // Separación entre Km y Hrs
                                  Text(
                                    'Act Hr: $hrsActualStr',
                                    style: const TextStyle(
                                      color: AppColors.black, 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2), // Separación sutil entre hileras
                              // HILERA INFERIOR: Datos Previos / Anteriores
                              Row(
                                children: [
                                  Text(
                                    'Ant Km: $kmPrevioStr',
                                    style: const TextStyle(
                                      color: AppColors.greyDark, 
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 16), // Separación entre Km y Hrs
                                  Text(
                                    'Ant Hr: $hrsPrevioStr',
                                    style: const TextStyle(
                                      color: AppColors.greyDark, 
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 22, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _mostrarModalEditarLecturas(vehiculoActual),
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

  // ==========================================
  // MODAL PARA EDITAR LECTURAS DEL VEHÍCULO
  // ==========================================

  void _mostrarModalEditarLecturas(VehiculoInspeccionResumen vehiculoActual) {
    final formKey = GlobalKey<FormState>();
    
    // Inicializamos con los valores que el vehículo ya tenga en esta inspección
    final kilometrajeCtrl = TextEditingController(
      text: vehiculoActual.kilometraje != null ? vehiculoActual.kilometraje.toString() : ''
    );
    final horometroCtrl = TextEditingController(
      text: vehiculoActual.horometro != null ? vehiculoActual.horometro.toString() : ''
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para que el teclado no tape el formulario
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.speed, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Actualizar Lecturas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: kilometrajeCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  // --- NUEVO: Formateador para bloquear letras y solo permitir números/decimales ---
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), 
                  ],
                  // --------------------------------------------------------------------------------
                  decoration: InputDecoration(
                    labelText: 'Kilometraje (Km)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: horometroCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  // --- NUEVO: Formateador para bloquear letras y solo permitir números/decimales ---
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  // --------------------------------------------------------------------------------
                  decoration: InputDecoration(
                    labelText: 'Horómetro (Hrs)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(modalContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancelar', style: TextStyle(color: AppColors.greyDark)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {

                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus(); // Cerrar teclado
                            
                            try {
                              final db = getIt<AppDatabase>();
                              
                              // Llama a la función del DAO
                              await db.inspeccionVehiculosDao.guardarInspeccionVehiculo(
                                inspeccionVehiculoIdExistente: vehiculoActual.inspeccionVehiculoId,
                                inspeccionId: widget.inspeccionId,
                                vehiculoId: vehiculoActual.vehiculoId,
                                kilometraje: double.tryParse(kilometrajeCtrl.text.trim()),
                                horometro: double.tryParse(horometroCtrl.text.trim()),
                              );

                              if (mounted && modalContext.mounted) {
                                Navigator.pop(modalContext); // Cierra el modal
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lecturas actualizadas correctamente'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al actualizar: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16)),
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
  }

  Widget _construirSelectorPosiciones() {
    return StreamBuilder<List<LlantaInspeccionResumen>>(
      stream: _llantasStream,
      builder: (context, snapshot) {
        final llantasGuardadas = snapshot.data ?? [];

        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.vehiculo.noLlantas, // Todas las posiciones disponibles
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              int numeroPosicion = index + 1;
              
              final llantaEncontrada = llantasGuardadas
                  .where((l) => l.posicion == numeroPosicion)
                  .firstOrNull;

              bool estaInspeccionada = llantaEncontrada != null;
              bool esLaSeleccionada = _indicePosicionSeleccionada == numeroPosicion;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  // 1. Icono visual extra si ya está inspeccionada (y no está seleccionada)
                  avatar: estaInspeccionada && !esLaSeleccionada
                      ? const Icon(Icons.check_circle, color: AppColors.success, size: 18)
                      : null,
                  label: Text('Pos. $numeroPosicion'),
                  selected: esLaSeleccionada,
                  onSelected: (selected) async {
                    if (!esLaSeleccionada) {
                      await _cargarDatosParaPosicion(numeroPosicion);
                    }
                  },
                  selectedColor: AppColors.primary,
                  // 2. Fondo distinto para las inspeccionadas
                  backgroundColor: estaInspeccionada 
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.white,
                  checkmarkColor: AppColors.white,
                  labelStyle: TextStyle(
                    // 3. Color de texto condicional
                    color: esLaSeleccionada 
                        ? AppColors.white 
                        : (estaInspeccionada ? AppColors.success : AppColors.black),
                    fontWeight: estaInspeccionada ? FontWeight.bold : FontWeight.normal, 
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      // 4. Borde verde si está inspeccionada, primario si está seleccionada, gris si está vacía
                      color: esLaSeleccionada 
                          ? AppColors.primary 
                          : (estaInspeccionada ? AppColors.success : AppColors.greyLight),
                      width: estaInspeccionada || esLaSeleccionada ? 1.5 : 0.5,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _construirFormulario() {

    final llantaActual = _llantasActualesList
        .where((l) => l.posicion == _indicePosicionSeleccionada)
        .firstOrNull;
        
    final llantaPrevia = _llantasPreviasList
        .where((l) => l.posicion == _indicePosicionSeleccionada)
        .firstOrNull;
        
    final esDatoHeredado = (llantaActual == null) && (llantaPrevia != null);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos de Inspección - Posición $_indicePosicionSeleccionada', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            
            // --- NUEVO INDICADOR VISUAL ---
            if (esDatoHeredado) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.greyLight),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.history, color: AppColors.info, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Datos precargados de la inspección anterior. Edita si es necesario y presiona Guardar.',
                        style: TextStyle(color: AppColors.info, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // ------------------------------

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _codigoCtrl,
                    decoration: const InputDecoration(labelText: 'Código Llanta', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _fechaCtrl,
                    readOnly: true, // Evita que se escriba con el teclado
                    decoration: InputDecoration(
                      labelText: 'Fecha Montaje',
                      border: const OutlineInputBorder(),
                      // Renderizado condicional del ícono
                      suffixIcon: _fechaCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _fechaCtrl.clear(); // Vaciamos el texto
                                });
                              },
                            )
                          : const Icon(Icons.calendar_month),
                    ),
                    onTap: () async {
                      // Abre el selector de fecha nativo
                      DateTime? pickedDate = await showDatePicker(
                        fieldHintText: "Dia/Mes/Año",
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000), // Límite inferior
                        lastDate: DateTime(2100),  // Límite superior
                        keyboardType: TextInputType.text,
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _fechaCtrl.text = pickedDate.toIso8601String().split('T')[0];
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- NUEVOS CAMPOS: KM y Horómetro de Montaje ---
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _kmMontajeCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'KM Montaje', 
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _horoMontajeCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Horómetro Montaje', 
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ------------------------------------------------

            // --- 1. Dimensión y Diseño ---
            Row(
              children: [
                Expanded(
                  child: _construirAutocompleteField(
                    label: 'Dimensión',
                    hintText: 'Ej. 295/80R22.5',
                    externalController: _dimensionCtrl,
                    opciones: _nombresDimensiones,
                    posicion: _indicePosicionSeleccionada,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _construirAutocompleteField(
                    label: 'Diseño',
                    hintText: 'Ej. Direccional',
                    externalController: _disenoCtrl,
                    opciones: _nombresDisenos,
                    posicion: _indicePosicionSeleccionada,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- 2. Marca y Tipo ---
            Row(
              children: [
                Expanded(
                  child: _construirAutocompleteField(
                    label: 'Marca',
                    hintText: 'Ej. Michelin',
                    externalController: _marcaCtrl,
                    opciones: _nombresMarcas,
                    posicion: _indicePosicionSeleccionada,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _construirAutocompleteField(
                    label: 'Tipo',
                    hintText: 'Ej. Nueva, Reencauchada',
                    externalController: _tipoCtrl,
                    opciones: _nombresTipos,
                    posicion: _indicePosicionSeleccionada,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(child: TextFormField(controller: _presionCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Presión (PSI)', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 12),
            
            // Medidas de remanente
            Row(
              children: [
                Expanded(child: TextFormField(controller: _medidaExtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ext', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _medidaCentCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cen', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _medidaIntCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Int', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _obsCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Observaciones', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET AUXILIAR PARA AUTOCOMPLETE
  // ==========================================
  
  Widget _construirAutocompleteField({
    required String label,
    required String hintText,
    required TextEditingController externalController,
    required List<String> opciones,
    required int posicion,
  }) {
    return Autocomplete<String>(
      // La Key asegura que el campo se limpie/recargue al cambiar de llanta (posición)
      key: ValueKey('${label}_$posicion'), 
      initialValue: TextEditingValue(text: externalController.text),
      
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) return opciones;
        return opciones.where((opcion) => 
          opcion.toLowerCase().contains(textEditingValue.text.toLowerCase())
        );
      },
      onSelected: (String seleccion) {
        externalController.text = seleccion;
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.words,
          onChanged: (val) => externalController.text = val, // Sincroniza escritura manual
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            labelStyle: const TextStyle(color: AppColors.greyDark),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.greyDark),
          ),
          // validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
        );
      },
    );
  }

  // ==========================================
  // 5. LÓGICA Y FUNCIONES AUXILIARES
  // ==========================================

  void _actualizarFormularioConLlanta(LlantaInspeccionResumen? llanta) {
    _llantaIdExistente = llanta?.id;
    _codigoCtrl.text = llanta?.codigoLlanta ?? '';
    
    // Si la fecha es null, ponemos string vacío
    _fechaCtrl.text = llanta?.fechaMontaje != null 
        ? llanta!.fechaMontaje!.toIso8601String().split('T')[0] 
        : '';

    // Usamos una función simple para evitar que los null se vuelvan strings
    String valorAString(dynamic valor) => valor?.toString() ?? '';

    _horoMontajeCtrl.text = valorAString(llanta?.horoMontaje);
    _kmMontajeCtrl.text = valorAString(llanta?.kmMontaje);
    _dimensionCtrl.text = llanta?.nombreDimension ?? '';
    _disenoCtrl.text = llanta?.nombreDiseno ?? '';
    _tipoCtrl.text = llanta?.nombreTipo ?? '';
    _marcaCtrl.text = llanta?.nombreMarca ?? '';
    _presionCtrl.text = valorAString(llanta?.presion);
    _medidaIntCtrl.text = valorAString(llanta?.medidaInt);
    _medidaCentCtrl.text = valorAString(llanta?.medidaCent);
    _medidaExtCtrl.text = valorAString(llanta?.medidaExt);
    _obsCtrl.text = llanta?.observacion ?? '';
  }
  
  Future<void> _ejecutarGuardado() async {
    if (!_formKey.currentState!.validate()) return; // Validamos campos requeridos

    try {
      final db = getIt<AppDatabase>();
      final clienteId = widget.vehiculo.clienteId;

      // Helper para convertir texto vacío a null
      String? textoOrNull(TextEditingController ctrl) => 
          ctrl.text.trim().isEmpty ? null : ctrl.text.trim();

      // Helper para convertir texto a double o null si está vacío
      double? doubleOrNull(TextEditingController ctrl) => 
          ctrl.text.trim().isEmpty ? null : double.tryParse(ctrl.text.trim());

      // 1. Limpiamos y preparamos las variables de texto
      final tipoLlantaStr = _tipoCtrl.text.trim().isNotEmpty ? _tipoCtrl.text.trim() : null;
      final marcaLlantaStr = _marcaCtrl.text.trim().isNotEmpty ? _marcaCtrl.text.trim() : null;
      final dimensionLlantaStr = _dimensionCtrl.text.trim().isNotEmpty ? _dimensionCtrl.text.trim() : null;
      final disenoLlantaStr = _disenoCtrl.text.trim().isNotEmpty ? _disenoCtrl.text.trim() : null;

      final fechaMontajeParsed = _fechaCtrl.text.trim().isNotEmpty ? DateTime.parse(_fechaCtrl.text) : null;

      // 2. Verificamos si hay variables nuevas que se vayan a crear
      final variablesNuevas = await db.clienteVariablesDao.verificarNuevasVariables(
        clienteId: clienteId,
        nombreTipoLlanta: tipoLlantaStr,
        nombreMarcaLlanta: marcaLlantaStr,
        nombreDimensionLlanta: dimensionLlantaStr,
        nombreDisenoLlanta: disenoLlantaStr,
      );

      // 3. Si hay variables nuevas, mostramos el modal de confirmación
      if (variablesNuevas.isNotEmpty) {
        if (!mounted) return;
        // Pausamos la ejecución hasta que el usuario responda el diálogo
        final confirmacion = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Obliga a elegir una opción
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.warning),
                  SizedBox(width: 8),
                  Text('Nuevos Registros'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Se crearán los siguientes valores nuevos en la base de datos para este cliente:'),
                  const SizedBox(height: 12),
                  // Listamos las variables nuevas
                  ...variablesNuevas.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('• $v', style: const TextStyle(fontWeight: FontWeight.bold)),
                      )),
                  const SizedBox(height: 12),
                  const Text('¿Estás seguro de que deseas continuar y guardarlos?'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false), // Retorna false
                  child: const Text('Revisar y Cancelar', style: TextStyle(color: AppColors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => Navigator.of(dialogContext).pop(true), // Retorna true
                  child: const Text('Sí, Guardar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );

        // Si el usuario presionó "Cancelar" o cerró el modal de alguna forma, abortamos el guardado
        if (confirmacion != true) {
          return; 
        }
      }

      // 4. Guardado con valores que pueden ser NULL
      await db.inspeccionLlantasDao.guardarLlanta(
        clienteId: clienteId,
        inspeccionId: widget.inspeccionId,
        vehiculoId: widget.vehiculo.vehiculoId,
        codigoLlanta: _codigoCtrl.text.trim(), // El código suele ser obligatorio
        posicion: _indicePosicionSeleccionada,
        fechaMontaje: fechaMontajeParsed,
        horoMontaje: doubleOrNull(_horoMontajeCtrl),
        kmMontaje: doubleOrNull(_kmMontajeCtrl),
        nombreTipo: tipoLlantaStr,
        nombreMarca: marcaLlantaStr,
        nombreDimension: dimensionLlantaStr, 
        nombreDiseno: disenoLlantaStr,       
        presion: doubleOrNull(_presionCtrl),
        medidaExt: doubleOrNull(_medidaExtCtrl),
        medidaCent: doubleOrNull(_medidaCentCtrl),
        medidaInt: doubleOrNull(_medidaIntCtrl),
        observacion: textoOrNull(_obsCtrl),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inspección de llanta guardada correctamente'), 
            backgroundColor: AppColors.success
          ),
        );
        
        // --- NUEVA LÓGICA DE AVANCE AUTOMÁTICO ---
        // Verificamos si aún hay más llantas por inspeccionar
        if (_indicePosicionSeleccionada < widget.vehiculo.noLlantas - 1) {
          final nuevaPosicion = _indicePosicionSeleccionada + 2;
          // Cargamos la siguiente posición automáticamente
          await _cargarDatosParaPosicion(nuevaPosicion);
        } else {
          // Si era la última posición, le avisamos al usuario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Todas las posiciones han sido inspeccionadas!'), 
              backgroundColor: AppColors.info
            ),
          );
        }
        // ----------------------------------------
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _cargarVariables() async {
    final db = getIt<AppDatabase>();
    final clienteId = widget.vehiculo.clienteId; 

    // Obtenemos las entidades desde tu función
    final dimensiones = await db.clienteVariablesDao.getVariablesPorClienteYTipo(clienteId, TipoVariableEnum.DimensionLlanta);
    final disenos = await db.clienteVariablesDao.getVariablesPorClienteYTipo(clienteId, TipoVariableEnum.DisenoLlanta);
    final marcas = await db.clienteVariablesDao.getVariablesPorClienteYTipo(clienteId, TipoVariableEnum.MarcaLlata);
    final tipos = await db.clienteVariablesDao.getVariablesPorClienteYTipo(clienteId, TipoVariableEnum.TipoLlanta);

    // Extraemos solo los nombres (asegurándonos de descartar nulos si los hay)
    setState(() {
      _nombresDimensiones = dimensiones.map((v) => v.nombre).whereType<String>().toList();
      _nombresDisenos = disenos.map((v) => v.nombre).whereType<String>().toList();
      _nombresMarcas = marcas.map((v) => v.nombre).whereType<String>().toList();
      _nombresTipos = tipos.map((v) => v.nombre).whereType<String>().toList();
    });
  }

  Future<void> _cargarLlantasPrevias() async {
    final db = getIt<AppDatabase>();

    final String? actualInspectionID = await db.inspeccionesDao.getInspeccionIdPorIndice(
      clienteId: widget.vehiculo.clienteId,
      index: 0);

    if (actualInspectionID != null) {
      _llantasPreviasList = await db.inspeccionLlantasDao.getHistorialPrevioLlantasVehiculo(
        inspeccionActualId: actualInspectionID,
        vehiculoId: widget.vehiculo.vehiculoId,
      );
    }
  }
}