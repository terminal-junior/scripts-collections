#!/bin/bash

LOGFILE="/var/log/auto_update.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Verificando atualizações de segurança..." >> "$LOGFILE"

# =========================
# Debian / Ubuntu
# =========================
if command -v apt >/dev/null 2>&1; then
    echo "[$DATE] Sistema Debian/Ubuntu (APT)" >> "$LOGFILE"

    apt update -qq

    SECURITY_UPDATES=$(apt list --upgradable 2>/dev/null | grep -i security)

    if [ -n "$SECURITY_UPDATES" ]; then
        echo "[$DATE] Atualizações de segurança encontradas." >> "$LOGFILE"
        unattended-upgrade -d >> "$LOGFILE" 2>&1
    else
        echo "[$DATE] Nenhuma atualização de segurança disponível." >> "$LOGFILE"
    fi

# =========================
# RHEL / Fedora / Rocky / Alma
# =========================
elif command -v dnf >/dev/null 2>&1; then
    echo "[$DATE] Sistema RHEL/Fedora (DNF)" >> "$LOGFILE"

    if dnf updateinfo list security --quiet | grep -q security; then
        echo "[$DATE] Atualizações de segurança encontradas." >> "$LOGFILE"
        dnf upgrade --security -y >> "$LOGFILE" 2>&1
    else
        echo "[$DATE] Nenhuma atualização de segurança disponível." >> "$LOGFILE"
    fi

# =========================
# OpenSUSE Leap / Tumbleweed
# =========================
elif command -v zypper >/dev/null 2>&1; then
    echo "[$DATE] Sistema OpenSUSE (Zypper)" >> "$LOGFILE"

    zypper refresh -q

    if zypper list-patches --category security | grep -q security; then
        echo "[$DATE] Atualizações de segurança encontradas." >> "$LOGFILE"
        zypper patch --category security -y >> "$LOGFILE" 2>&1
    else
        echo "[$DATE] Nenhuma atualização de segurança disponível." >> "$LOGFILE"
    fi

# =========================
# Arch Linux / Manjaro
# =========================
elif command -v pacman >/dev/null 2>&1; then
    echo "[$DATE] Sistema Arch Linux (Pacman)" >> "$LOGFILE"

    pacman -Sy --quiet

    if pacman -Qu | grep -q .; then
        echo "[$DATE] Atualizações encontradas (Arch não separa segurança)." >> "$LOGFILE"
        pacman -Su --noconfirm >> "$LOGFILE" 2>&1
    else
        echo "[$DATE] Nenhuma atualização disponível." >> "$LOGFILE"
    fi

else
    echo "[$DATE] Gerenciador de pacotes não suportado." >> "$LOGFILE"
    exit 1
fi

echo "[$DATE] Processo finalizado." >> "$LOGFILE"
echo "--------------------------------------------------" >> "$LOGFILE"
