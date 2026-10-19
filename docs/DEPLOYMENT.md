# 🚢 Guía de instalación y despliegue

Esta guía explica paso a paso cómo levantar el sistema completo en tu máquina y conectar la app Android al servidor local.

**Contenido**

1. [Requisitos previos](#1-requisitos-previos)
2. [Levantar los servicios con Docker Compose](#2-levantar-los-servicios-con-docker-compose)
3. [Acceder a la plataforma web](#3-acceder-a-la-plataforma-web)
4. [Carga inicial de datos con CSV](#4-carga-inicial-de-datos-con-csv)
5. [Instalar la app Android (APK)](#5-instalar-la-app-android-apk)
6. [Conectar la app con la API](#6-conectar-la-app-con-la-api)
7. [Solución de problemas](#7-solución-de-problemas)
8. [Compilar el APK desde el código (opcional)](#8-compilar-el-apk-desde-el-código-opcional)

---

## 1. Requisitos previos

| Herramienta | Versión sugerida | Uso |
|---|---|---|
| [Git](https://git-scm.com/) | cualquiera reciente | Clonar el repositorio |
| [Docker](https://docs.docker.com/get-docker/) | 24+ | Ejecutar los contenedores |
| Docker Compose | v2 (`docker compose`) | Orquestar los servicios |
| Dispositivo **Android** o emulador | Android 7.0+ | Probar la app móvil |

> No necesitas Python, Node.js ni Flutter instalados: el backend, la base de datos y el frontend corren dentro de Docker, y la app se instala con el APK ya compilado.

---

## 2. Levantar los servicios con Docker Compose

### 2.1 Clonar el repositorio

```bash
git clone https://github.com/juanerv1/digitalizacion-inspecciones.git
cd digitalizacion-inspecciones
```

### 2.2 Configurar las variables de entorno

El repositorio incluye un archivo `.env.example` con valores de demostración listos para usar:

```bash
cp .env.example .env
```

| Variable | Descripción | Valor de demostración |
|---|---|---|
| `DB_USER` / `DB_PASSWORD` / `DB_NAME` | Credenciales de PostgreSQL | `user` / `password` / `digitacion_bd` |
| `DATABASE_URL` | Cadena de conexión que usan la API y Alembic | `postgresql://...@database:5432/...` |
| `API_KEY_SECRET` | Llave que la app móvil envía en el header `X-API-KEY` | `qU95h358WTPcGWzEcPMgt` |
| `FRONTEND_URL` | Origen permitido por CORS | `http://localhost:5173` |
| `VITE_CLERK_PUBLISHABLE_KEY` | Llave pública de Clerk para el login web | instancia de demostración |
| `CLERK_ISSUER` | Emisor de Clerk con el que la API valida los tokens JWT | instancia de demostración |

### 2.3 Iniciar los contenedores

```bash
docker compose up -d
```

En el primer arranque, Docker:

1. Descarga la imagen de **PostgreSQL 16** y espera a que la base de datos esté saludable (*healthcheck*).
2. Construye la imagen del **backend**, ejecuta las migraciones (`alembic upgrade head`) y arranca **Uvicorn** en el puerto `8000`.
3. Instala las dependencias del **frontend** (`npm install`) y arranca el servidor de Vite en el puerto `5173`.

> ⏱️ El primer arranque puede tardar unos minutos por la descarga de imágenes y dependencias. Los siguientes son casi inmediatos.

### 2.4 Verificar el estado

```bash
docker compose ps
```

Deberías ver los tres contenedores en estado `running`, y la base de datos como `healthy`:

| Contenedor | Puerto | Descripción |
|---|---|---|
| `digitacionDatabase` | `2000 → 5432` | PostgreSQL |
| `digitacionBackend` | `8000` | API FastAPI |
| `digitacionFrontend` | `5173` | Plataforma web |

Comprueba que la API responde:

```bash
curl http://localhost:8000/health
# {"status":"healthy"}
```

También puedes explorar la documentación interactiva de la API en **http://localhost:8000/docs**.

Para ver los logs de un servicio:

```bash
docker compose logs -f backend
```

### 2.5 Detener los servicios

```bash
docker compose down        # Detiene los contenedores y conserva los datos
docker compose down -v     # Detiene y BORRA la base de datos (reinicio limpio)
```

---

## 3. Acceder a la plataforma web

1. Abre **http://localhost:5173** en el navegador.
2. Inicia sesión con las credenciales de demostración:

   | Campo | Valor |
   |---|---|
   | Usuario | `invitado` |
   | Contraseña | `digitalizacion_password_2026` |

3. Al entrar verás el panel con la lista de clientes a la izquierda (vacía en una instalación nueva).

> La autenticación la gestiona **Clerk**. El frontend obtiene un token JWT de la sesión y lo envía en el header `Authorization: Bearer <token>`. La API lo valida contra las llaves públicas (JWKS) de la instancia configurada en `CLERK_ISSUER`.

---

## 4. Carga inicial de datos con CSV

Al instalarse, la app móvil no tiene datos. El flujo previsto es que el personal administrativo **cargue desde la web** los clientes y la última inspección de cada uno, para que los inspectores tengan el historial de cada equipo en campo.

### 4.1 Crear un cliente

1. En la barra lateral, pulsa **"Crear Cliente"**.
2. Escribe el nombre y elige una **sede**. El cliente queda registrado como `Nombre - Sede`.

### 4.2 Subir la inspección

1. Selecciona el cliente en la barra lateral.
2. En el panel de inspecciones, pulsa **"Subir Inspección"**.
3. Completa el formulario:
   - **Nombre** (opcional), por ejemplo `Inspección inicial`.
   - **Fecha de revisión**.
   - **Archivo CSV**: usa el archivo de prueba incluido en el repositorio:

     📄 **[`csv_files/ejemplo_inspeccion.csv`](../csv_files/ejemplo_inspeccion.csv)**

4. Confirma la carga. El archivo de ejemplo crea **8 vehículos y 32 llantas** con datos ficticios.
5. Pulsa sobre la inspección para ver la **vista previa** o descargarla en **Excel**. Con **"Descargar Kardex de Flota"** obtienes el reporte consolidado del cliente.

### 4.3 Formato del CSV

El archivo tiene una fila por llanta. La API detecta el separador automáticamente (`;` o `,`) y acepta UTF-8 o Latin-1.

| Columna | Tipo | Descripción |
|---|---|---|
| `Equipo` | texto | Código del vehículo o equipo |
| `Tipo Equipo` | texto | Ej.: Montacargas, Cargador frontal |
| `Marca Equipo` | texto | Marca y modelo del equipo |
| `Posicion` | entero | Posición de la llanta (1..N). El máximo define el número de llantas del equipo |
| `Codigo Llanta` | texto | Código de la llanta (`-` si no tiene, en cuyo caso se genera uno) |
| `Tipo Llanta` | texto | Clasificación de la llanta, ej.: `N`, `R` |
| `Dimension` | texto | Ej.: `28X9-15`, `6.50-10` |
| `Diseno` | texto | Diseño o labrado |
| `Marca` | texto | Marca de la llanta |
| `Fecha de Montaje` | fecha | `dd/mm/yyyy`, `dd-mm-yyyy`, `yyyy-mm-dd` o `dd-mmm-yy` |
| `Horo Montaje` / `Km Montaje` | número | Horómetro y kilometraje al montar la llanta |
| `Kilometraje` / `Horometro` | número | Lectura actual del equipo |
| `Ext` / `Cen` / `Int` | número | Profundidad de labrado: exterior, centro e interior |
| `PSI` | número | Presión de inflado |
| `Observaciones` | texto | Notas libres |

> Los valores `-` o vacíos se interpretan como nulos. Las marcas, tipos, diseños y dimensiones nuevas se registran automáticamente como catálogos del cliente.

---

## 5. Instalar la app Android (APK)

### 5.1 Descargar el APK

Descarga el archivo `.apk` más reciente desde la sección **[Releases](https://github.com/juanerv1/digitalizacion-inspecciones/releases)** del repositorio.

### 5.2 Instalarlo en el dispositivo

1. Copia el `.apk` al teléfono (por cable, correo, Drive, etc.) o descárgalo directamente desde el navegador del teléfono.
2. Abre el archivo. Android te pedirá permiso para **instalar aplicaciones de fuentes desconocidas**:
   - *Ajustes → Aplicaciones → [navegador o gestor de archivos] → Instalar apps desconocidas → Permitir*.
3. Confirma la instalación y abre **DigitacionApp**.

> 💡 **Emulador**: si usas el emulador de Android Studio, basta con arrastrar el `.apk` sobre la ventana del emulador. También puedes usar `adb install app-release.apk`.

---

## 6. Conectar la app con la API

La app se comunica con la API mediante dos endpoints protegidos con **API Key**:

| Método | Endpoint | Función |
|---|---|---|
| `GET` | `/mobile/sync/download` | Descarga clientes, vehículos e historial de inspecciones |
| `POST` | `/mobile/sync/send` | Envía las inspecciones finalizadas en campo |

### 6.1 Identificar la URL del servidor

El teléfono necesita llegar al puerto `8000` de la máquina que corre Docker. **`localhost` no sirve desde el teléfono**, porque ahí `localhost` es el propio teléfono.

| Dónde corre la app | URL a configurar |
|---|---|
| Emulador de Android Studio | `http://10.0.2.2:8000` |
| Teléfono físico en la misma red Wi-Fi | `http://<IP-de-tu-PC>:8000` |
| Escritorio Linux en la misma máquina | `http://localhost:8000` |

Para conocer la IP local de tu PC:

```bash
# Linux
hostname -I
# macOS
ipconfig getifaddr en0
# Windows (PowerShell)
ipconfig   # busca "Dirección IPv4"
```

Puedes verificar la conexión abriendo `http://<IP-de-tu-PC>:8000/health` en el navegador del teléfono.

### 6.2 Configurar la app

1. Abre la pestaña **Clientes**.
2. Pulsa el botón flotante de **sincronización** (🔄).
3. En el panel de sincronización, completa:

   | Campo | Valor |
   |---|---|
   | URL del Servidor | la URL de la tabla anterior, ej. `http://192.168.1.50:8000` |
   | API Key / Contraseña | `qU95h358WTPcGWzEcPMgt` |

4. Pulsa **"Iniciar Sincronización"**. La URL y la API Key se guardan en el dispositivo antes de sincronizar, así que solo hay que escribirlas la primera vez.

Al sincronizar, la app **primero envía** las inspecciones finalizadas que tenga pendientes y **después descarga** los cambios del servidor. Tras la primera sincronización, el cliente creado en la web y su historial aparecen en la app.

### 6.3 Cómo se envía la API Key

La app agrega la llave en el header `X-API-KEY` de todas las peticiones (`mobile/lib/core/network/api_client.dart`):

```dart
Map<String, String> _getHeaders() {
  return {
    'Content-Type': 'application/json',
    'X-API-KEY': ApiConfig.apiKey,
  };
}
```

La API la compara con la variable `API_KEY_SECRET` (`backend/api/security.py`). Si no coincide, responde `403 Forbidden`.

Para probar el endpoint manualmente:

```bash
curl -H "X-API-KEY: qU95h358WTPcGWzEcPMgt" \
     "http://localhost:8000/mobile/sync/download"
```

---

## 7. Solución de problemas

| Síntoma | Causa probable | Solución |
|---|---|---|
| La web muestra `401 Unauthorized` al cargar clientes | `CLERK_ISSUER` no corresponde a la instancia de `VITE_CLERK_PUBLISHABLE_KEY` | Revisa ambas variables en `.env` y ejecuta `docker compose up -d --force-recreate` |
| La app muestra `HTTP 403` al sincronizar | API Key incorrecta | Verifica que coincida con `API_KEY_SECRET` |
| La app no conecta (timeout) desde el teléfono | Se usó `localhost`, la red es distinta o hay un firewall | Usa la IP de la PC, confirma que ambos están en la misma red y abre el puerto `8000` en el firewall |
| El backend se reinicia en bucle | La base de datos aún no estaba lista, o el `.env` está incompleto | Revisa `docker compose logs backend` |
| El puerto `5173`, `8000` o `2000` ya está en uso | Otro proceso ocupa el puerto | Cambia el puerto publicado en `docker-compose.yml` |
| Quiero empezar desde cero | — | `docker compose down -v && docker compose up -d` |

En Linux con firewalld (Fedora, por ejemplo), para permitir el acceso desde el teléfono:

```bash
sudo firewall-cmd --add-port=8000/tcp
```

---

## 8. Compilar el APK desde el código (opcional)

Solo hace falta si quieres modificar la app. Requiere el [SDK de Flutter](https://docs.flutter.dev/get-started/install) (Dart `^3.8`) y el SDK de Android.

```bash
cd mobile
flutter pub get
flutter build apk --release
# Resultado: build/app/outputs/flutter-apk/app-release.apk
```

Para ejecutarla en modo desarrollo en un dispositivo conectado o en escritorio Linux:

```bash
flutter run
```

> La app permite tráfico HTTP sin cifrar (`usesCleartextTraffic`) para facilitar las pruebas contra el servidor local. En producción debe usarse HTTPS.
