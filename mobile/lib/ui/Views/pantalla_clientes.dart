import 'dart:async';

import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/models/entities.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/modal_sincronizacion.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_detalle_cliente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';



class PantallaClientes extends StatefulWidget {
  const PantallaClientes({super.key });

  @override
  State<PantallaClientes> createState() => _PantallaClientesState();
}

class _PantallaClientesState extends State<PantallaClientes> {
  StreamSubscription<List<ClienteResumen>>? _clientesSubscription;

  List<ClienteResumen> _todosLosClientes = [];
  bool _isLoading = true; // Empezamos en true directamente
  String _terminoBusqueda = '';
  String _sedeSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    // 2. Iniciamos la escucha reactiva al cargar la pantalla
    _escucharClientes();
  }

  void _escucharClientes() {
    _clientesSubscription = getIt<AppDatabase>()
        .clienteDao
        .watchClientesConEstadisticas()
        .listen(
          (datos) {
        setState(() {
          _todosLosClientes = datos;
          _isLoading = false; // Se apaga tras recibir el primer disparo de la BD
        });
      },
      onError: (e) {
        debugPrint('Error en tiempo real de clientes: $e');
        setState(() => _isLoading = false);
      },
    );
  }

  @override
  void dispose() {
    // 3. OBLIGATORIO: Cancelamos la suscripción para evitar fugas de memoria
    _clientesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- LÓGICA DE FILTRADO COMBINADA ---
    final clientesFiltrados = _todosLosClientes.where((cliente) {

      // 1. Filtro de Sede (Extrayendo la sede directamente del nombre)
      bool coincideSede = _sedeSeleccionada == 'Todas';

      if (!coincideSede) {
        // Dividimos el nombre por los guiones (ej: ['Ingenio Demo', ' Valle'])
        final partesNombre = cliente.nombre.split('-');

        if (partesNombre.isNotEmpty) {
          // Tomamos la última parte, quitamos espacios y pasamos a minúsculas
          final sedeExtraida = partesNombre.last.trim().toLowerCase();
          coincideSede = sedeExtraida == _sedeSeleccionada.toLowerCase();
        }
      }

      // 2. Filtro de Búsqueda por Texto (Únicamente por Nombre)
      final termino = _terminoBusqueda.toLowerCase();
      bool coincideTexto = cliente.nombre.toLowerCase().contains(termino);

      return coincideSede && coincideTexto;
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Directorio de Clientes'),
          centerTitle: false,
         
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Barra de Búsqueda
          _construirBarraBusqueda(
            hintText: 'Buscar por nombre...',
            onChanged: (valor) => setState(() => _terminoBusqueda = valor),
          ),

          // 2. Filtros de Sede
          _construirFiltrosAvanzados(),

          
          // 3. Lista de Clientes
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : clientesFiltrados.isEmpty
                ? const Center(child: Text('No se encontraron clientes con esos filtros.'))
                : ListView.builder(
              itemCount: clientesFiltrados.length,
              itemBuilder: (context, index) {
                final cliente = clientesFiltrados[index];
                final fechaUltima = cliente.ultimaInspeccion != null
                    ? DateFormat('dd MMM yyyy').format(cliente.ultimaInspeccion!)
                    : 'Nunca';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryTint,
                      foregroundColor: AppColors.primary,
                      child: Text(
                        cliente.nombre.isNotEmpty ? cliente.nombre.substring(0, 1).toUpperCase() : '?',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    title: Text(cliente.nombre, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                    subtitle: Text('Flota: ${cliente.cantidadVehiculos} veh. | Inspecciones: ${cliente.cantidadInspecciones}\nÚltima: $fechaUltima'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaDetalleCliente(
                            cliente: cliente,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.sync),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return const ModalSincronizacion();
            },
          );
        },
      ),
    );
  }

  Widget _construirFiltrosAvanzados() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips horizontales para filtrar por SEDE
          const Text('Sede', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.greyDark)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todas', 'Valle', 'Bogotá', 'Medellín'].map((sede) {
                final isSelected = _sedeSeleccionada == sede;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: ChoiceChip(
                    label: Text(sede),
                    selected: isSelected,
                                        onSelected: (selected) {
                      if (selected) {
                        setState(() => _sedeSeleccionada = sede);
                      }
                    },
                  ),
                );
              }).toList(),
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