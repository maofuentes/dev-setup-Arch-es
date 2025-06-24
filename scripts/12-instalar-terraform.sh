#!/usr/bin/env bash
set -e

# Script para instalar Terraform en Ubuntu/WSL
# Autor: Brayan Diaz C
# Fecha: 23 jun 2025

echo "🌍 Iniciando la instalación de Terraform..."

# 1. Actualizar sistema
echo "📦 [1/6] Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

# 2. Instalar dependencias necesarias
echo "🔧 [2/6] Instalando dependencias..."
sudo apt install -y curl gnupg software-properties-common

# 3. Agregar clave GPG oficial de HashiCorp
echo "🔐 [3/6] Añadiendo clave GPG de HashiCorp..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# 4. Añadir repositorio oficial de HashiCorp
echo "➕ [4/6] Añadiendo repositorio de HashiCorp..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# 5. Instalar Terraform
echo "⬇️ [5/6] Instalando Terraform..."
sudo apt update
sudo apt install -y terraform

# 6. Verificar instalación
echo "🔍 [6/6] Verificando instalación..."
terraform -version

echo
echo "🎉 Terraform ha sido instalado correctamente."