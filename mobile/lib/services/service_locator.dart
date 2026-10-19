import 'package:inspecciones_llantas/core/network/api_client.dart';
import 'package:inspecciones_llantas/data/db/app_database.dart';
import 'package:inspecciones_llantas/services/sync_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // 1. Registramos la Base de Datos
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // 2. Registramos el ApiClient (asumiendo que tienes uno)
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // 3. Registramos el SyncService inyectándole las dependencias que ya registramos arriba
  getIt.registerLazySingleton<SyncService>(() => SyncService(
        getIt<AppDatabase>(),
        getIt<ApiClient>(),
      ));
}