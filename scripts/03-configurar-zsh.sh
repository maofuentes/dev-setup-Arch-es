#!/bin/bash
set -e

# Script para configurar Oh My Zsh en Ubuntu y WSL
# Autor: Brayan Diaz C
# Fecha: 20 jun 2025

echo "🔧 Iniciando la instalación de plugins para Zsh y Oh My Zsh en tu sistema..."

# 1. Instalar plugins adicionales para Zsh
echo "🔌 Instalando plugins zsh-syntax-highlighting y zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 2. Habilitar plugins en .zshrc
echo "⚙️ Configurando plugins en .zshrc..."
if grep -q "plugins=" ~/.zshrc; then
  sed -i 's/plugins=(.*)/plugins=(aws azure bundler colorize docker docker-compose gcloud gem git heroku history-substring-search node nodenv npm pip postgres pyenv python rails react-native rbenv ruby vscode zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
else
  echo "⚠️ No se encontró la línea de plugins en .zshrc. Añádela manualmente."
fi

# 3. Aplicar cambios
echo "🔁 Aplicando cambios..."
# NOTA: Este comando solo tendrá efecto si ya estás dentro de una sesión Zsh
source ~/.zshrc

# 4. Instalar fuentes Powerline
echo "🔡 Instalando fuentes Powerline para una mejor visualización..."
sudo apt install -y fonts-powerline

# 5. Mensaje final
echo "✅ Configuración de Oh My Zsh completada con éxito."