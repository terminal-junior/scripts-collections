# 🔄 Backup Contínuo com Rsync e Compactação Mensal

Script **Shell POSIX** para realizar sincronização contínua de diretórios pessoais para um dispositivo de armazenamento externo, como pendrive, HD externo ou SSD.

O script utiliza o **Rsync** para manter os arquivos sincronizados e cria automaticamente logs de cada execução. No início de cada ciclo, também verifica os logs de meses anteriores e compacta cada mês em um único arquivo `.7z` utilizando compressão máxima.

## ✨ Funcionalidades

* 🔄 Sincronização automática e contínua com `rsync`
* 💾 Backup para um dispositivo externo ou diretório definido pelo usuário
* 🗑️ Uso de `--delete` para manter o destino espelhado com a origem
* 📁 Sincronização de:

  * `Downloads`
  * `Pictures`
  * `Videos`
  * `Music`
  * `Documents`
* 🚫 Exclusão do diretório `Documents/storage/` da sincronização
* 📝 Criação de um arquivo de log para cada execução
* 📅 Organização dos logs por dia
* 🗜️ Compactação automática dos logs de meses anteriores
* 🔐 Compressão `.7z` utilizando `7zz -mx=9`
* ♻️ Remoção dos logs originais somente após uma compactação bem-sucedida
* ⏱️ Execução automática a cada **5 minutos**
* 📊 Registro do uptime do sistema em cada execução
* 🖥️ Exibição simultânea do progresso no terminal e no arquivo de log

---

## 📋 Requisitos

O script depende dos seguintes programas:

* `sh`
* `rsync`
* `7zz`
* `find`
* `cut`
* `sort`
* `awk`
* `date`
* `mkdir`
* `rm`
* `sleep`
* `clear`

Em distribuições Linux baseadas em Debian/Ubuntu, por exemplo:

```bash
sudo apt update
sudo apt install rsync p7zip-full
```

> Dependendo da distribuição, o executável do 7-Zip pode ser `7z`, `7zz` ou outro nome. Este script especificamente utiliza o comando `7zz`.

Verifique se os comandos estão disponíveis:

```bash
command -v rsync
command -v 7zz
```

---

## 📥 Instalação

Clone o repositório:

```bash
git clone https://github.com/terminal-junior/scripts-collections.git
cd scripts-collections/bash/utils/rsync
```

Dê permissão de execução ao script:

```bash
chmod +x rsync.sh
```

Execute:

```bash
./rsync.sh
```

---

## ⚙️ Configuração

A principal configuração do script está no início do arquivo:

```sh
DESTINO="/mnt/pendrive"
```

Altere esse valor para o ponto de montagem do seu dispositivo de destino.

Por exemplo:

```sh
DESTINO="/media/usuario/Backup"
```

ou:

```sh
DESTINO="/mnt/backup"
```

O diretório onde o próprio script está localizado é detectado automaticamente:

```sh
BASE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
```

Os logs são armazenados em:

```text
<diretório-do-script>/logs/
```

Portanto, não é necessário configurar manualmente o caminho dos logs.

---

# 🔄 Como funciona

O script funciona em um loop infinito:

```text
┌─────────────────────────┐
│ Início do ciclo         │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Compacta meses antigos  │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Cria log da execução    │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Rsync Downloads         │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Rsync Pictures          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Rsync Videos            │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Rsync Music             │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Rsync Documents         │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Aguarda 5 minutos       │
└────────────┬────────────┘
             │
             └──────────────► Novo ciclo
```

---

## 📂 Diretórios sincronizados

O script sincroniza os seguintes diretórios do `$HOME`:

### Downloads

```sh
rsync -ahvi --delete --info=NAME0 "$HOME/Downloads" "$DESTINO"
```

### Pictures

```sh
rsync -ahvi --delete --info=NAME0 "$HOME/Pictures" "$DESTINO"
```

### Videos

```sh
rsync -ahvi --delete --info=NAME0 "$HOME/Videos" "$DESTINO"
```

### Music

```sh
rsync -ahvi --delete --info=NAME0 "$HOME/Music" "$DESTINO"
```

### Documents

```sh
rsync -ahvi --delete --info=NAME0 \
    --exclude='storage/' \
    "$HOME/Documents" "$DESTINO"
```

O diretório:

```text
Documents/storage/
```

é propositalmente ignorado.

---

# ⚠️ Sobre o `--delete`

O script utiliza:

```text
--delete
```

Isso significa que arquivos removidos na origem também serão removidos do destino.

Por exemplo:

```text
Origem:
Documents/
├── arquivo1.txt
└── arquivo2.txt

Destino:
Documents/
├── arquivo1.txt
└── arquivo2.txt
```

Se `arquivo2.txt` for removido da origem:

```text
Origem:
Documents/
└── arquivo1.txt
```

na próxima sincronização ele também será removido do destino.

### ⚠️ Atenção

O destino funciona como um **espelho da origem**, e não como um histórico de versões.

Se você precisa manter arquivos apagados ou versões antigas, este script não substitui uma solução de backup versionado.

---

# 📝 Sistema de logs

Cada execução gera um novo arquivo de log.

A estrutura fica semelhante a:

```text
logs/
├── 2026-09-08/
│   ├── 10-00-00.log
│   ├── 10-05-00.log
│   └── 10-10-00.log
├── 2026-09-09/
│   ├── 14-00-00.log
│   └── 14-05-00.log
└── 2026-09-10/
    ├── 16-00-00.log
    └── 16-05-00.log
```

Cada arquivo contém:

* data e hora de início;
* uptime do sistema;
* caminho do arquivo de log;
* etapas da sincronização;
* arquivos alterados pelo `rsync`;
* possíveis erros;
* data e hora de término;
* uptime no final da execução.

---

# 🗜️ Compactação mensal

Para evitar que a quantidade de arquivos de log cresça indefinidamente, o script possui uma rotina de compactação automática.

A função:

```sh
compactar_meses_anteriores()
```

identifica diretórios de logs no formato:

```text
YYYY-MM-DD
```

e agrupa os diretórios pertencentes ao mesmo mês.

Por exemplo:

```text
logs/
├── 2026-07-01/
├── 2026-07-02/
├── 2026-07-03/
├── ...
└── 2026-07-31/
```

é transformado em:

```text
logs/
└── 2026-07.7z
```

A compactação utiliza:

```sh
7zz a -mx=9
```

onde:

* `a` = adiciona arquivos ao arquivo compactado;
* `-mx=9` = nível máximo de compressão.

---

## 🔐 Segurança durante a compactação

Os diretórios originais **só são removidos depois que o `7zz` termina com sucesso**.

Fluxo:

```text
Diretórios do mês
       │
       ▼
   7zz -mx=9
       │
   ┌───┴────┐
   │        │
Sucesso    Erro
   │        │
   ▼        ▼
Remove    Mantém
originais diretórios
   │
   ▼
.7z válido
```

Se a compactação falhar, o arquivo `.7z` incompleto é removido:

```sh
rm -f "$ARQUIVO"
```

e os diretórios originais são preservados.

Isso evita perder os logs caso o processo de compactação apresente algum problema.

---

# 📅 Detecção automática da virada do mês

O script verifica o mês atual em cada ciclo:

```sh
MES_ATUAL="$(date '+%Y-%m')"
```

O mês atual permanece descompactado.

Quando um novo mês começa, os diretórios do mês anterior passam a ser candidatos à compactação.

Por exemplo, durante:

```text
2026-09
```

os logs de:

```text
2026-09-01
2026-09-02
2026-09-03
...
```

continuam normalmente como diretórios.

Já os logs de:

```text
2026-08-01
2026-08-02
...
2026-08-31
```

podem ser compactados em:

```text
2026-08.7z
```

---

# ⏱️ Intervalo entre execuções

Após concluir todas as sincronizações, o script executa:

```sh
sleep 300
```

300 segundos correspondem a:

```text
5 minutos
```

Portanto, o backup é executado continuamente em ciclos de aproximadamente 5 minutos.

> O intervalo é contado após o término de uma execução. Como cada etapa também possui `sleep 5`, o intervalo real entre o início de dois ciclos será superior a 5 minutos.

---

# 📊 Uptime

O script registra o uptime do sistema utilizando:

```sh
/proc/uptime
```

O resultado é convertido para um formato mais legível:

```text
2d 7h 34m 21s
```

Exemplo:

```text
Inicio - Data: 10/09/2026 16:30:02 | Uptime: 12d 4h 17m 33s
```

Isso pode ser útil para correlacionar problemas de sincronização com reinicializações ou indisponibilidade do sistema.

---

# 🖥️ Logs no terminal e no arquivo

Durante cada execução, a saída padrão e os erros são redirecionados para o arquivo de log:

```sh
exec >>"$LOG_FILE" 2>&1
```

Antes do próximo ciclo, o `stdout` e `stderr` originais são restaurados:

```sh
exec 1>&3 2>&4
exec 3>&- 4>&-
```

Assim, as mensagens da execução ficam registradas no arquivo sem deixar o terminal permanentemente redirecionado.

---

# 📌 Opções utilizadas no Rsync

O script utiliza:

```text
rsync -ahvi --delete --info=NAME0
```

### `-a`

Modo archive.

Preserva diversas propriedades dos arquivos, além de realizar a sincronização recursiva.

### `-h`

Exibe tamanhos em formato legível.

Exemplo:

```text
1.2G
500M
20K
```

### `-v`

Modo verbose, fornecendo informações sobre a operação.

### `-i`

Exibe informações sobre quais arquivos foram alterados.

### `--delete`

Remove do destino arquivos que não existem mais na origem.

### `--info=NAME0`

Reduz determinadas mensagens de nomes de arquivos do Rsync, deixando a saída mais adequada para o log.

---

# 🧪 Testando antes de executar

Antes de utilizar o script com `--delete`, é altamente recomendável realizar um teste.

Uma opção é adicionar temporariamente:

```text
--dry-run
```

Por exemplo:

```sh
rsync -ahvi --delete --dry-run "$HOME/Downloads" "$DESTINO"
```

O `--dry-run` simula a operação sem modificar o destino.

Isso permite verificar se:

* o destino está correto;
* os diretórios estão sendo interpretados corretamente;
* arquivos serão apagados;
* arquivos serão copiados;
* o comportamento está de acordo com o esperado.

---

# 🚨 Cuidados importantes

## 1. Verifique o `DESTINO`

Antes de iniciar o script, confirme:

```sh
DESTINO="/mnt/pendrive"
```

Um destino incorreto combinado com `--delete` pode causar perda de dados no diretório apontado.

---

## 2. O dispositivo precisa estar montado

O script pressupõe que:

```text
/mnt/pendrive
```

seja o ponto de montagem correto.

Se o dispositivo for desconectado ou desmontado, o comportamento do `rsync` deve ser avaliado cuidadosamente antes de utilizar o script em produção.

É recomendável implementar uma verificação de montagem caso o script seja utilizado como solução permanente.

---

## 3. O script não é um backup versionado

Embora seja utilizado como backup, o comportamento principal é de **sincronização/espelhamento**.

Com:

```text
--delete
```

uma exclusão na origem pode ser propagada para o destino.

Para proteção contra:

* exclusões acidentais;
* ransomware;
* corrupção de arquivos;
* versões anteriores;

é recomendável utilizar também uma estratégia de backup versionado ou snapshots.

---

# 📁 Estrutura esperada

Após executar o script, o repositório poderá ficar assim:

```text
.
├── backup.sh
└── logs/
    ├── 2026-09-10/
    │   ├── 16-00-00.log
    │   ├── 16-05-00.log
    │   └── 16-10-00.log
    ├── 2026-08.7z
    └── ...
```

---

# 🔧 Personalização

## Alterar o destino

Edite:

```sh
DESTINO="/mnt/pendrive"
```

---

## Alterar o intervalo

Atualmente:

```sh
sleep 300
```

Para executar a cada 10 minutos:

```sh
sleep 600
```

Para executar a cada 1 minuto:

```sh
sleep 60
```

---

## Adicionar outro diretório

Para sincronizar, por exemplo, `Desktop`:

```sh
echo "[6/8] Sincronizando diretório Desktop"
rsync -ahvi --delete --info=NAME0 "$HOME/Desktop" "$DESTINO" || \
    echo "ERRO: rsync de Desktop retornou código $?"
```

Depois, ajuste a numeração das etapas seguintes.

---

# ▶️ Execução em segundo plano

Para deixar o script executando mesmo após fechar o terminal, uma opção simples é:

```bash
nohup ./backup.sh > backup-console.log 2>&1 &
```

Para verificar o processo:

```bash
ps aux | grep backup.sh
```

Entretanto, para uso permanente, é mais indicado configurar o script como um serviço do sistema, por exemplo utilizando **systemd**.

---

# 🛑 Encerrando o script

Como o script utiliza:

```sh
while true
```

ele continuará executando indefinidamente.

Para interrompê-lo enquanto estiver no terminal:

```text
Ctrl+C
```

---

# 💡 Melhorias futuras

Algumas melhorias que podem ser implementadas:

* [ ] Verificar se o dispositivo de destino está realmente montado
* [ ] Verificar espaço livre antes do `rsync`
* [ ] Registrar códigos de retorno detalhados
* [ ] Enviar notificações em caso de erro
* [ ] Criar uma opção de `--dry-run`
* [ ] Permitir configurar diretórios por variáveis
* [ ] Implementar lock para impedir duas instâncias simultâneas
* [ ] Utilizar `systemd` para gerenciamento do serviço
* [ ] Adicionar retenção de arquivos `.7z` antigos
* [ ] Criar backups versionados
* [ ] Adicionar rotação dos logs
* [ ] Permitir configuração através de arquivo externo

---

# 📜 Licença

Este projeto pode ser utilizado, modificado e distribuído conforme os termos definidos.

<!-- Caso este projeto seja publicado com uma licença específica, substitua esta seção pela licença escolhida, por exemplo: -->

```text
MIT License
```

---

## ⚠️ Aviso

Este script realiza operações potencialmente destrutivas no destino devido ao uso do `rsync --delete`.

**Faça testes com `--dry-run` e confirme cuidadosamente o valor de `DESTINO` antes da primeira execução.**

O autor não se responsabiliza por perda de dados decorrente de configuração incorreta, falhas de armazenamento ou uso inadequado do script.
