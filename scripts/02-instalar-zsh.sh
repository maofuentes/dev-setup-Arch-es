#!/usr/bin/bash
set -e

# Script para instalar Oh My Zsh en Ubuntu y WSL
# Autor: Brayan Diaz C
# Fecha: 20 jun 2025

echo "🔧 Iniciando la instalación de Zsh y Oh My Zsh en tu sistema..."

# 1. Actualizar el sistema
echo "📦 Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Instalar Zsh
echo "📥 Instalando Zsh..."
sudo apt install -y zsh

# Verificar instalación
echo "🔍 Verificando versión de Zsh..."
zsh --version

# 3. Verificar e instalar curl
echo "📥 Verificando si curl está instalado..."
sudo apt install -y curl

# 4. Instalar Oh My Zsh
echo "🎩 Instalando Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 5. Mensaje final
echo "✅ Instalación de Oh My Zsh completada con éxito."
echo "💡 Cierra y vuelve a abrir tu terminal para aplicar los cambios."