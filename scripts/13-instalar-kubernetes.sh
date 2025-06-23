#!/usr/bin/env zsh
set -e

# Script para instalar kubectl y minikube en Ubuntu/WSL
# Autor: Brayan Diaz C
# Fecha: 21 jun 2025

echo "☸️ Iniciando la instalación de Kubernetes local con kubectl y minikube..."

# Función compatible para leer entrada en Zsh o Bash
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

# 1. Actualizar sistema
echo "📦 [1/9] Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

# 2. Instalar kubectl
echo "⬇️ [2/9] Instalando kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
echo "✅ kubectl instalado: $(kubectl version --client --short)"

# 3. Instalar minikube
echo "⬇️ [3/9] Instalando minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
echo "✅ minikube instalado: $(minikube version)"

# 4. Verificar si Docker está activo
echo "🔍 [4/9] Verificando si Docker está disponible..."
if ! command -v docker &>/dev/null; then
  echo "❌ Docker no está instalado o no está disponible."
  echo "🛠️ Por favor instala Docker antes de continuar con minikube."
  exit 1
fi

# 5. Sugerir driver
echo "🧠 [5/9] Driver recomendado para minikube: docker"
minikube config set driver docker

# 6. Solicitar inicio automático
read_prompt "🚀 ¿Deseas iniciar el clúster de minikube ahora? (y/n): " start_now
if [[ "$start_now" == "y" ]]; then
  echo "⏳ Iniciando minikube..."
  minikube start
  echo "✅ Clúster iniciado. Puedes probar con: kubectl get nodes"
else
  echo "ℹ️ Puedes iniciarlo luego con: minikube start"
fi

# 7. Alias opcionales
user_shell=$(basename "$SHELL")
case "$user_shell" in
  bash)
    shell_config_file="$HOME/.bashrc"
    ;;
  zsh)
    shell_config_file="$HOME/.zshrc"
    ;;
  *)
    shell_config_file=""
    ;;
esac

if [[ -n "$shell_config_file" ]]; then
  echo "🔧 [6/9] Añadiendo alias útiles a $shell_config_file..."
  {
    echo ''
    echo '# Alias Kubernetes'
    echo 'alias k="kubectl"'
    echo 'alias mk="minikube"'
  } >> "$shell_config_file"
fi

# 8. Recomendaciones
echo "📘 [7/9] Recomendaciones adicionales:"
echo "- Usa 'minikube dashboard' para abrir el panel web del clúster."
echo "- Puedes habilitar addons como ingress, metrics-server, etc."

# 9. Verificación
echo "🔍 [8/9] Verificación rápida:"
kubectl version --client --short
minikube version

echo
echo "🎉 [9/9] kubectl y minikube han sido instalados correctamente."