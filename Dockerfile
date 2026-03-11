# Folosim o imagine oficială de Python
FROM python:3.11-slim

# Setăm variabile de mediu pentru a evita fișierele .pyc și pentru buffering
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Setăm directorul de lucru în container
WORKDIR /app

COPY . .

# Instalare dependinte
RUN apt-get update && apt-get install python3-dev default-libmysqlclient-dev build-essential pkg-config
RUN pip install django mysqlclient

RUN pip install --upgrade pip
RUN pip install django
