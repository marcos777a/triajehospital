# Usamos una imagen oficial de Python ligera
FROM python:3.11-slim

# Instalamos SWI-Prolog en el contenedor
RUN apt-get update && \
    apt-get install -y swi-prolog && \
    rm -rf /var/lib/apt/lists/*

# Establecemos el directorio de trabajo
WORKDIR /app

# Copiamos los archivos de requerimientos (puedes crear un requirements.txt con: fastapi uvicorn pyswip)
# O instalamos directamente las dependencias
RUN pip install --no-cache-dir fastapi uvicorn pyswip

# Copiamos todo el código fuente (api.py, triaje.pl, triaje.html, estilos.css) al contenedor
COPY . /app/

# Exponemos el puerto que usará Uvicorn
EXPOSE 8000

# Comando para iniciar la aplicación cuando el contenedor arranque
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
