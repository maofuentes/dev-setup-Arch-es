#!/usr/bin/env zsh
set -e

# Script para instalar y configurar PostgreSQL en Ubuntu/WSL
# Autor: Brayan Diaz C
# Fecha: 13 nov 2024 (actualizado 20 jun 2025)

echo "🐘 Iniciando el proceso de instalación y configuración de PostgreSQL..."

# Función para leer entrada compatible con Zsh y Bash
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

# 1. Actualizar el sistema
echo "📦 [1/8] Actualizando sistema..."
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

# 2. Solicitar versión (por defecto 16)
default_pg_version="16"
read_prompt "👉 ¿Qué versión de PostgreSQL deseas instalar? (ENTER para instalar $default_pg_version): " pg_version
pg_version=${pg_version:-$default_pg_version}
echo "🔁 Se instalará PostgreSQL $pg_version"

# 3. Añadir repositorio oficial usando el método recomendado
echo "➕ [2/8] Añadiendo el repositorio oficial de PostgreSQL..."
sudo apt install -y wget lsb-release gnupg postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

# 4. Instalar PostgreSQL
echo "⬇️ [3/8] Instalando PostgreSQL $pg_version..."
sudo apt update
sudo apt install -y "postgresql-$pg_version"

# 5. Verificar instalación
echo "🔍 [4/8] Verificando instalación..."
psql --version

# 6. Activar y habilitar servicio
echo "🔧 [5/8] Activando el servicio de PostgreSQL..."
sudo systemctl enable postgresql
sudo systemctl start postgresql

# 7. Crear usuario y establecer contraseña
echo "👤 [6/8] Configurando usuario de PostgreSQL..."
sudo -u postgres createuser --superuser "$USER" || echo "⚠️ Usuario ya existe."
echo "🔐 Establece una contraseña para el usuario '$USER' en PostgreSQL:"
sudo -u postgres psql -c "\password $USER"

# 8. Probar conexión
echo "🔗 [7/8] Probando conexión local a PostgreSQL..."
psql -d postgres || echo "⚠️ La conexión puede fallar si la autenticación no está correctamente configurada."

# 9. Notas adicionales
echo "📘 [8/8] Notas:"
echo "- Si necesitas compilar desde otros lenguajes, instala también: sudo apt install libpq-dev"
echo "- Para desinstalar versiones anteriores: sudo apt remove postgresql-<version>"

echo
echo "🎉 PostgreSQL $pg_version ha sido instalado y configurado exitosamente."