#!/bin/bash
set -e

# Script para instalar y configurar Oh My Zsh en Ubuntu y WSL
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

# 5. Instalar plugins adicionales
echo "🔌 Instalando plugins zsh-syntax-highlighting y zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 6. Habilitar plugins en .zshrc
echo "⚙️ Configurando plugins en .zshrc..."
if grep -q "plugins=" ~/.zshrc; then
  sed -i 's/plugins=(.*)/plugins=(aws azure bundler colorize docker docker-compose gcloud gem git heroku history-substring-search node nodenv npm pip postgres pyenv python rails react-native rbenv ruby vscode zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
else
  echo "⚠️ No se encontró la línea de plugins en .zshrc. Añádela manualmente."
fi

# 7. Aplicar cambios
echo "🔁 Aplicando cambios..."
# NOTA: Este comando solo tendrá efecto si ya estás dentro de una sesión Zsh
source ~/.zshrc

# 8. Instalar fuentes Powerline
echo "🔡 Instalando fuentes Powerline para una mejor visualización..."
sudo apt install -y fonts-powerline

# 9. Mensaje final
echo "✅ Instalación y configuración de Oh My Zsh completada con éxito."
echo "💡 Reinicia tu terminal o ejecuta 'zsh' para aplicar los cambios."