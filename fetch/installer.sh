#!/usr/bin/env bash

# Função para verificar se o comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detecta o gerenciador de pacotes
if command_exists apt; then
    PKG_MANAGER="apt"
elif command_exists dnf; then
    PKG_MANAGER="dnf"
elif command_exists pacman; then
    PKG_MANAGER="pacman"
elif command_exists zypper; then
    PKG_MANAGER="zypper"
else
    echo "Gerenciador de pacotes não suportado."
    exit 1
fi

# Verifica se fastfetch já está instalado
if command_exists fastfetch; then
    fastfetch
    exit 0
fi

# Verifica se neofetch já está instalado
if command_exists neofetch; then
    neofetch
    exit 0
fi

# Função para instalar pacotes
install_package() {
    case "$PKG_MANAGER" in
        apt)
            sudo apt update && sudo apt install -y "$1"
            ;;
        dnf)
            sudo dnf install -y "$1"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$1"
            ;;
        zypper)
            sudo zypper install -y "$1"
            ;;
    esac
}

# Tenta instalar fastfetch
echo "Tentando instalar fastfetch..."
if install_package fastfetch; then
    if command_exists fastfetch; then
        fastfetch
        exit 0
    fi
fi

# Se fastfetch não estiver disponível, tenta neofetch
echo "Fastfetch não disponível. Tentando instalar neofetch..."
if install_package neofetch; then
    if command_exists neofetch; then
        neofetch
        exit 0
    fi
fi

# Se nenhum estiver disponível
echo "Nenhum dos pacotes (fastfetch ou neofetch) está disponível nos repositórios."
exit 1
