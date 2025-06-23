#!/usr/bin/env zsh
set -e

# Script para instalar y configurar Ruby en Ubuntu con rbenv
# Autor: Brayan Diaz C
# Fecha: 4 dic 2024 (actualizado 20 jun 2025)

echo "💎 Iniciando el proceso de instalación y configuración de Ruby con rbenv..."

# Función reutilizable para leer entradas compatible con zsh y bash
read_prompt() {
  local __msg="$1"
  local __varname="$2"
  if [[ -n "$ZSH_VERSION" ]]; then
    echo -n "$__msg"
    read "$__varname"
  else
    read -p "$__msg" "$__varname"
  fi
}

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

# 3. Configurar entorno en .bashrc, .zshrc, .profile y .zprofile
echo "🧩 [2/10] Añadiendo configuración a los archivos de entorno..."

for config_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.zprofile"; do
  if [ ! -f "$config_file" ]; then
    touch "$config_file"
  fi
  if ! grep -q 'rbenv init' "$config_file"; then
    {
      echo ''
      echo '# Configuración de rbenv'
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
      echo 'eval "$(rbenv init -)"'
      echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"'
    } >> "$config_file"
    echo "✅ Configuración añadida en $config_file"
  else
    echo "ℹ️ $config_file ya contiene configuración de rbenv. Saltando."
  fi
done

# 4. Aplicar configuración temporal
echo "🔄 [3/10] Aplicando configuración temporal..."
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# 5. Instalar ruby-build
echo "🔧 [4/10] Instalando ruby-build para rbenv..."
if [ ! -d "$(rbenv root)/plugins/ruby-build" ]; then
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
else
  echo "✅ ruby-build ya está instalado."
fi

# 6. Mostrar versiones disponibles
echo "📜 [5/10] Estas son las versiones de Ruby disponibles:"
rbenv install --list

# 7. Solicitar versión con opción por defecto automática
echo
ruby_latest=$(rbenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
read_prompt "👉 ¿Qué versión de Ruby deseas instalar? (ENTER para instalar la última versión estable: $ruby_latest): " ruby_version

if [[ -z "$ruby_version" ]]; then
  ruby_version=$ruby_latest
  echo "🔁 No se ingresó ninguna versión. Se instalará: $ruby_version"
else
  echo "📥 Se instalará Ruby $ruby_version según tu elección."
fi

# 8. Instalar la versión seleccionada
echo "⬇️ [6/10] Instalando Ruby $ruby_version..."
rbenv install "$ruby_version"
rbenv global "$ruby_version"

# 9. Verificar instalación
echo "🔍 [7/10] Verificando instalación de Ruby..."
ruby -v

# 10. Instalar Bundler y actualizar RubyGems
echo "📦 [8/10] Instalando Bundler..."
gem install bundler

echo "🔁 [9/10] Actualizando RubyGems..."
gem update --system

# 11. Instrucciones futuras
echo "🛠️ [10/10] Para actualizar rbenv y ruby-build en el futuro:"
echo "cd ~/.rbenv && git pull"
echo "cd \"\$(rbenv root)/plugins/ruby-build\" && git pull"

echo
echo "🎉 Ruby $ruby_version ha sido instalado y configurado exitosamente con rbenv."