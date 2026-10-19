# 🧪 Pruebas automatizadas

El proyecto tiene **134 pruebas automatizadas**: 84 en el backend y 50 en la app móvil. Se ejecutan en cada *push* y *pull request* con GitHub Actions ([`.github/workflows/ci.yml`](../.github/workflows/ci.yml)).

| Suite | Herramienta | Pruebas | Servicios externos |
|---|---|---|---|
| Backend (API) | pytest + TestClient de FastAPI | 84 | Ninguno: SQLite temporal y Clerk simulado |
| App móvil | flutter_test | 50 | Ninguno: SQLite en memoria y servidor HTTP simulado |
| Frontend | `tsc` + `vite build` en CI | — | Ninguno |

---

## Backend

### Cómo ejecutarlas

**Con Docker** (sin instalar Python):

```bash
docker compose run --rm --no-deps -v ./csv_files:/csv_files backend python -m pytest
```

> El volumen `csv_files` permite probar también el archivo de ejemplo del repositorio. Sin él, esas 4 pruebas se omiten (*skipped*).

**Con Python local** (3.11+):

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python -m pytest            # todas
python -m pytest -v         # con el nombre de cada prueba
python -m pytest test/test_sync.py -k idempotente   # una prueba concreta
```

Las pruebas **no necesitan PostgreSQL ni conexión a Clerk**. [`conftest.py`](../backend/test/conftest.py):

- configura una base SQLite que se recrea vacía **antes de cada prueba**, para que no dependan del orden de ejecución;
- reemplaza la validación del JWT de Clerk por un usuario simulado;
- define una API Key de prueba para los endpoints móviles.

### Qué prueban

| Archivo | Qué valida |
|---|---|
| `test_seguridad.py` | `/health` es público. Los endpoints web rechazan peticiones sin token o con token inválido (401/403). Los endpoints móviles exigen la `X-API-KEY` correcta. **Regresión**: si `API_KEY_SECRET` no está configurada, una petición sin header no queda autorizada. |
| `test_clientes.py` | Crear, listar, obtener y editar clientes contra la base real. Errores 404, 422 (validación) y 400 (fallo de BD simulado con *mocks*). |
| `test_vehiculos.py` | Al crear un vehículo, el tipo y la marca se registran en el catálogo del cliente. Las variables se reutilizan sin importar mayúsculas o si llegan como UUID. Edición parcial. Un cliente no puede ver ni editar vehículos de otro. |
| `test_inspecciones.py` | **Carga masiva por CSV**: el archivo de pruebas (3 vehículos, 6 llantas) y el de ejemplo del README (8 y 32). Creación de catálogos. Cargar dos veces no duplica vehículos. Separador `;` o `,` y codificación Latin-1. Código autogenerado para llantas sin código. **Rollback** ante un CSV inválido. Vista previa, exportación a Excel (validada leyéndola con Pandas) y *kardex* de flota. |
| `test_sync.py` | Subida desde la app y su reflejo en la web. **Idempotencia** (reenviar el mismo payload no duplica). Rechazo con rollback total si los conteos de integridad no coinciden. Descarga inicial con metadata coherente, descarga incremental vacía y filtro por cliente. |
| `test_helpers.py` | Normalización de fechas (`dd/mm/yyyy`, `dd-mm-yyyy`, `yyyy-mm-dd`, meses abreviados en español e inglés), conversión numérica de celdas del CSV y lógica de catálogos dinámicos. |

### Bugs encontrados al escribir las pruebas

Las pruebas destaparon estos defectos, que ya están corregidos:

1. **Descarga de Excel con nombre acentuado**: una inspección llamada, por ejemplo, "Inspección" hacía fallar la descarga, porque el header `Content-Disposition` no admite caracteres fuera de ASCII. Ahora se envía con `filename*` (RFC 6266).
2. **Códigos de llanta alterados**: si una celda de código venía vacía, Pandas convertía la columna a decimal y `500` se guardaba como `500.0`. Ahora esas columnas se leen como texto.
3. **UUID tratado como texto**: al crear un vehículo enviando el UUID de una marca existente, se creaba una marca nueva cuyo nombre era el propio UUID.
4. **Meses en inglés**: fechas como `26-Apr-23` (Excel en inglés) se descartaban en silencio.
5. **API Key no configurada**: si faltaba `API_KEY_SECRET`, una petición **sin** header pasaba la validación (`None == None`).
6. **Clave con errata** en la respuesta de sincronización (`inspeccion_llantas_processed` → `inspeccion_llantas_procesadas`).

---

## App móvil (Flutter)

### Cómo ejecutarlas

Requiere el [SDK de Flutter](https://docs.flutter.dev/get-started/install) y la librería nativa de SQLite. En Linux viene instalada casi siempre; si no, `sudo apt install libsqlite3-dev`.

```bash
cd mobile
flutter pub get
flutter test                                # todas
flutter test test/services                  # una carpeta
flutter test --name "rollback"              # por nombre
flutter analyze                             # análisis estático (también corre en CI)
```

No hace falta emulador ni dispositivo: las pruebas corren sobre la VM de Dart.

### Estrategia

- **Base de datos real en memoria**: se usa la misma base Drift de la app (`AppDatabase.forTesting`) sobre SQLite en memoria. Así se prueban las consultas SQL reales, incluidos los *joins*, las subconsultas y las funciones de ventana.
- **Servidor simulado**: `MockClient` del paquete `http` intercepta las peticiones. Así se verifica qué envía la app (URL, headers y cuerpo) y cómo reacciona a cada respuesta, sin red.

### Qué prueban

| Archivo | Qué valida |
|---|---|
| `test/models/dto_test.dart` | Lectura del JSON de `/mobile/sync/download`: metadata, conversión de enteros a `double`, fechas, colecciones ausentes y el enum de variables. Lo que viene del servidor **no** queda marcado como pendiente de envío. |
| `test/data/daos_test.dart` | Catálogo de variables: crear, reutilizar sin importar mayúsculas y validación. Una inspección nueva queda `PENDIENTE`. Guardar dos veces la misma posición **actualiza en lugar de duplicar**. Finalizar crea el registro del vehículo si faltaba. Eliminación en cascada. **Historial previo**: trae la medición más reciente por posición, excluyendo la inspección actual. Estadísticas de clientes, avance de llantas y control de la última sincronización. |
| `test/services/sync_service_test.dart` | **Descarga**: guarda los datos y la fecha del servidor, envía la API Key, la siguiente descarga es incremental y, si los conteos no cuadran o hay error HTTP, **no guarda nada** (rollback). **Envío**: solo inspecciones `FINALIZADO`, conteos coherentes, formato esperado por la API (fechas sin hora, timestamps UTC), marca los registros como sincronizados tras el éxito, los mantiene pendientes si el servidor falla y no hace peticiones si no hay nada pendiente. |
| `test/core/api_client_test.dart` | URL y headers (`X-API-KEY`, `Content-Type`), serialización JSON, cambio de servidor en caliente y errores HTTP 401/403/404/500. |
| `test/ui/pantallas_test.dart` | *Widget tests* sobre la base en memoria. Pantalla de clientes: lista, buscador, filtro por sede y estado vacío. Pantalla de inspecciones activas: muestra la inspección con su cliente y estado. |

---

## Integración continua

[`.github/workflows/ci.yml`](../.github/workflows/ci.yml) ejecuta tres trabajos en paralelo:

| Trabajo | Pasos |
|---|---|
| **Backend · pytest** | Python 3.11, `pip install -r requirements.txt`, `pytest -v` |
| **App móvil · analyze + test** | Flutter 3.41 (stable), `flutter pub get`, `flutter analyze`, `flutter test` |
| **Frontend · build** | Node 22, `npm ci`, `npm run build` (verificación de tipos con `tsc` y bundle de Vite) |
