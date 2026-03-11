# Folosim o imagine oficială de Python
FROM python:3.11-slim

# Setăm variabile de mediu pentru a evita fișierele .pyc și pentru buffering
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Setăm directorul de lucru în container
WORKDIR /app

# Instalăm dependențele sistemului necesare pentru psycopg2 (driverul de Postgres)
RUN apt-get update && apt-get install -y libpq-dev gcc

RUN pip install --upgrade pip
RUN pip install django
