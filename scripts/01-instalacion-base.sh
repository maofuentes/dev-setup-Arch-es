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
#sudo pacman -Rns $(pacman -Qdtq)

# 3. Instalar soporte para sistemas de archivos adicionales
echo "💽 Instalando soporte para sistemas de archivos (exFAT, HFS+, NTFS)..."
sudo pacman -S --needed exfat-utils ntfs-3g

# 4. Reconocimiento de smartphones
echo "📱 Instalando herramientas para reconocimiento de smartphones..."
sudo pacman -S --needed android-file-transfer ifuse libimobiledevice usbmuxd 

# 5. Manejo de archivos comprimidos
echo "📦 Instalando utilidades de compresión (zip, rar, 7z)..."
sudo pacman -S --needed zip unzip unrar 7zip

# 6. Instalar librerías esenciales para desarrollo
echo "🛠️ Instalando librerías de desarrollo..."
sudo pacman -Syu --needed git base-devel curl wget openssl readline gnupg zlib imagemagick libffi postgresql-libs cmake libwebp libyaml sqlite libxml2 libxslt curl libvips ffmpeg poppler mupdf make llvm bzip2 tree ncurses xz tk xmlsec xz python-pyopenssl

echo "✅ ¡Sistema configurado exitosamente!"
echo "🧠 Puedes continuar instalando herramientas específicas desde la carpeta scripts/"
