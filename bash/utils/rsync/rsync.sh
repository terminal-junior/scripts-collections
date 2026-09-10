#!/usr/bin/env sh

DESTINO="/mnt/pendrive"
BASE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LOGS_DIR="$BASE_DIR/logs"

mkdir -p "$LOGS_DIR"

# Compacta todos os diretórios de dias de meses anteriores.
# Cada mês vira um único arquivo .7z usando compressão máxima (-mx=9).
compactar_meses_anteriores() {
MES_ATUAL="$(date '+%Y-%m')"

# Obtém apenas os meses únicos existentes nos diretórios de logs.
find "$LOGS_DIR" -mindepth 1 -maxdepth 1 -type d -name '20??-??-??' -printf '%f\n' |
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

        # Verifica se existem diretórios do mês.
        set -- "$MES_DIR"-??
        [ -d "$1" ] || exit 1

        # Compacta todos os diretórios do mês.
        7zz a -mx=9 -mhe=on -t7z -m0=lzma2 "$ARQUIVO" "$MES_DIR"-??
    ); then

        # Remove os diretórios somente após compactação bem-sucedida.
        rm -rf "$LOGS_DIR"/"$MES_DIR"-??

        echo "Logs de $MES_DIR compactados em: $ARQUIVO"
    else
        # Remove arquivo incompleto, se existir.
        rm -f "$ARQUIVO"

        echo "ERRO: não foi possível compactar os logs de $MES_DIR. Os diretórios foram preservados."
    fi
done

}


while true; do
    # Executado a cada ciclo para detectar automaticamente a virada do mês.
    compactar_meses_anteriores

    DATA_EXECUCAO="$(date '+%Y-%m-%d')"
    HORA_EXECUCAO="$(date '+%H-%M-%S')"
    LOG_DIA="$LOGS_DIR/$DATA_EXECUCAO"
    LOG_FILE="$LOG_DIA/$HORA_EXECUCAO.log"

    mkdir -p "$LOG_DIA"

    # Tudo que for exibido neste ciclo também fica salvo no arquivo de log.
    exec 3>&1 4>&2
    exec >>"$LOG_FILE" 2>&1

    echo "============================================================"
    echo "Inicio - Data: $(date '+%d/%m/%Y %H:%M:%S') | Uptime: $(awk '{s=int($1); d=int(s/86400); h=int(s%86400/3600); m=int(s%3600/60); sec=int(s%60); printf "%dd %dh %dm %ds", d, h, m, sec}' /proc/uptime)"
    echo "Log: $LOG_FILE"
    echo "============================================================"
    echo

    echo "[1/7] Inicializando Rsync"
    sleep 5

    echo "[2/7] Sincronizando diretório Downloads"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 "$HOME/Downloads" "$DESTINO" || echo "ERRO: rsync de Downloads retornou código $?"
    sleep 5

    echo "[3/7] Sincronizando diretório Picture"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 "$HOME/Pictures" "$DESTINO" || echo "ERRO: rsync de Picture retornou código $?"
    sleep 5

    echo "[4/7] Sincronizando diretório Videos"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 "$HOME/Videos" "$DESTINO" || echo "ERRO: rsync de Videos retornou código $?"
    sleep 5

    echo "[5/7] Sincronizando diretório Music"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 "$HOME/Music" "$DESTINO" || echo "ERRO: rsync de Music retornou código $?"
    sleep 5

    echo "[6/7] Sincronizando diretório Documents"
    echo "Itens alterados nesta execução:"
    rsync -ahvi --delete --info=NAME0 --exclude='storage/' "$HOME/Documents" "$DESTINO" || echo "ERRO: rsync de Documents retornou código $?"
    sleep 5

    echo "[7/7] Sincronização concluída!"
    echo
    echo "Fim - Data: $(date '+%d/%m/%Y %H:%M:%S') | Uptime: $(awk '{s=int($1); d=int(s/86400); h=int(s%86400/3600); m=int(s%3600/60); sec=int(s%60); printf "%dd %dh %dm %ds", d, h, m, sec}' /proc/uptime)"
    echo "============================================================"

    # Restaura stdout/stderr para o terminal antes da próxima espera.
    exec 1>&3 2>&4
    exec 3>&- 4>&-

    sleep 300
    clear
done
