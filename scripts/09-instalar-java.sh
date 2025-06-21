#!/usr/bin/env zsh
set -e

# Script para instalar Java (JDK) y Maven con SDKMAN!
# Autor: Brayan Diaz C
# Fecha: 21 jun 2025

echo "☕ Iniciando instalación de Java (JDK) y Maven usando SDKMAN..."

# Función compatible para lectura de entrada en Zsh y Bash
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

# 1. Instalar dependencias básicas
echo "📦 [1/9] Verificando dependencias necesarias..."
sudo apt update && sudo apt install -y curl zip unzip

# 2. Instalar SDKMAN!
if [ -d "$HOME/.sdkman" ]; then
  echo "⚠️ SDKMAN ya está instalado. Saltando instalación."
else
  echo "⬇️ Instalando SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
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
    echo "Agrega esto a tu archivo de configuración:"
    echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"'
    shell_config_file=""
    ;;
esac

# 4. Agregar SDKMAN al entorno si no existe
if [[ -n "$shell_config_file" && ! $(grep sdkman-init "$shell_config_file") ]]; then
  echo "🧩 [2/9] Agregando SDKMAN al entorno en $shell_config_file"
  echo '' >> "$shell_config_file"
  echo '# Configuración de SDKMAN' >> "$shell_config_file"
  echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$shell_config_file"
fi

# 5. Aplicar entorno actual
echo "🔄 [3/9] Aplicando configuración temporal..."
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 6. Mostrar versiones de Java
echo "📜 [4/9] Listando versiones de Java disponibles..."
sdk list java | grep -E 'tem|lts' | grep -v -E 'ea|rc|fx'

# 7. Solicitar versión o usar última LTS por defecto
latest_lts=$(sdk list java | grep -E '\s+tem.*-lts\s+' | grep -v -E 'ea|rc' | head -1 | awk '{print $NF}')
read_prompt "👉 ¿Qué versión de Java deseas instalar? (ENTER para instalar la última LTS: $latest_lts): " java_version

if [[ -z "$java_version" ]]; then
  java_version=$latest_lts
  echo "🔁 No se ingresó ninguna versión. Se instalará la LTS: $java_version"
else
  echo "📥 Se instalará Java $java_version"
fi

# 8. Instalar Java y Maven
echo "☕ [5/9] Instalando Java con SDKMAN..."
sdk install java "$java_version"
sdk default java "$java_version"

echo "🔧 [6/9] Instalando Maven..."
sdk install maven
sdk default maven

# 9. Verificar instalación
echo "🔍 [7/9] Verificando instalación..."
java -version
mvn -version

# 10. Instrucciones futuras
echo "🛠️ [8/9] Para actualizar SDKMAN en el futuro:"
echo "sdk update"
echo "sdk upgrade"

echo
echo "🎉 [9/9] Java ($java_version) y Maven han sido instalados correctamente usando SDKMAN."