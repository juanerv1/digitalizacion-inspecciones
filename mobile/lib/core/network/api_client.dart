import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  static String baseUrl = 'http://127.0.0.1:8000';
  static String apiKey = 'contrasena';
}

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Helper centralizado para inyectar los headers en todas las peticiones
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-API-KEY': ApiConfig.apiKey, // <-- Inyectamos la API Key desde el config
    };
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _getHeaders(),
    );

    _validateResponse(response);
    return jsonDecode(response.body);
  }

  Future<dynamic> post(
    String path, {
    dynamic body,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );

    _validateResponse(response);

    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}