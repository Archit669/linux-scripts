#!/bin/bash

set -e  # Exit on any error

echo "🔄 Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "📦 Installing common developer packages..."
sudo apt-get install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    g++ \
    openjdk-17-jdk \
    python3 \
    python3-pip \
    nodejs \
    npm \
    git 

# -----------------------------------
# Google Chrome
# -----------------------------------
echo "🌐 Installing Google Chrome..."
wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome.deb
rm google-chrome.deb

# -----------------------------------
# Microsoft Edge
# -----------------------------------
echo "🌐 Installing Microsoft Edge..."
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | gpg --dearmor > microsoft-edge.gpg
sudo install -o root -g root -m 644 microsoft-edge.gpg /etc/apt/trusted.gpg.d/
rm microsoft-edge.gpg
echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/edge stable main" | \
    sudo tee /etc/apt/sources.list.d/microsoft-edge.list
sudo apt-get update -y
sudo apt-get install -y microsoft-edge-stable

# -----------------------------------
# Visual Studio Code
# -----------------------------------
echo "🛠️ Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
rm microsoft.gpg
echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main" | \
    sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update -y
sudo apt-get install -y code

# -----------------------------------
# Docker
# -----------------------------------
echo "🐳 Installing Docker Engine and Docker Compose..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
echo "🚨 You may need to restart your session or run 'newgrp docker' for Docker to work without sudo."

# -----------------------------------
# Discord
# -----------------------------------
echo "💬 Installing Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
rm discord.deb

#-----------------------------------------
# Brave
#-----------------------------------------
echo "Installing Brave..."
sudo apt install curl -y

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update -y

sudo apt install brave-browser -y

#------------------------------------------------
#Postman
#--------------------------------------------------
echo "Installing postman"
sudo snap install postman

#-------------------------------------------------
# setup gestures -> go to extensions-> browse -> x11 gestures -> install it
#-----------------------------------------------
echo "setting up gestures"
sudo apt install gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager -y
sudo add-apt-repository ppa:touchegg/stable
sudo apt install touchegg -y
systemctl status touchegg

# -----------------------------------
# Cleanup
# -----------------------------------
echo "🧹 Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "✅ All tools installed successfully!"

