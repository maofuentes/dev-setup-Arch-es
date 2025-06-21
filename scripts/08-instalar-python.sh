#!/usr/bin/env zsh
set -e

# Script para instalar y configurar Python en Ubuntu con pyenv
# Autor: Brayan Diaz C
# Fecha: 23 ene 2025 (actualizado 20 jun 2025)

echo "🐍 Iniciando el proceso de instalación y configuración de Python con pyenv..."

# 1. Actualizar el sistema
echo "📦 [1/10] Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

echo "🔧 Instalando dependencias necesarias para compilar Python..."
sudo apt install -y \
git curl wget make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
ca-certificates

# 2. Instalar pyenv
if [ -d "$HOME/.pyenv" ]; then
  echo "⚠️ pyenv ya está instalado. Saltando clonación..."
else
  echo "🔄 Clonando el repositorio de pyenv..."
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
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
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init --path)"'
    echo 'eval "$(pyenv init -)"'
    shell_config_file=""
    ;;
esac

# 4. Escribir configuración en el archivo correspondiente
if [[ -n "$shell_config_file" ]]; then
  echo "🧩 [2/10] Agregando configuración de pyenv a $shell_config_file"
  {
    echo ''
    echo '# Configuración de pyenv'
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init --path)"'
    echo 'eval "$(pyenv init -)"'
  } >> "$shell_config_file"
fi

# 5. Aplicar configuración temporal
echo "🔄 [3/10] Aplicando configuración temporal..."
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# 6. Mostrar versiones disponibles
echo "📜 [4/10] Estas son las versiones de Python disponibles:"
pyenv install --list

# 7. Solicitar versión o usar la última estable
python_latest=$(pyenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
read -p "👉 ¿Qué versión de Python deseas instalar? (ENTER para instalar la última versión estable: $python_latest): " python_version

if [[ -z "$python_version" ]]; then
  python_version=$python_latest
  echo "🔁 No se ingresó ninguna versión. Se instalará: $python_version"
else
  echo "📥 Se instalará Python $python_version según tu elección."
fi

# 8. Instalar y establecer versión global
echo "⬇️ [5/10] Instalando Python $python_version..."
pyenv install "$python_version"
pyenv global "$python_version"

# 9. Verificar instalación
echo "🔍 [6/10] Verificando instalación..."
python --version

# 10. Instalar pip y paquetes básicos
echo "📦 [7/10] Instalando pip y herramientas esenciales..."
curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm get-pip.py
pip install --upgrade pip setuptools wheel

# 11. Instrucciones futuras
echo "🛠️ [8/10] Para actualizar pyenv en el futuro:"
echo "cd ~/.pyenv && git pull"

echo
echo "🎉 Python $python_version ha sido instalado y configurado exitosamente con pyenv."