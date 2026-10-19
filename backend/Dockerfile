# 1. Usamos una imagen ligera de Python
FROM python:3.11-slim

# 2. Directorio de trabajo
WORKDIR /app

# 3. Instalamos dependencias del sistema necesarias para Postgres
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# 4. Copiamos e instalamos librerías
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiamos el código
# Aquí actúa el .dockerignore: NO se copiarán ni los tests ni el compose
COPY . .

# 7. Exponer puerto para Render
EXPOSE 8000

# 8. Comando de inicio
# Esto ejecutará migraciones y luego levantará la API
CMD ["sh", "-c", "alembic upgrade head && uvicorn main:app --host 0.0.0.0 --port 8000"]