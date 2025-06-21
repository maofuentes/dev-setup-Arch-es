#!/usr/bin/env zsh
set -e

# Script para instalar y configurar Node.js en Ubuntu con nodenv
# Autor: Brayan Diaz C
# Fecha: 27 nov 2024 (actualizado 21 jun 2025)

echo "🟢 Iniciando el proceso de instalación y configuración de Node.js con nodenv..."

# Función de lectura compatible con Zsh y Bash
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

# 1. Instalar dependencias necesarias
echo "📦 [1/10] Instalando dependencias necesarias..."
sudo apt update && sudo apt install -y \
git-core curl build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev \
libncurses5-dev libffi-dev liblzma-dev libgdbm-dev \
libnss3-dev libtool libyaml-dev pkg-config \
autoconf automake

# 2. Instalar nodenv
if [ -d "$HOME/.nodenv" ]; then
  echo "⚠️ nodenv ya está instalado. Saltando clonación..."
else
  echo "🔄 Clonando el repositorio de nodenv..."
  git clone https://github.com/nodenv/nodenv.git ~/.nodenv
fi

# 3. Detectar shell del usuario
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
    echo 'export PATH="$HOME/.nodenv/bin:$PATH"'
    echo 'eval "$(nodenv init -)"'
    echo 'export PATH="$HOME/.nodenv/plugins/node-build/bin:$PATH"'
    shell_config_file=""
    ;;
esac

# 4. Escribir configuración en el archivo correspondiente
if [[ -n "$shell_config_file" ]]; then
  echo "🧩 [2/10] Agregando configuración de nodenv a $shell_config_file"
  {
    echo ''
    echo '# Configuración de nodenv'
    echo 'export PATH="$HOME/.nodenv/bin:$PATH"'
    echo 'eval "$(nodenv init -)"'
    echo 'export PATH="$HOME/.nodenv/plugins/node-build/bin:$PATH"'
  } >> "$shell_config_file"
fi

# 5. Aplicar configuración temporal si es posible
echo "🔄 [3/10] Aplicando configuración temporal..."
if [[ "$user_shell" == "zsh" && -f "$HOME/.zshrc" ]]; then
  source ~/.zshrc || echo "⚠️ No se pudo recargar. Cierra y abre tu terminal."
elif [[ "$user_shell" == "bash" && -f "$HOME/.bashrc" ]]; then
  source ~/.bashrc || echo "⚠️ No se pudo recargar. Cierra y abre tu terminal."
fi

# 6. Instalar node-build
if [ ! -d "$(nodenv root)/plugins/node-build" ]; then
  echo "🔧 [4/10] Instalando plugin node-build..."
  git clone https://github.com/nodenv/node-build.git "$(nodenv root)/plugins/node-build"
else
  echo "✅ node-build ya está instalado."
fi

# 7. Mostrar versiones disponibles
echo "📜 [5/10] Estas son las versiones de Node.js disponibles:"
nodenv install --list

# 8. Elegir versión o usar la última disponible automáticamente
node_latest=$(nodenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
read_prompt "👉 ¿Qué versión de Node.js deseas instalar? (ENTER para instalar la última versión estable: $node_latest): " node_version

if [[ -z "$node_version" ]]; then
  node_version=$node_latest
  echo "🔁 No se ingresó ninguna versión. Se instalará: $node_version"
else
  echo "📥 Se instalará Node.js $node_version según tu elección."
fi

# 9. Instalar y establecer versión global
echo "⬇️ [6/10] Instalando Node.js $node_version..."
nodenv install "$node_version"
nodenv global "$node_version"

# 10. Verificar instalación
echo "🔍 [7/10] Verificando instalación..."
node -v
npm -v

# 11. Instrucciones para actualizar en el futuro
echo "🛠️ [8/10] Para actualizar nodenv y node-build en el futuro:"
echo "cd ~/.nodenv && git pull"
echo "cd \"\$(nodenv root)/plugins/node-build\" && git pull"

echo
echo "🎉 Node.js $node_version ha sido instalado y configurado exitosamente con nodenv."