#!/usr/bin/env sh

UUID="c7503e2d-h577-442t-n593-lkdg99fe4drr"
BASE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LOGS_DIR="$BASE_DIR/logs"

mkdir -p "$LOGS_DIR"


# ============================================================
# Monta o pendrive pelo UUID
# ============================================================

montar_pendrive() {
    echo "Procurando pendrive com UUID: $UUID"

    DEVICE="$(blkid -U "$UUID" 2>/dev/null)"

    if [ -z "$DEVICE" ]; then
        echo "ERRO: pendrive não encontrado."
        return 1
    fi

    echo "Dispositivo encontrado: $DEVICE"

    # Verifica se já está montado
    DESTINO="$(findmnt -rn -S "$DEVICE" -o TARGET 2>/dev/null)"

    if [ -n "$DESTINO" ]; then
        echo "Pendrive já está montado em: $DESTINO"
        return 0
    fi

    echo "Montando pendrive..."

    if ! udisksctl mount -b "$DEVICE"; then
        echo "ERRO: não foi possível montar o pendrive."
        return 1
    fi

    sleep 1

    # Obtém o ponto de montagem
    DESTINO="$(findmnt -rn -S "$DEVICE" -o TARGET 2>/dev/null)"

    if [ -z "$DESTINO" ]; then
        echo "ERRO: pendrive foi montado, mas o ponto de montagem não foi encontrado."
        return 1
    fi

    echo "Pendrive montado em: $DESTINO"

    return 0
}


# ============================================================
# Aguarda o pendrive aparecer
# ============================================================

while ! montar_pendrive; do
    echo "Pendrive não disponível. Nova tentativa em 10 segundos..."
    sleep 10
done


# ============================================================
# Compacta meses anteriores
# ============================================================

compactar_meses_anteriores() {
    MES_ATUAL="$(date '+%Y-%m')"

    find "$LOGS_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -name '20??-??-??' \
        -printf '%f\n' |
    cut -c1-7 |
    sort -u |
    while IFS= read -r MES_DIR; do

        # Mantém o mês atual descompactado.
        [ "$MES_DIR" = "$MES_ATUAL" ] && continue

        ARQUIVO="$LOGS_DIR/$MES_DIR.7z"

        # Se o mês já foi compactado, não processa novamente.
        [ -f "$ARQUIVO" ] && continue

        echo "Compactando logs do mês $MES_DIR..."

        if (
            cd "$LOGS_DIR" || exit 1

            set -- "$MES_DIR"-??
            [ -d "$1" ] || exit 1

            7zz a -mx=9 "$ARQUIVO" "$MES_DIR"-??
        ); then

            rm -rf "$LOGS_DIR"/"$MES_DIR"-??

            echo "Logs de $MES_DIR compactados em: $ARQUIVO"
        else
            rm -f "$ARQUIVO"

            echo "ERRO: não foi possível compactar os logs de $MES_DIR. Os diretórios foram preservados."
        fi
    done
}


# ============================================================
# Loop principal
# ============================================================

while true; do

    # Verifica se o pendrive continua montado.
    if ! findmnt -rn "$DESTINO" >/dev/null 2>&1; then
        echo "Pendrive não está mais montado."
        echo "Tentando montar novamente..."

        if ! montar_pendrive; then
            echo "Não foi possível montar o pendrive."
            sleep 10
            continue
        fi
    fi


    # Executado a cada ciclo para detectar automaticamente
    # a virada do mês.
    compactar_meses_anteriores

    DATA_EXECUCAO="$(date '+%Y-%m-%d')"
    HORA_EXECUCAO="$(date '+%H-%M-%S')"

    LOG_DIA="$LOGS_DIR/$DATA_EXECUCAO"
    LOG_FILE="$LOG_DIA/$HORA_EXECUCAO.log"

    mkdir -p "$LOG_DIA"


    # Tudo que for exibido neste ciclo também fica salvo no log.
    exec 3>&1 4>&2
    exec >>"$LOG_FILE" 2>&1

    echo "============================================================"
    echo "Inicio - Data: $(date '+%d/%m/%Y %H:%M:%S') | Uptime: $(awk '{s=int($1); d=int(s/86400); h=int(s%86400/3600); m=int(s%3600/60); sec=int(s%60); printf "%dd %dh %dm %ds", d, h, m, sec}' /proc/uptime)"
    echo "Log: $LOG_FILE"
    echo "Destino: $DESTINO"
    echo "============================================================"
    echo


    echo "[1/7] Inicializando Rsync"
    sleep 5


    echo "[2/7] Sincronizando diretório Downloads"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 \
        "$HOME/Downloads/" "$DESTINO/Downloads/" \
        || echo "ERRO: rsync de Downloads retornou código $?"
    sleep 5


    echo "[3/7] Sincronizando diretório Pictures"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 \
        "$HOME/Pictures/" "$DESTINO/Pictures/" \
        || echo "ERRO: rsync de Pictures retornou código $?"
    sleep 5


    echo "[4/7] Sincronizando diretório Videos"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 \
        "$HOME/Videos/" "$DESTINO/Videos/" \
        || echo "ERRO: rsync de Videos retornou código $?"
    sleep 5


    echo "[5/7] Sincronizando diretório Music"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 \
        "$HOME/Music/" "$DESTINO/Music/" \
        || echo "ERRO: rsync de Music retornou código $?"
    sleep 5


    echo "[6/7] Sincronizando diretório Documents"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 \
        --exclude='storage/' \
        "$HOME/Documents/" "$DESTINO/Documents/" \
        || echo "ERRO: rsync de Documents retornou código $?"
    sleep 5


    echo "[7/7] Sincronização concluída!"
    echo
    echo "Fim - Data: $(date '+%d/%m/%Y %H:%M:%S') | Uptime: $(awk '{s=int($1); d=int(s/86400); h=int(s%86400/3600); m=int(s%3600/60); sec=int(s%60); printf "%dd %dh %dm %ds", d, h, m, sec}' /proc/uptime)"
    echo "============================================================"


    # Restaura stdout/stderr para o terminal
    exec 1>&3 2>&4
    exec 3>&- 4>&-

    sleep 240
    clear

done
