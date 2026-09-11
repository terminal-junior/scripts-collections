# 🔐 Linux Security Auto Update

[![Shell Script](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash\&logoColor=white)](#)
[![Linux](https://img.shields.io/badge/OS-Linux-FCC624?logo=linux\&logoColor=black)](#)
[![Cron](https://img.shields.io/badge/Automation-Cron-222222?logo=clockify\&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](#license)
[![Status](https://img.shields.io/badge/Status-Stable-success)](#)

> **Automação de atualizações de segurança para sistemas Linux utilizando Bash.**

O **Linux Security Auto Update** é um script Bash desenvolvido para detectar automaticamente o gerenciador de pacotes disponível no sistema, verificar atualizações e aplicar correções de segurança de acordo com as capacidades de cada distribuição.

O projeto foi pensado para **ser simples, transparente, auditável e fácil de implantar em servidores Linux**, podendo ser executado manualmente ou de forma automatizada através do `cron`.

---

## ✨ Principais recursos

* 🐧 **Detecção automática da distribuição**
* 🔐 Atualizações de segurança quando suportadas pelo sistema
* 📦 Suporte a múltiplos gerenciadores de pacotes
* 📝 Registro das operações em arquivo de log
* ⏰ Execução automatizada através do `cron`
* 🚫 Não executa comandos em distribuições não reconhecidas
* 🖥️ Compatível com ambientes desktop e servidores
* ⚙️ Não depende de ferramentas externas complexas
* 🔎 Execução manual para validação e troubleshooting

---

## 🐧 Distribuições suportadas

| Distribuição / Família | Gerenciador | Estratégia                                     |
| ---------------------- | ----------- | ---------------------------------------------- |
| Debian                 | APT         | Atualizações de segurança                      |
| Ubuntu                 | APT         | Atualizações de segurança                      |
| Fedora                 | DNF         | Atualizações `security`                        |
| RHEL                   | DNF         | Atualizações `security`                        |
| Rocky Linux            | DNF         | Atualizações `security`                        |
| AlmaLinux              | DNF         | Atualizações `security`                        |
| openSUSE Leap          | Zypper      | Patches `security`                             |
| openSUSE Tumbleweed    | Zypper      | Conforme modelo de atualização da distribuição |
| Arch Linux             | Pacman      | Atualização geral                              |
| Manjaro                | Pacman      | Atualização geral                              |

> ⚠️ **Importante:** nem todas as distribuições possuem um mecanismo equivalente para separar atualizações de segurança das demais atualizações.

---

## 🏗️ Arquitetura

O fluxo de execução é simples:

```text
                         ┌──────────────────┐
                         │      Início      │
                         └────────┬─────────┘
                                  │
                                  ▼
                       ┌─────────────────────┐
                       │ Detectar gerenciador│
                       │     de pacotes      │
                       └──────────┬──────────┘
                                  │
             ┌────────────────────┼────────────────────┐
             │                    │                    │
             ▼                    ▼                    ▼
           ┌─────┐              ┌─────┐             ┌───────┐
           │ APT │              │ DNF │             │Zypper │
           └──┬──┘              └──┬──┘             └───┬───┘
              │                    │                    │
              │                    │                    │
              └────────────────────┼────────────────────┘
                                   │
                                   ▼
                              ┌──────────┐
                              │ Pacman  │
                              └────┬─────┘
                                   │
                                   ▼
                       ┌─────────────────────┐
                       │ Verificar updates   │
                       └──────────┬──────────┘
                                  │
                                  ▼
                       ┌─────────────────────┐
                       │ Aplicar atualizações│
                       └──────────┬──────────┘
                                  │
                                  ▼
                       ┌─────────────────────┐
                       │ Registrar resultado │
                       │       no log        │
                       └──────────┬──────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │    Finalização   │
                         └──────────────────┘
```

---

## 📁 Estrutura do projeto

Uma estrutura recomendada para o repositório:

```text
bash/
└── system/
    └── auto_update/
        ├── README.md
        └── auto_update.sh

```

### Arquivos

| Arquivo          | Descrição                   |
| ---------------- | --------------------------- |
| `auto_update.sh` | Script principal            |
| `README.md`      | Documentação do projeto     |
| `LICENSE`        | Licença open-source         |
<!-- | `.gitignore`     | Arquivos ignorados pelo Git |
| `docs/`          | Documentação complementar   | -->

---

# 🚀 Instalação

## Requisitos

Antes de instalar, certifique-se de que:

* O sistema utiliza uma distribuição Linux suportada;
* O Bash está disponível;
* O usuário possui privilégios administrativos;
* Os repositórios de pacotes estão corretamente configurados;
* Existe conectividade com os repositórios quando necessário.

Verifique o Bash:

```bash
bash --version
```

---

## 1. Clonar o repositório

```bash
git clone https://github.com/terminal-junior/scripts-collections.git
cd scripts-collections/bash/system/auto_update
```

<!-- > Substitua `SEU-USUARIO` pelo proprietário real do repositório. -->

---

## 2. Instalar o script

Copie o script para `/usr/local/bin`:

```bash
sudo cp auto_update.sh /usr/local/bin/auto_update.sh
```

Aplique as permissões:

```bash
sudo chmod 755 /usr/local/bin/auto_update.sh
```

Confirme:

```bash
ls -l /usr/local/bin/auto_update.sh
```

Resultado esperado:

```text
-rwxr-xr-x 1 root root ... /usr/local/bin/auto_update.sh
```

---

# ▶️ Utilização

## Execução manual

Execute:

```bash
sudo /usr/local/bin/auto_update.sh
```

O script detectará automaticamente o gerenciador de pacotes disponível e executará a rotina correspondente.

---

## 📋 Logs

Por padrão, os registros são armazenados em:

```text
/var/log/auto_update.log
```

Visualizar os últimos registros:

```bash
sudo tail -n 20 /var/log/auto_update.log
```

Acompanhar em tempo real:

```bash
sudo tail -f /var/log/auto_update.log
```

Exemplo:

```text
[2026-01-18 14:32:01] Verificando atualizações de segurança...
[2026-01-18 14:32:02] Sistema Debian/Ubuntu (APT)
[2026-01-18 14:32:05] Nenhuma atualização de segurança disponível.
[2026-01-18 14:32:05] Processo finalizado.
```

---

# ⏰ Automação com Cron

Para executar automaticamente, edite o `crontab` do usuário `root`:

```bash
sudo crontab -e
```

### Executar a cada 2 horas

```cron
0 */2 * * * /usr/local/bin/auto_update.sh
```

### Executar diariamente às 02:00

```cron
0 2 * * * /usr/local/bin/auto_update.sh
```

### Executar uma vez por semana

Exemplo: domingo às 03:00.

```cron
0 3 * * 0 /usr/local/bin/auto_update.sh
```

---

# 🔍 Verificação do Cron

Depois de configurar o agendamento, confirme a entrada:

```bash
sudo crontab -l
```

Para verificar mensagens relacionadas ao cron, utilize os mecanismos de log da sua distribuição.

Exemplos:

### Debian / Ubuntu

```bash
sudo journalctl -u cron
```

### Fedora / RHEL

```bash
sudo journalctl -u crond
```

---

# 🔐 Estratégia por gerenciador

O comportamento do script varia de acordo com o gerenciador de pacotes.

## APT

Em sistemas Debian/Ubuntu, o script:

1. Atualiza os índices de pacotes;
2. Verifica pacotes atualizáveis;
3. Identifica atualizações relacionadas a segurança;
4. Executa a rotina configurada para atualização.

Exemplo:

```bash
apt update -qq
```

A verificação pode utilizar:

```bash
apt list --upgradable 2>/dev/null | grep -i security
```

Quando o ambiente estiver configurado para utilizar `unattended-upgrades`, essa ferramenta pode ser utilizada para aplicar as atualizações apropriadas.

---

## DNF

Sistemas Fedora, RHEL, Rocky Linux e AlmaLinux podem utilizar:

```bash
dnf updateinfo list security --quiet
```

Para aplicar atualizações classificadas como de segurança:

```bash
dnf upgrade --security -y
```

---

## Zypper

Em sistemas openSUSE:

```bash
zypper list-patches --category security
```

Para aplicar patches classificados como segurança:

```bash
zypper patch --category security -y
```

---

## Pacman

No Arch Linux e Manjaro:

```bash
pacman -Qu
```

O Arch Linux não possui uma separação equivalente entre atualizações normais e atualizações de segurança.

Por isso, quando existem pacotes pendentes, a atualização é realizada de forma geral:

```bash
pacman -Su --noconfirm
```

> ⚠️ Isso significa que **Arch Linux e Manjaro não estão limitados exclusivamente a patches de segurança**.

O AUR também não é atualizado pelo `pacman` nesse processo.

---

# 🧪 Testes

Antes de habilitar a execução automática, sempre teste manualmente.

## 1. Executar

```bash
sudo /usr/local/bin/auto_update.sh
```

## 2. Verificar o log

```bash
sudo tail -n 20 /var/log/auto_update.log
```

## 3. Confirmar resultado

Procure mensagens indicando:

```text
Verificando atualizações...
```

e:

```text
Processo finalizado.
```

### Regra fundamental

> **Se o script não funciona manualmente, o `cron` não irá corrigir o problema.**

O `cron` possui um ambiente de execução diferente do seu terminal interativo. Portanto, problemas de caminho, permissões, variáveis de ambiente ou dependências devem ser resolvidos antes da automação.

---

# 🛡️ Segurança

Este projeto executa comandos administrativos e pode modificar pacotes instalados no sistema.

Por isso:

### Recomendações

* Execute inicialmente em ambiente de testes;
* Faça backup de servidores críticos;
* Utilize apenas repositórios confiáveis;
* Revise as configurações do gerenciador de pacotes;
* Monitore os logs;
* Não execute scripts modificados de fontes desconhecidas;
* Revise o código antes de instalar em produção;
* Defina uma política de reinicialização adequada.

### Princípio de menor privilégio

O script precisa de privilégios administrativos para instalar atualizações.

Por isso, recomenda-se:

```bash
sudo chmod 755 /usr/local/bin/auto_update.sh
```

e manter o arquivo sob propriedade de `root`:

```bash
sudo chown root:root /usr/local/bin/auto_update.sh
```

---

# ⚠️ Limitações conhecidas

| Limitação             | Descrição                                                                        |
| --------------------- | -------------------------------------------------------------------------------- |
| Arch / Manjaro        | Não possuem uma classificação de segurança equivalente ao DNF                    |
| APT                   | A identificação de pacotes de segurança depende da configuração dos repositórios |
| `unattended-upgrades` | Pode exigir configuração prévia                                                  |
| Repositórios          | Atualizações dependem da disponibilidade dos repositórios                        |
| Reinicialização       | O script não reinicia automaticamente o sistema                                  |
| AUR                   | Não é atualizado pelo `pacman`                                                   |
| Kernel                | Algumas atualizações podem exigir reboot para entrarem efetivamente em uso       |

---

# 🔄 Pós-atualização e reboot

O script **não reinicia automaticamente o sistema**.

Isso é intencional.

Reinicializações automáticas podem causar indisponibilidade inesperada em:

* Servidores;
* Máquinas virtuais;
* Sistemas críticos;
* Serviços de produção;
* Bancos de dados;
* Ambientes de alta disponibilidade.

A decisão de reiniciar deve fazer parte da política de manutenção do ambiente.

---

# 🐛 Troubleshooting

## O script não executa

Verifique as permissões:

```bash
ls -l /usr/local/bin/auto_update.sh
```

Teste diretamente com Bash:

```bash
sudo bash /usr/local/bin/auto_update.sh
```

---

## O cron não executa

Verifique o agendamento:

```bash
sudo crontab -l
```

Depois consulte o serviço:

```bash
sudo systemctl status cron
```

ou:

```bash
sudo systemctl status crond
```

---

## O gerenciador não foi detectado

Verifique manualmente:

```bash
command -v apt
command -v dnf
command -v zypper
command -v pacman
```

Pelo menos um deles deve retornar um caminho, por exemplo:

```text
/usr/bin/apt
```

---

## Não existem atualizações

Isso não necessariamente indica um problema.

O sistema pode simplesmente estar atualizado.

Verifique o log:

```bash
sudo tail -n 50 /var/log/auto_update.log
```

---

## O script funciona manualmente, mas não pelo cron

Verifique:

1. Caminhos absolutos dos comandos;
2. Permissões;
3. Ambiente do `cron`;
4. Logs do sistema;
5. Serviço `cron`/`crond`;
6. Permissões do arquivo de log.

---

# 📊 Exit Codes

Para facilitar automação e monitoramento, recomenda-se utilizar códigos de saída consistentes.

| Código | Significado                        |
| -----: | ---------------------------------- |
|    `0` | Execução concluída                 |
|    `1` | Erro ou distribuição não suportada |
|    `2` | Falha na verificação/atualização   |

> A implementação final dos códigos depende da versão do `auto_update.sh` utilizada.

---

# 🗺️ Roadmap

Possíveis melhorias futuras:

* [ ] Suporte a `systemd timers`
* [ ] Rotação automática dos logs
<!-- * [ ] Notificações por e-mail
* [ ] Integração com Slack/Discord -->
* [ ] Relatório de pacotes atualizados
* [ ] Detecção de necessidade de reboot
* [ ] Modo `--dry-run`
<!-- * [ ] Arquivo de configuração externo -->
* [ ] Argumentos CLI (`--check`, `--update`, `--verbose`)
* [ ] Testes automatizados
<!-- * [ ] CI com GitHub Actions -->
* [ ] Melhor tratamento de erros
* [ ] Lock para impedir execuções simultâneas

---

# 🤝 Contribuindo

Contribuições são bem-vindas!

## Fluxo recomendado

1. Faça um fork do projeto;
2. Crie uma branch para sua alteração:

```bash
git checkout -b feature/minha-melhoria
```

3. Faça suas alterações;
4. Teste em uma distribuição compatível;
5. Faça o commit:

```bash
git commit -m "feat: adiciona nova funcionalidade"
```

6. Envie a branch:

```bash
git push origin feature/minha-melhoria
```

7. Abra um Pull Request.

### Antes de enviar um Pull Request

Certifique-se de:

* [ ] O script continua executável;
* [ ] Não existem comandos destrutivos desnecessários;
* [ ] A alteração foi testada;
* [ ] A documentação foi atualizada;
* [ ] O log continua funcionando;
* [ ] O comportamento em caso de erro foi validado.

---

# 📝 Versionamento

O projeto recomenda seguir [Semantic Versioning](https://semver.org/).

Formato:

```text
MAJOR.MINOR.PATCH
```

Exemplo:

```text
v1.2.0
```

Onde:

* **MAJOR** — alterações incompatíveis;
* **MINOR** — novas funcionalidades compatíveis;
* **PATCH** — correções e melhorias compatíveis.

---

# 📜 Licença

Este projeto está disponível sob a licença **MIT**.

Consulte o arquivo [`LICENSE`](LICENSE) para obter o texto completo da licença.

---

# ⚖️ Disclaimer

Este software pode executar operações privilegiadas e modificar componentes do sistema operacional.

O autor e os colaboradores não se responsabilizam por indisponibilidade, perda de dados, incompatibilidade de pacotes ou qualquer outro dano decorrente do uso do software.

**Sempre valide o comportamento em ambiente de testes antes de utilizá-lo em produção.**

---

# ⭐ Contribua

Se este projeto foi útil para você, considere deixar uma ⭐ no GitHub.

Issues, sugestões, melhorias e Pull Requests são bem-vindos.

---

<p align="center">
  <strong>Linux Security Auto Update</strong><br>
  Automação simples, transparente e auditável para manutenção de sistemas Linux.
</p>
