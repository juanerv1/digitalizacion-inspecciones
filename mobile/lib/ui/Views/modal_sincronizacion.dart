import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:inspecciones_llantas/core/network/api_client.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:inspecciones_llantas/config/api_config.dart';

class ModalSincronizacion extends StatefulWidget {
  const ModalSincronizacion({super.key});

  @override
  State<ModalSincronizacion> createState() => _ModalSincronizacionState();
}

class _ModalSincronizacionState extends State<ModalSincronizacion> {
  bool _isLoading = false;
  String _statusMessage = 'Presiona el botón para sincronizar datos con el servidor.';

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _urlController.text = prefs.getString('baseUrl') ?? ApiConfig.baseUrl;
      _apiKeyController.text = prefs.getString('apiKey') ?? ApiConfig.apiKey;
    });
  }

  Future<void> _guardarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    final newUrl = _urlController.text.trim();
    final newApiKey = _apiKeyController.text.trim();

    await prefs.setString('baseUrl', newUrl);
    await prefs.setString('apiKey', newApiKey);

    ApiConfig.baseUrl = newUrl;
    ApiConfig.apiKey = newApiKey;
  }

  Future<void> _runSync() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _statusMessage = 'Guardando configuración y conectando...';
    });

    await _guardarConfiguracion();

    const int maxIntentos = 3;
    int intentoActual = 0;
    bool syncExitosa = false;

    while (intentoActual < maxIntentos && !syncExitosa) {
      intentoActual++;
      
      try {
        if (intentoActual > 1) {
          setState(() {
            _statusMessage = '🔄 Intento $intentoActual de $maxIntentos...\nReconectando con el servidor...';
          });
        }

        setState(() => _statusMessage = 'Subiendo datos locales al servidor... ${intentoActual > 1 ? "(Intento $intentoActual)" : ""}');
        await getIt<SyncService>().enviarDatosAlServidor(); 
        
        setState(() => _statusMessage = 'Descargando datos del servidor... ${intentoActual > 1 ? "(Intento $intentoActual)" : ""}');
        await getIt<SyncService>().syncPull();
        
        syncExitosa = true;
        setState(() {
          _statusMessage = '¡Sincronización completada con éxito! ✅';
        });

      } catch (e) {
        debugPrint('Fallo en el intento $intentoActual: $e');

        if (intentoActual < maxIntentos) {
          final segundosEspera = intentoActual * 2; 
          
          setState(() {
            _statusMessage = '⚠️ Falló el intento $intentoActual.\nReintentando automáticamente en $segundosEspera segundos...';
          });

          await Future.delayed(Duration(seconds: segundosEspera));
        } else {
          setState(() {
            _statusMessage = '❌ Error de conexión persistente.\nPor favor, verifica tu señal y reintenta más tarde.';
          });
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la altura del teclado para evitar que tape los inputs
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      // Padding dinámico: agrega el espacio del teclado en la parte inferior
      padding: EdgeInsets.only(
        bottom: bottomInset + 24.0, // 24 de margen extra + el tamaño del teclado
        left: 24.0,
        right: 24.0,
        top: 16.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pequeña barra visual (Drag Handle)
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            
            // Título que reemplaza el AppBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sincronización',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context), // Cierra el modal
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Icon(
              Icons.cloud_sync_outlined,
              size: 60,
              color: _isLoading ? AppColors.info : AppColors.grey,
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL del Servidor',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key / Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),

            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runSync,
              icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync),
              label: Text(_isLoading ? 'Sincronizando...' : 'Iniciar Sincronización'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}