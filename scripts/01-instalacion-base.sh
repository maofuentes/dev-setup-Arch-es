#!/usr/bin/bash
set -e

# Configurar entorno de desarrollo en Ubuntu/WSL
# Actualizado: 25 jun 2025
# Creador: Brayan Diaz C Modificado por: Marcelo Antonio

# Verificar acceso sudo antes de iniciar
if sudo -v; then
  echo "✅ Acceso con sudo confirmado. Iniciando configuración del entorno..."
else
  echo "❌ No se pudo autenticar con sudo. Ejecuta nuevamente el script e ingresa la contraseña correctamente."
  exit 1
fi

# 1. Actualizar el sistema
echo "📦 Actualizando el sistema..."
sudo pacman -Syu && yay -Syu

# 2. Limpiar el sistema
echo "🧹 Limpiando paquetes y dependencias no utilizadas..."
pacman -Rns $(pacman -Qdtq)

# 3. Instalar soporte para sistemas de archivos adicionales
echo "💽 Instalando soporte para sistemas de archivos (exFAT, HFS+, NTFS)..."
sudo apt install -y exfat-fuse hfsplus hfsutils ntfs-3g

# 4. Reconocimiento de smartphones
echo "📱 Instalando herramientas para reconocimiento de smartphones..."
sudo apt install -y mtp-tools ipheth-utils ideviceinstaller ifuse

# 5. Manejo de archivos comprimidos
echo "📦 Instalando utilidades de compresión (zip, rar, 7z)..."
sudo apt install -y zip unzip unrar p7zip-full

# 6. Instalar librerías esenciales para desarrollo
echo "🛠️ Instalando librerías de desarrollo..."
sudo apt install -y \
git-core build-essential curl wget openssl libssl-dev libreadline-dev \
dirmngr zlib1g-dev libmagickwand-dev imagemagick-6.q16 libffi-dev \
libpq-dev cmake libwebp-dev libyaml-dev libsqlite3-dev sqlite3 \
libxml2-dev libxslt1-dev software-properties-common libcurl4-openssl-dev \
libvips-dev ffmpeg libpoppler-dev mupdf make llvm libbz2-dev tree \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libxmlsec1-dev \
liblzma-dev python3-openssl

echo "✅ ¡Sistema configurado exitosamente!"
echo "🧠 Puedes continuar instalando herramientas específicas desde la carpeta scripts/"
