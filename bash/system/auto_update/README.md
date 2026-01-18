# Script de Atualização Automática de Segurança em Linux
### Objetivo do Script

Este script tem como objetivo:

Atualizar apenas pacotes de segurança (quando a distribuição suporta) \
Executar somente se houver atualizações disponíveis \
Funcionar em múltiplas distribuições Linux: \
Debian / Ubuntu \
Fedora / RHEL / Rocky / Alma \
OpenSUSE Leap / Tumbleweed \
Arch Linux / Manjaro \
Registrar todas as ações em log \
Ser executado automaticamente via cron

### Localização recomendada

```bash
/usr/local/bin/auto_update.sh
```

Motivo:

Diretório padrão para scripts administrativos \
Disponível para todos os usuários \
Não é sobrescrito por atualizações do sistema

### Tornar executável

```bash
sudo chmod +x /usr/local/bin/auto_update.sh
```

### Código do script

```bash
#!/bin/bash
```

### Shebang

Indica que o script deve ser executado pelo Bash \
Garante compatibilidade mesmo quando chamado pelo cron

```bash
LOGFILE="/var/log/auto_update.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
```

### Variáveis globais

Variável	Função \
LOGFILE	Arquivo onde tudo será registrado \
DATE	Data e hora atuais, usadas no log \
Formato escolhido para facilitar leitura e auditoria.

```bash
echo "[$DATE] Verificando atualizações de segurança..." >> "$LOGFILE" \
```

Registro no log adiciona ao arquivo sem apagar conteúdo anterior \
Todas as execuções ficam registradas

### Detecção automática da distribuição
O script identifica a distro verificando qual gerenciador de pacotes existe no sistema:

```bash
command -v apt
command -v dnf
command -v zypper
command -v pacman
```

Se o comando existir, aquela distro é assumida.

### Debian / Ubuntu (APT)

```bash
if command -v apt >/dev/null 2>&1; then
```

Detecta sistemas baseados em APT

```bash
apt update -qq
```

Atualiza a lista de pacotes \
-qq = modo silencioso (ideal para cron)

```bash
SECURITY_UPDATES=$(apt list --upgradable 2>/dev/null | grep -i security)
```

Verificação de updates de segurança \
Lista pacotes atualizáveis \
Filtra apenas os repositórios de segurança

```bash
if [ -n "$SECURITY_UPDATES" ]; then
```

Executa atualização somente se algo foi encontrado

```bash
unattended-upgrade -d
```

### Atualização segura

Ferramenta oficial do Ubuntu/Debian \
Instala somente pacotes de segurança \
Evita upgrades perigosos

### Fedora / RHEL / Rocky / Alma (DNF)

```bash
dnf updateinfo list security --quiet
```

Consulta apenas avisos de segurança \
Não altera o sistema

```bash
dnf upgrade --security -y
```

Segurança apenas \
Atualiza somente pacotes marcados como security

> -y evita interação humana

### OpenSUSE (Zypper)

```bash
zypper list-patches --category security
```

OpenSUSE categoriza patches oficialmente \
Ideal para ambientes corporativos

```bash
zypper patch --category security -y
```

Aplica somente patches de segurança \
Não altera versões principais \
Extremamente seguro

### Arch Linux / Manjaro (Pacman)

```bash
pacman -Qu
```

Verifica se existem atualizações disponíveis

**Importante**
Arch Linux não separa pacotes de segurança. \
Toda atualização pode conter correções críticas.

```bash
pacman -Su --noconfirm
```

Atualiza somente se houver pacotes pendentes \
Não atualiza AUR (intencional)

### Caso nenhuma distro seja reconhecida

```bash
else
    echo "Gerenciador de pacotes não suportado"
    exit 1
```

Evita comportamento inesperado \
Encerra com erro

### Finalização do processo

```bash
echo "Processo finalizado." >> "$LOGFILE"
```

Marca o fim da execução no log

### Log gerado
Exemplo de log:

```text
[2026-01-18 02:00:01] Verificando atualizações de segurança...
[2026-01-18 02:00:03] Sistema Debian/Ubuntu (APT)
[2026-01-18 02:00:10] Atualizações de segurança encontradas.
[2026-01-18 02:00:45] Processo finalizado.
```

### Agendamento automático (cron)

```bash
sudo crontab -e
```

```bash
0 */2 * * * /usr/local/bin/auto_update.sh
```

## Interpretação:

Campo	Valor \
Minuto	0 \
Hora	A cada 2 \
Dia	Todos \
Mês	Todos \
Semana	Todos

### Boas práticas recomendadas

✔ Executar como root \
✔ Usar apenas pacotes oficiais \
✔ Monitorar o log periodicamente \
✔ Testar em ambiente de homologação

### Limitações conhecidas

Distro	Limitação \
Arch	Não separa segurança \
Debian	Depende do unattended-upgrades \
Todas	Não reinicia automaticamente

### Testar o script manualmente (passo obrigatório)

Antes de confiar no cron, execute manualmente:

```bash
sudo /usr/local/bin/auto_update.sh
```

Depois verifique o log:

```bash
sudo tail -n 20 /var/log/auto_update.log
```

Você deve ver algo como:

```text
[2026-01-18 14:32:01] Verificando atualizações de segurança...
[2026-01-18 14:32:02] Sistema Debian/Ubuntu (APT)
[2026-01-18 14:32:05] Nenhuma atualização de segurança disponível.
[2026-01-18 14:32:05] Processo finalizado.
```

Se isso funciona, o script está correto. \
Se não funcionar manualmente, o cron nunca funcionará.

---
