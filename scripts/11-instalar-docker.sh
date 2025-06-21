#!/bin/bash
set -e

# Script para instalar Docker Engine y Docker Compose en Ubuntu
# Autor: Brayan Diaz C
# Fecha: 21 jun 2025

echo "🐳 Iniciando instalación de Docker y Docker Compose..."

# 1. Eliminar versiones anteriores si existen
echo "📦 [1/8] Eliminando versiones antiguas de Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# 2. Actualizar e instalar dependencias necesarias
echo "🔧 [2/8] Actualizando sistema e instalando dependencias..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. Añadir clave GPG oficial de Docker
echo "🔐 [3/8] Añadiendo clave GPG de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 4. Añadir repositorio oficial de Docker
echo "➕ [4/8] Añadiendo repositorio de Docker a APT..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Instalar Docker Engine y CLI
echo "⬇️ [5/8] Instalando Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. Verificar instalación
echo "🔍 [6/8] Verificando instalación de Docker..."
docker --version
docker compose version

# 7. Agregar el usuario actual al grupo 'docker'
echo "👤 [7/8] Añadiendo el usuario actual al grupo docker..."
sudo usermod -aG docker "$USER"
echo "⚠️ Debes cerrar sesión y volver a iniciarla para usar Docker sin sudo."

# 8. Mensaje final
echo
echo "🎉 Docker y Docker Compose han sido instalados correctamente."
echo "Reinicia tu sesión para aplicar los cambios de grupo."