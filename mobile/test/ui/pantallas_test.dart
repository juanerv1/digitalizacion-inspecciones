import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_clientes.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspecciones_pendientes.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = crearBaseDeDatosEnMemoria();
    await getIt.reset();
    getIt.registerSingleton<AppDatabase>(db);
  });

  tearDown(() async {
    await db.close();
    await getIt.reset();
  });

  Future<void> mostrar(WidgetTester tester, Widget pantalla) async {
    await tester.pumpWidget(MaterialApp(home: pantalla));
    // Drift entrega los datos de forma asíncrona: dejamos correr las consultas reales
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
  }

  Future<void> desmontar(WidgetTester tester) async {
    // Cancela las suscripciones de Drift antes de cerrar la base de datos
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
  }

  group('Pantalla de clientes', () {
    Future<void> sembrarClientes() async {
      await sembrarCliente(db, 'c1', 'Ingenio Demo - Valle');
      await sembrarCliente(db, 'c2', 'Agrícola Ejemplo - Bogota');
      await sembrarCliente(db, 'c3', 'Finca Modelo - Medellin');
    }

    testWidgets('lista los clientes de la base local', (tester) async {
      await tester.runAsync(sembrarClientes);
      await mostrar(tester, const PantallaClientes());

      expect(find.text('Ingenio Demo - Valle'), findsOneWidget);
      expect(find.text('Agrícola Ejemplo - Bogota'), findsOneWidget);
      expect(find.text('Finca Modelo - Medellin'), findsOneWidget);
      await desmontar(tester);
    });

    testWidgets('el buscador filtra por nombre', (tester) async {
      await tester.runAsync(sembrarClientes);
      await mostrar(tester, const PantallaClientes());

      await tester.enterText(find.byType(TextField), 'finca');
      await tester.pump();

      expect(find.text('Finca Modelo - Medellin'), findsOneWidget);
      expect(find.text('Ingenio Demo - Valle'), findsNothing);
      await desmontar(tester);
    });

    testWidgets('el filtro de sede usa el sufijo del nombre', (tester) async {
      await tester.runAsync(sembrarClientes);
      await mostrar(tester, const PantallaClientes());

      await tester.tap(find.widgetWithText(ChoiceChip, 'Valle'));
      await tester.pump();

      expect(find.text('Ingenio Demo - Valle'), findsOneWidget);
      expect(find.text('Agrícola Ejemplo - Bogota'), findsNothing);
      await desmontar(tester);
    });

    testWidgets('muestra un mensaje cuando no hay clientes', (tester) async {
      await mostrar(tester, const PantallaClientes());
      expect(find.text('No se encontraron clientes con esos filtros.'), findsOneWidget);
      await desmontar(tester);
    });
  });

  group('Pantalla de inspecciones activas', () {
    testWidgets('muestra las inspecciones pendientes con su cliente', (tester) async {
      await tester.runAsync(() async {
        final base = await sembrarClienteYVehiculo(db);
        await db.inspeccionesDao.crearNuevaInspeccion(
            clienteId: base.clienteId, nombre: 'Ronda de mayo', fechaInspeccion: DateTime(2026, 5, 10));
      });
      await mostrar(tester, const PantallaInspecciones());

      expect(find.text('Ronda de mayo'), findsOneWidget);
      expect(find.text('Cliente: Cliente Demo - Valle'), findsOneWidget);
      expect(find.text('PENDIENTE'), findsOneWidget);
      await desmontar(tester);
    });

    testWidgets('sin inspecciones activas muestra el estado vacío', (tester) async {
      await mostrar(tester, const PantallaInspecciones());
      expect(find.text('No hay inspecciones para mostrar.'), findsOneWidget);
      await desmontar(tester);
    });
  });
}

Future<void> sembrarCliente(AppDatabase db, String id, String nombre) {
  return db.clienteDao.upsert(ClientesCompanion(id: Value(id), nombre: Value(nombre)));
}
