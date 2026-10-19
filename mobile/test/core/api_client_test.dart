import 'dart:convert';

import 'package:inspecciones_llantas/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  setUp(() {
    ApiConfig.baseUrl = 'http://10.0.2.2:8000';
    ApiConfig.apiKey = 'qU95h358WTPcGWzEcPMgt';
  });

  test('GET usa la URL configurada e incluye los headers', () async {
    late http.Request recibida;
    final api = ApiClient(client: MockClient((request) async {
      recibida = request;
      return http.Response('{"status":"healthy"}', 200);
    }));

    final respuesta = await api.get('/health');

    expect(recibida.url.toString(), 'http://10.0.2.2:8000/health');
    expect(recibida.headers['X-API-KEY'], 'qU95h358WTPcGWzEcPMgt');
    expect(recibida.headers['Content-Type'], startsWith('application/json'));
    expect(respuesta, {'status': 'healthy'});
  });

  test('POST serializa el cuerpo como JSON', () async {
    late http.Request recibida;
    final api = ApiClient(client: MockClient((request) async {
      recibida = request;
      return http.Response('{"ok":true}', 200);
    }));

    final respuesta = await api.post('/mobile/sync/send', body: {'clientes': []});

    expect(jsonDecode(recibida.body), {'clientes': []});
    expect(respuesta, {'ok': true});
  });

  test('POST con respuesta vacía retorna null', () async {
    final api = ApiClient(client: MockClient((_) async => http.Response('', 204)));
    expect(await api.post('/algo'), isNull);
  });

  test('un cambio de configuración aplica a las siguientes peticiones', () async {
    final urls = <String>[];
    final api = ApiClient(client: MockClient((request) async {
      urls.add(request.url.toString());
      return http.Response('{}', 200);
    }));

    await api.get('/health');
    ApiConfig.baseUrl = 'http://192.168.1.50:8000';
    await api.get('/health');

    expect(urls, ['http://10.0.2.2:8000/health', 'http://192.168.1.50:8000/health']);
  });

  for (final status in [401, 403, 404, 500]) {
    test('una respuesta $status lanza una excepción con el código', () async {
      final api = ApiClient(client: MockClient((_) async => http.Response('fallo', status)));
      expect(
        () => api.get('/mobile/sync/download'),
        throwsA(predicate((e) => e.toString().contains('HTTP $status'))),
      );
    });
  }
}
