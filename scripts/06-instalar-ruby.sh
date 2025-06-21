#!/usr/bin/env zsh
set -e

# Script para instalar y configurar Ruby en Ubuntu con rbenv
# Autor: Brayan Diaz C
# Fecha: 4 dic 2024 (actualizado 20 jun 2025)

echo "💎 Iniciando el proceso de instalación y configuración de Ruby con rbenv..."

# 1. Actualizar sistema y dependencias
echo "📦 [1/10] Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

echo "🔧 Instalando dependencias necesarias para compilar Ruby..."
sudo apt install -y \
git-core curl wget build-essential libssl-dev libreadline-dev \
zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev \
libxslt1-dev libcurl4-openssl-dev software-properties-common \
libffi-dev libgdbm-dev libncurses5-dev automake libtool bison \
libvips imagemagick ffmpeg poppler-utils mupdf mupdf-tools

# 2. Instalar rbenv
if [ -d "$HOME/.rbenv" ]; then
  echo "⚠️ rbenv ya está instalado. Saltando clonación..."
else
  echo "🔄 Clonando el repositorio de rbenv..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
fi

# 3. Detectar shell y archivo de configuración
user_shell=$(basename "$SHELL")

case "$user_shell" in
  bash)
    shell_config_file="$HOME/.bashrc"
    ;;
  zsh)
    shell_config_file="$HOME/.zshrc"
    ;;
  *)
    echo "⚠️ Shell '$user_shell' no reconocida automáticamente."
    echo "Agrega manualmente estas líneas a tu archivo de configuración:"
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
    echo 'eval "$(rbenv init -)"'
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"'
    shell_config_file=""
    ;;
esac

# 4. Escribir configuración de entorno si se reconoce la shell
if [[ -n "$shell_config_file" ]]; then
  echo "🧩 [2/10] Agregando configuración de rbenv a $shell_config_file"
  {
    echo ''
    echo '# Configuración de rbenv'
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
    echo 'eval "$(rbenv init -)"'
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"'
  } >> "$shell_config_file"
fi

# 5. Aplicar configuración (solo si es posible)
echo "🔄 [3/10] Intentando aplicar la configuración de entorno..."
if [[ "$user_shell" == "zsh" && -f "$HOME/.zshrc" ]]; then
  source ~/.zshrc || echo "⚠️ No se pudo recargar. Cierra y abre tu terminal."
elif [[ "$user_shell" == "bash" && -f "$HOME/.bashrc" ]]; then
  source ~/.bashrc || echo "⚠️ No se pudo recargar. Cierra y abre tu terminal."
fi

# 6. Instalar ruby-build
echo "🔧 [4/10] Instalando ruby-build para rbenv..."
if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
else
  echo "✅ ruby-build ya está instalado."
fi

# 7. Mostrar versiones disponibles
echo "📜 [5/10] Estas son las versiones de Ruby disponibles:"
rbenv install --list

# 8. Solicitar versión con opción por defecto automática
echo
ruby_latest=$(rbenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
read -p "👉 ¿Qué versión de Ruby deseas instalar? (ENTER para instalar la última versión estable: $ruby_latest): " ruby_version

if [[ -z "$ruby_version" ]]; then
  ruby_version=$ruby_latest
  echo "🔁 No se ingresó ninguna versión. Se instalará la última versión estable: $ruby_version"
else
  echo "📥 Se instalará Ruby $ruby_version según tu elección."
fi

# 9. Instalar la versión seleccionada
echo "⬇️ [6/10] Instalando Ruby $ruby_version..."
rbenv install "$ruby_version"
rbenv global "$ruby_version"

# 10. Verificar instalación
echo "🔍 [7/10] Verificando instalación de Ruby..."
ruby -v

# 11. Instalar Bundler y actualizar RubyGems
echo "📦 [8/10] Instalando Bundler..."
gem install bundler

echo "🔁 [9/10] Actualizando RubyGems..."
gem update --system

# 12. Instrucciones futuras
echo "🛠️ [10/10] Para actualizar rbenv y ruby-build en el futuro:"
echo "cd ~/.rbenv && git pull"
echo "cd \"\$(rbenv root)/plugins/ruby-build\" && git pull"

echo
echo "🎉 Ruby $ruby_version ha sido instalado y configurado exitosamente con rbenv."