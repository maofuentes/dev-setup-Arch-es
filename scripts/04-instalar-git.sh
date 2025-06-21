#!/usr/bin/env zsh
set -e

# Script para instalar y configurar Git en Ubuntu/WSL
# Autor: Brayan Diaz C
# Fecha: 21 jun 2025

echo "🔧 Iniciando la instalación y configuración de Git en tu sistema..."

# 1. Actualizar la lista de paquetes
echo "📦 [1/8] Actualizando la lista de paquetes..."
sudo apt update

# 2. Agregar el repositorio PPA de Git
echo "➕ [2/8] Agregando el repositorio PPA de Git para obtener la última versión..."
sudo add-apt-repository ppa:git-core/ppa -y

# 3. Actualizar dependencias
echo "📦 [3/8] Actualizando dependencias tras agregar el repositorio..."
sudo apt update

# 4. Instalar Git
echo "📥 [4/8] Instalando Git..."
sudo apt install -y git

# Verificar instalación
echo "🔍 Verificando instalación de Git..."
git --version

# 5. Configuración básica
echo "⚙️ [5/8] Iniciando configuración global de Git..."

echo "🎨 Habilitando colores en la salida de Git..."
git config --global color.ui true

# 5.1 Configurar nombre
while [[ -z "$git_user_name" ]]; do
  read -p "🧑 Introduce tu nombre de usuario para Git: " git_user_name
done
git config --global user.name "$git_user_name"
echo "✅ Nombre configurado como: $git_user_name"

# 5.2 Configurar correo
while [[ -z "$git_user_email" ]]; do
  read -p "📧 Introduce tu correo electrónico para Git: " git_user_email
done
git config --global user.email "$git_user_email"
echo "✅ Correo configurado como: $git_user_email"

# 5.3 Configurar rama principal
echo "🌿 Estableciendo 'main' como rama principal por defecto..."
git config --global init.defaultBranch main

# 6. Plantilla de mensaje de commit
echo "📝 [6/8] Configuración opcional de plantilla de mensaje de commit..."
read -p "¿Deseas usar una plantilla de mensajes de commit recomendada? (y/n): " usar_plantilla
if [ "$usar_plantilla" = "y" ]; then
    echo "📥 Descargando plantilla desde GitHub..."
    curl -fsSL https://raw.githubusercontent.com/brayandiazc/gitmessage-template-es/main/.gitmessage -o ~/.gitmessage
    git config --global commit.template ~/.gitmessage

    echo "🛠️ Abriendo plantilla con nano para edición opcional..."
    nano ~/.gitmessage
    echo "✅ Plantilla configurada y lista para usar."
else
    echo "❌ Plantilla no configurada. Puedes añadirla manualmente más tarde si lo deseas."
fi

# 7. Mostrar configuración actual
echo "📋 [7/8] Configuración actual de Git:"
git config --list

# 8. Mensaje final
echo "🎉 [8/8] Git ha sido instalado y configurado exitosamente."