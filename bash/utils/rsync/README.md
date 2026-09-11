# 🔄 Backup Contínuo com Rsync

[![Shell](https://img.shields.io/badge/Shell-POSIX--sh-4EAA25?logo=gnu-bash\&logoColor=white)](https://www.gnu.org/software/bash/)
[![Rsync](https://img.shields.io/badge/rsync-backup-blue)](https://rsync.samba.org/)
[![7--Zip](https://img.shields.io/badge/7--Zip-compression-orange)](https://www.7-zip.org/)
[![Linux](https://img.shields.io/badge/platform-Linux-lightgrey?logo=linux\&logoColor=white)](https://www.kernel.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#-licença)

Script de **backup contínuo e sincronização automática** para Linux utilizando `rsync`, com geração de logs detalhados e compactação mensal automática dos logs antigos utilizando `7zz`.

O objetivo é manter diretórios pessoais sincronizados com um dispositivo de armazenamento externo, como **pendrive, HD externo ou SSD**, enquanto mantém um histórico organizado das execuções.

---

## 📑 Sumário

* [✨ Características](#-características)
* [🏗️ Arquitetura](#️-arquitetura)
* [🔄 Fluxo de execução](#-fluxo-de-execução)
* [📋 Requisitos](#-requisitos)
* [📥 Instalação](#-instalação)
* [⚙️ Configuração](#️-configuração)
* [📂 Diretórios sincronizados](#-diretórios-sincronizados)
* [📝 Sistema de logs](#-sistema-de-logs)
* [🗜️ Compactação mensal](#️-compactação-mensal)
* [🔐 Estratégia de segurança](#-estratégia-de-segurança)
* [⏱️ Intervalo de execução](#️-intervalo-de-execução)
* [🖥️ Executando manualmente](#️-executando-manualmente)
* [⚙️ Executando como serviço systemd](#️-executando-como-serviço-systemd)
* [🧪 Testes](#-testes)
* [📊 Exemplos de saída](#-exemplos-de-saída)
* [⚠️ Considerações importantes](#️-considerações-importantes)
* [🛠️ Troubleshooting](#️-troubleshooting)
* [💡 Melhorias futuras](#-melhorias-futuras)
* [📄 Licença](#-licença)

---

# ✨ Características

* 🔄 Sincronização automática a cada **5 minutos**
* 💾 Suporte a dispositivos externos de armazenamento
* 📁 Sincronização de diretórios pessoais
* 🗑️ Espelhamento utilizando `rsync --delete`
* 📝 Um arquivo de log para cada execução
* 📅 Organização dos logs por data
* 🗜️ Compactação automática dos meses anteriores
* 🔐 Compressão máxima com `7zz -mx=9`
* ♻️ Logs originais removidos somente após compactação bem-sucedida
* 🚫 Exclusão configurável de diretórios específicos
* 📊 Registro do uptime do sistema
* 🖥️ Saída simultaneamente registrada no terminal e nos arquivos de log
* 🔁 Execução contínua através de loop infinito
* ⚙️ Pode ser executado como serviço `systemd`

---

# 🏗️ Arquitetura

A arquitetura do script é baseada em três componentes principais:

```text
                         ┌──────────────────────┐
                         │      SISTEMA         │
                         │       Linux          │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │      backup.sh       │
                         │                      │
                         │  Loop principal     │
                         └──────────┬───────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
          ┌─────────────────┐             ┌──────────────────┐
          │     Rsync       │             │  Gerenciamento   │
          │                 │             │     de logs      │
          └────────┬────────┘             └────────┬─────────┘
                   │                               │
                   ▼                               ▼
          ┌─────────────────┐             ┌──────────────────┐
          │     DESTINO     │             │ logs/YYYY-MM-DD/ │
          │                 │             │                  │
          │ /mnt/pendrive   │             │ HH-MM-SS.log     │
          └─────────────────┘             └────────┬─────────┘
                                                    │
                                                    ▼
                                           ┌──────────────────┐
                                           │ Compactação 7z   │
                                           │                  │
                                           │ YYYY-MM.7z       │
                                           └──────────────────┘
```

### Componentes

| Componente  | Responsabilidade                                      |
| ----------- | ----------------------------------------------------- |
| `backup.sh` | Controla todo o processo                              |
| `rsync`     | Sincroniza os arquivos                                |
| `7zz`       | Compacta os logs antigos                              |
| `logs/`     | Armazena o histórico das execuções                    |
| `DESTINO`   | Local onde os arquivos são sincronizados              |
| `systemd`   | Opcionalmente mantém o script executando como serviço |

---

# 🔄 Fluxo de execução

A cada ciclo, o script executa as seguintes etapas:

```text
┌───────────────────────┐
│      Início           │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Verifica meses antigos│
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Compacta logs antigos │
│       com 7zz         │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Cria diretório de log │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Rsync Downloads       │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Rsync Pictures        │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Rsync Videos          │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Rsync Music           │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Rsync Documents       │
└──────────┬────────────┘
           │
           ▼
┌───────────────────────┐
│ Aguarda 300 segundos  │
└──────────┬────────────┘
           │
           └──────────────► Novo ciclo
```

---

# 📋 Requisitos

O script foi desenvolvido para ambientes Linux com suporte a Shell POSIX.

### Dependências

| Dependência | Função                             |
| ----------- | ---------------------------------- |
| `sh`        | Interpretador do script            |
| `rsync`     | Sincronização                      |
| `7zz`       | Compactação                        |
| `find`      | Localização dos diretórios de logs |
| `date`      | Data e hora                        |
| `awk`       | Cálculo do uptime                  |
| `mkdir`     | Criação de diretórios              |
| `rm`        | Remoção de arquivos                |
| `sleep`     | Controle do intervalo              |
| `clear`     | Limpeza do terminal                |

### Debian / Ubuntu

```bash
sudo apt update
sudo apt install rsync p7zip-full
```

Verifique:

```bash
command -v rsync
command -v 7zz
```

Saída esperada, por exemplo:

```text
/usr/bin/rsync
/usr/bin/7zz
```

> Dependendo da distribuição Linux, o pacote ou o executável do 7-Zip pode possuir um nome diferente.

---

# 📥 Instalação

Clone o projeto:

```bash
git clone https://github.com/terminal-junior/script-collections.git
cd script-collections/bash/utils/rsync/
```

Dê permissão de execução:

```bash
chmod +x backup.sh
```

Execute:

```bash
./backup.sh
```

---

# ⚙️ Configuração

A principal configuração está no início do script:

```sh
DESTINO="/mnt/pendrive"
```

Altere para o ponto de montagem desejado.

Exemplo:

```sh
DESTINO="/media/$USER/Backup"
```

ou:

```sh
DESTINO="/mnt/backup"
```

O diretório do projeto é detectado automaticamente:

```sh
BASE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
```

Os logs serão armazenados automaticamente em:

```text
<diretório-do-script>/logs/
```

---

# 📂 Diretórios sincronizados

Atualmente, o script sincroniza:

```text
$HOME/Downloads
$HOME/Pictures
$HOME/Videos
$HOME/Music
$HOME/Documents
```

A estrutura no destino será semelhante a:

```text
/mnt/pendrive/
├── Downloads/
├── Pictures/
├── Videos/
├── Music/
└── Documents/
```

O diretório abaixo é excluído da sincronização:

```text
Documents/storage/
```

Isso ocorre através de:

```sh
--exclude='storage/'
```

---

# 📝 Sistema de logs

Cada execução cria um novo arquivo de log.

Exemplo:

```text
logs/
├── 2026-09-10/
│   ├── 15-00-00.log
│   ├── 15-05-00.log
│   ├── 15-10-00.log
│   └── 15-15-00.log
│
└── 2026-09-11/
    ├── 00-00-00.log
    └── 00-05-00.log
```

O formato é:

```text
logs/YYYY-MM-DD/HH-MM-SS.log
```

Cada execução registra:

* início;
* data e hora;
* uptime;
* caminho do log;
* etapas do backup;
* arquivos modificados;
* erros do `rsync`;
* conclusão;
* data e hora final;
* uptime final.

---

# 🗜️ Compactação mensal

No início de cada ciclo, o script verifica se existem logs de meses anteriores.

Por exemplo:

```text
logs/
├── 2026-08-01/
├── 2026-08-02/
├── 2026-08-03/
├── ...
└── 2026-09-01/
```

Quando o mês atual é setembro, os logs de agosto podem ser compactados:

```text
logs/
└── 2026-08.7z
```

O comando utilizado é:

```sh
7zz a -mx=9 "$ARQUIVO" "$MES_DIR"-??
```

### Compressão máxima

O parâmetro:

```text
-mx=9
```

solicita o nível máximo de compressão disponível.

---

# 🔐 Estratégia de segurança

A remoção dos logs originais ocorre **somente após o sucesso da compactação**.

```text
          Diretórios do mês
                  │
                  ▼
              ┌───────┐
              │  7zz  │
              └───┬───┘
                  │
           ┌──────┴──────┐
           │             │
        SUCESSO         ERRO
           │             │
           ▼             ▼
       Remove          Mantém
       diretórios     diretórios
           │
           ▼
       arquivo .7z
```

Em caso de erro:

```sh
rm -f "$ARQUIVO"
```

O arquivo `.7z` incompleto é removido e os diretórios originais permanecem intactos.

---

# ⏱️ Intervalo de execução

O intervalo padrão é de:

```text
300 segundos
```

ou:

```text
5 minutos
```

Definido por:

```sh
sleep 300
```

Para alterar para 10 minutos:

```sh
sleep 600
```

Para 1 minuto:

```sh
sleep 60
```

> O intervalo é iniciado após o término do ciclo anterior. Portanto, o tempo real entre dois inícios será maior que o valor do `sleep`.

---

# 🖥️ Executando manualmente

Após configurar o destino:

```bash
./backup.sh
```

Durante a execução, será exibido algo semelhante a:

```text
============================================================
Inicio - Data: 11/09/2026 02:00:03 | Uptime: 4d 12h 32m 10s
Log: /home/user/backup/logs/2026-09-11/02-00-03.log
============================================================

[1/7] Inicializando Rsync

[2/7] Sincronizando diretório Downloads
Itens alterados nesta execução:

[3/7] Sincronizando diretório Picture
Itens alterados nesta execução:

[4/7] Sincronizando diretório Videos
Itens alterados nesta execução:

[5/7] Sincronizando diretório Music
Itens alterados nesta execução:

[6/7] Sincronizando diretório Documents
Itens alterados nesta execução:

[7/7] Sincronização concluída!

Fim - Data: 11/09/2026 02:00:38 | Uptime: 4d 12h 32m 45s
============================================================
```

Após aproximadamente 5 minutos, o ciclo será executado novamente.

---

# 📊 Exemplos de saída do Rsync

Quando um arquivo é alterado, o log poderá apresentar informações como:

```text
>f..t...... Downloads/arquivo.zip
>f+++++++++ Pictures/foto.jpg
*deleting   Documents/arquivo-antigo.txt
```

Essas mensagens indicam arquivos modificados, adicionados ou removidos.

---

# ⚙️ Executando como serviço systemd

Para uso contínuo, recomenda-se executar o script através do `systemd`.

Isso permite:

* iniciar automaticamente com o sistema;
* reiniciar o script caso ele seja encerrado;
* consultar o status;
* visualizar logs;
* controlar o processo com `systemctl`.

## 1. Instale o script

Por exemplo:

```bash
sudo mkdir -p /opt/backup-rsync
sudo cp backup.sh /opt/backup-rsync/
sudo chmod +x /opt/backup-rsync/backup.sh
```

---

## 2. Configure o destino

Edite:

```bash
sudo nano /opt/backup-rsync/backup.sh
```

Configure:

```sh
DESTINO="/mnt/pendrive"
```

> O `DESTINO` deve estar montado antes da execução do serviço.

---

## 3. Crie o usuário do serviço

O ideal é executar o backup como o próprio usuário que possui os diretórios em `$HOME`.

Por exemplo, se o usuário for `usuario`, o serviço deverá utilizar:

```ini
User=usuario
Group=usuario
```

Não é recomendado executar este script como `root` sem necessidade.

---

## 4. Crie o serviço

Crie:

```bash
sudo nano /etc/systemd/system/backup-rsync.service
```

Utilize:

```ini
[Unit]
Description=Backup contínuo com Rsync
After=local-fs.target
Wants=local-fs.target

[Service]
Type=simple

User=usuario
Group=usuario

ExecStart=/opt/backup-rsync/backup.sh

Restart=always
RestartSec=10

Environment=HOME=/home/usuario

[Install]
WantedBy=multi-user.target
```

Substitua:

```text
usuario
```

pelo usuário Linux responsável pelos arquivos.

---

## 5. Recarregue o systemd

```bash
sudo systemctl daemon-reload
```

---

## 6. Inicie o serviço

```bash
sudo systemctl start backup-rsync.service
```

---

## 7. Verifique o status

```bash
sudo systemctl status backup-rsync.service
```

Um resultado esperado:

```text
● backup-rsync.service - Backup contínuo com Rsync
     Loaded: loaded (/etc/systemd/system/backup-rsync.service)
     Active: active (running)
```

---

## 8. Habilite o início automático

Para iniciar automaticamente com o sistema:

```bash
sudo systemctl enable backup-rsync.service
```

Ou faça as duas operações de uma vez:

```bash
sudo systemctl enable --now backup-rsync.service
```

---

## 9. Parar o serviço

```bash
sudo systemctl stop backup-rsync.service
```

---

## 10. Reiniciar

```bash
sudo systemctl restart backup-rsync.service
```

---

## 11. Desabilitar inicialização automática

```bash
sudo systemctl disable backup-rsync.service
```

---

# 📜 Logs do systemd

Embora o script possua seu próprio sistema de logs, o `systemd` também registra a saída do serviço.

Para acompanhar em tempo real:

```bash
journalctl -u backup-rsync.service -f
```

Para consultar as últimas mensagens:

```bash
journalctl -u backup-rsync.service -n 100
```

Para consultar logs desde o boot atual:

```bash
journalctl -u backup-rsync.service -b
```

---

# 💾 Montagem do dispositivo

O serviço pressupõe que o destino esteja disponível.

Por exemplo:

```text
/mnt/pendrive
```

Antes de iniciar o backup, confirme:

```bash
mountpoint /mnt/pendrive
```

Se estiver montado:

```text
/mnt/pendrive is a mountpoint
```

Também é possível verificar:

```bash
findmnt /mnt/pendrive
```

### ⚠️ Importante

O script atualmente **não verifica explicitamente se `DESTINO` é um ponto de montagem**.

Isso é especialmente importante por causa do:

```text
--delete
```

Uma melhoria recomendada para uma versão futura é impedir a execução do `rsync` caso o dispositivo esperado não esteja montado.

---

# 🧪 Testes

Antes de utilizar o script em produção, recomenda-se testar cada componente individualmente.

## Testar o Rsync

Utilize temporariamente:

```text
--dry-run
```

Exemplo:

```bash
rsync -ahvi --delete --dry-run \
    "$HOME/Downloads" \
    "$DESTINO"
```

O `--dry-run` simula a operação sem alterar o destino.

---

## Testar o 7-Zip

Teste manualmente:

```bash
7zz a -mx=9 teste.7z logs/2026-08-01
```

Verifique:

```bash
7zz t teste.7z
```

O comando `t` testa a integridade do arquivo compactado.

---

## Testar o script

Antes de executar continuamente:

```bash
./backup.sh
```

confirme:

1. `DESTINO` está correto;
2. o dispositivo está montado;
3. `rsync` está instalado;
4. `7zz` está instalado;
5. o usuário possui permissão nos diretórios;
6. o destino possui espaço suficiente.

---

# ⚠️ Considerações importantes

## `--delete` pode remover arquivos

O script utiliza:

```text
rsync --delete
```

Isso transforma o destino em um **espelho da origem**.

Exemplo:

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

Se `arquivo2.txt` for apagado da origem:

```text
Origem:
Documents/
└── arquivo1.txt
```

ele também poderá ser removido do destino.

### Portanto:

> **Este projeto é uma ferramenta de sincronização contínua, não um sistema completo de backup versionado.**

---

# 🛡️ Backup x sincronização

É importante entender a diferença:

| Recurso                          | Este script  |
| -------------------------------- | ----------:  |
| Sincronização                    |           ✅ |
| Espelhamento                     |           ✅ |
| Backup de arquivos atuais        |           ✅ |
| Histórico de versões             |           ❌ |
| Recuperação de arquivos apagados |           ❌ |
| Proteção contra ransomware       |           ❌ |
| Snapshots                        |           ❌ |
| Compactação dos logs             |           ✅ |

Para uma estratégia de backup mais robusta, recomenda-se utilizar múltiplas cópias e, preferencialmente, algum mecanismo de versionamento ou snapshot.

---

# 🛠️ Troubleshooting

## `7zz: command not found`

Instale o 7-Zip ou confirme o nome do executável:

```bash
command -v 7zz
```

Caso sua distribuição utilize outro nome, adapte o script.

---

## `rsync: command not found`

Instale:

```bash
sudo apt install rsync
```

---

## Permission denied

Verifique as permissões:

```bash
ls -ld "$HOME/Downloads"
ls -ld "$DESTINO"
```

Quando executado via `systemd`, confirme principalmente:

```ini
User=usuario
Group=usuario
Environment=HOME=/home/usuario
```

---

## O serviço não inicia

Verifique:

```bash
systemctl status backup-rsync.service
```

Depois:

```bash
journalctl -u backup-rsync.service -n 100 --no-pager
```

Confirme também:

```bash
ls -l /opt/backup-rsync/backup.sh
```

O script deve possuir permissão de execução.

---

## O destino não está sendo encontrado

Confirme:

```bash
mountpoint /mnt/pendrive
```

e:

```bash
findmnt /mnt/pendrive
```

---

## Arquivos foram apagados do destino

Verifique se o comportamento está relacionado ao:

```text
--delete
```

Caso não queira que arquivos sejam removidos do destino quando desaparecerem da origem, remova essa opção.

> Faça isso conscientemente: sem `--delete`, o destino deixa de ser um espelho exato da origem.

---

# 📁 Estrutura do projeto

Uma estrutura recomendada para o repositório:

```text
rsync/
├── rsync.sh
├── README.md
├── LICENSE
└── systemd/
    └── rsync.service
```

O diretório `logs/` pode ser criado automaticamente pelo script e, dependendo da estratégia do projeto, pode ser incluído no `.gitignore`:

```gitignore
logs/
```

---

# 💡 Melhorias futuras

* [ ] Verificar automaticamente se `DESTINO` está montado
* [ ] Impedir execução quando o destino não estiver disponível
* [ ] Verificar espaço livre antes do backup
* [ ] Implementar lock para impedir múltiplas instâncias
* [ ] Adicionar suporte a `--dry-run`
* [ ] Permitir configuração através de arquivo externo
* [ ] Adicionar notificações de erro
* [ ] Criar sistema de retenção dos arquivos `.7z`
* [ ] Implementar backup versionado
* [ ] Adicionar snapshots
* [ ] Melhorar tratamento de códigos de retorno do `rsync`
* [ ] Criar testes automatizados
* [ ] Adicionar configuração `systemd` ao repositório
* [ ] Adicionar verificação de integridade dos arquivos `.7z`
* [ ] Permitir seleção dos diretórios através de configuração

---

# 📄 Licença

Este projeto está disponível sob a licença MIT.

```text
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

# ⚠️ Aviso

Este software executa operações de sincronização potencialmente destrutivas devido ao uso do:

```text
rsync --delete
```

**Sempre valide o destino antes da primeira execução e utilize `--dry-run` durante os testes.**

Mantenha cópias adicionais dos dados importantes. Um único dispositivo de armazenamento não deve ser considerado uma estratégia completa de backup.

---

## ⭐ Contribuições

Pull requests, sugestões e melhorias são bem-vindas.

Antes de enviar alterações, recomenda-se testar o script em um ambiente controlado e verificar especialmente qualquer modificação relacionada ao `rsync --delete`.

---

## 📌 Resumo

```text
┌──────────────────────────────────────────────┐
│              BACKUP CONTÍNUO                 │
├──────────────────────────────────────────────┤
│                                              │
│  $HOME/Downloads  ──────┐                    │
│  $HOME/Pictures   ──────┤                    │
│  $HOME/Videos     ──────┤                    │
│  $HOME/Music      ──────┤──► Rsync ──►       │
│  $HOME/Documents  ──────┘          /mnt/...  │
│                                              │
│  Logs ──► YYYY-MM-DD/HH-MM-SS.log            │
│                                              │
│  Mês anterior ──► YYYY-MM.7z                 │
│                                              │
│  Execução ──► a cada 5 minutos               │
│                                              │
└──────────────────────────────────────────────┘
```

**Backup contínuo, simples e automatizado para ambientes Linux.**
