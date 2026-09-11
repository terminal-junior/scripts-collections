# 🛠️ Bash Utils

[![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash\&logoColor=white)](#)
[![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux\&logoColor=black)](#)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-Compatible-success?logo=gnu-bash\&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Repository](https://img.shields.io/badge/Repository-Scripts%20Collections-181717?logo=github\&logoColor=white)](https://github.com/terminal-junior/scripts-collections)

> 🐧 Coleção de utilitários Bash para **automação, manutenção, diagnóstico e administração de sistemas Linux**.

---

## 📖 Sobre

Este diretório reúne scripts Bash independentes desenvolvidos para resolver tarefas práticas do dia a dia em ambientes Linux.

A proposta é manter cada ferramenta:

* 🧩 Independente
* 📚 Documentada
* 🔧 Fácil de modificar
* ⚡ Simples de executar
* 🔐 Consciente em relação a privilégios
* 🐧 Compatível com ambientes Linux sempre que possível

Cada utilitário possui sua própria documentação com detalhes sobre instalação, configuração, funcionamento, limitações e troubleshooting.

---

## 📂 Utilitários

| Utilitário          | Descrição                                                              | Categoria        |
| ------------------- | ---------------------------------------------------------------------- | ---------------- |
| [`fetch`](./fetch/) | Instala e executa Fastfetch ou Neofetch automaticamente                | 🖥️ System Info  |
| [`rsync`](./rsync/) | Sincronização contínua de diretórios com Rsync e gerenciamento de logs | 💾 Backup / Sync |

---

# 🖥️ Fetch

### Fastfetch / Neofetch Installer

Automatiza a instalação e execução do **Fastfetch**, utilizando o **Neofetch como fallback** quando necessário.

O script detecta automaticamente o gerenciador de pacotes disponível e trabalha com:

```text
APT
DNF
Pacman
Zypper
```

### ✨ Recursos

* 🔎 Detecta automaticamente o gerenciador de pacotes
* ⚡ Prioriza Fastfetch
* 🔄 Utiliza Neofetch como fallback
* 📦 Instala automaticamente quando necessário
* 🚫 Evita instalações desnecessárias
* 🐧 Suporta múltiplas distribuições Linux
* ❌ Utiliza códigos de saída para indicar falhas

### 📁 Estrutura

```text
fetch/
├── installer.sh
└── README.md
```

### 🚀 Execução rápida

```bash
cd fetch
chmod +x installer.sh
./installer.sh
```

### 📚 Documentação

Consulte a documentação completa:

**[`fetch/README.md`](./fetch/README.md)**

---

# 💾 Rsync

### Backup Contínuo com Rsync

Ferramenta Bash para sincronização contínua de diretórios pessoais com um dispositivo de armazenamento externo utilizando `rsync`.

O projeto também possui gerenciamento de logs e compactação mensal dos logs antigos utilizando `7zz`.

### ✨ Recursos

* 🔄 Sincronização automática
* 💾 Suporte a armazenamento externo
* 📁 Sincronização de diretórios pessoais
* 🗑️ Espelhamento com `rsync --delete`
* 📝 Logs individuais por execução
* 📅 Organização dos logs por data
* 🗜️ Compactação mensal dos logs
* 📊 Registro de informações da execução
* ⏱️ Execução contínua
* ⚙️ Possibilidade de execução via `systemd`

### 📂 Diretórios sincronizados

A configuração atual contempla:

```text
$HOME/Downloads
$HOME/Pictures
$HOME/Videos
$HOME/Music
$HOME/Documents
```

O destino é configurável no script.

### ⚠️ Atenção ao `--delete`

O utilitário utiliza:

```bash
rsync --delete
```

Isso significa que arquivos removidos da origem **também podem ser removidos do destino**.

Portanto, o projeto deve ser entendido principalmente como uma ferramenta de **sincronização e espelhamento**, e não como um sistema completo de backup versionado.

> ⚠️ Sempre valide o destino antes da primeira execução e utilize `--dry-run` durante os testes.

### 📁 Estrutura

```text
rsync/
├── rsync.sh
└── README.md
```

### 📚 Documentação

Consulte a documentação completa:

**[`rsync/README.md`](./rsync/README.md)**

---

## 🧰 Dependências

As dependências variam conforme o utilitário.

| Ferramenta | Bash | Rsync | 7-Zip |
| ---------- | :--: | :---: | :---: |
| `fetch`    |   ✅  |   —   |   —   |
| `rsync`    |   ✅  |   ✅   |   ✅   |

### Verificação rápida

```bash
command -v bash
command -v rsync
command -v 7zz
```

> Nem todas as dependências são necessárias para todos os scripts.

---

## 🖥️ Compatibilidade

Os scripts deste diretório são destinados principalmente a sistemas **Linux**.

### Distribuições

A compatibilidade pode variar conforme o utilitário.

```text
Debian
Ubuntu
Fedora
RHEL
Arch Linux
Manjaro
openSUSE
e derivados
```

> A compatibilidade real depende das ferramentas disponíveis no sistema e das dependências específicas de cada script.

Consulte sempre o README individual antes da execução.

---

## 🚀 Clonando o Repositório

Clone o projeto principal:

```bash
git clone https://github.com/terminal-junior/scripts-collections.git
```

Entre no diretório:

```bash
cd scripts-collections/bash/utils
```

Liste os utilitários disponíveis:

```bash
ls -la
```

Estrutura atual:

```text
bash/
└── utils/
    ├── fetch/
    │   ├── installer.sh
    │   └── README.md
    │
    ├── rsync/
    │   ├── rsync.sh
    │   └── README.md
    │
    └── README.md
```

---

## 🔐 Segurança

Os scripts desta coleção podem executar operações que modificam o sistema ou os dados do usuário.

Antes de executar qualquer ferramenta:

### 1. Leia o código

```bash
less script.sh
```

ou:

```bash
cat script.sh
```

### 2. Verifique as dependências

```bash
command -v bash
command -v rsync
command -v 7zz
```

### 3. Verifique permissões

Tenha atenção especial a scripts que utilizem:

```text
sudo
rm
rsync --delete
chmod
chown
systemctl
apt
dnf
pacman
zypper
```

Esses comandos não são necessariamente inseguros, mas podem causar alterações significativas dependendo de como forem utilizados.

> **Regra principal:** não execute um script com privilégios elevados antes de entender o que ele faz.

---

## 🧪 Testes

Antes de utilizar os scripts em máquinas importantes, recomenda-se realizar testes em ambiente controlado.

### Bash

Valide a sintaxe:

```bash
bash -n script.sh
```

### ShellCheck

Quando disponível:

```bash
shellcheck script.sh
```

### Rsync

Para operações de sincronização, prefira testar primeiro com:

```bash
rsync --dry-run ...
```

O modo `--dry-run` permite visualizar as alterações sem efetivamente modificar o destino.

---

## 📝 Padrão dos Projetos

Cada utilitário deve, preferencialmente, possuir sua própria documentação.

Estrutura recomendada:

```text
utility/
├── script.sh
├── README.md
└── systemd/
    └── service
```

Quando necessário, também podem ser adicionados:

```text
tests/
examples/
config/
docs/
```

---

## 📋 Filosofia

Os utilitários deste diretório seguem alguns princípios simples:

```text
Simplicidade
     ↓
Automação
     ↓
Reutilização
     ↓
Documentação
     ↓
Segurança
     ↓
Manutenção
```

A intenção não é substituir ferramentas profissionais ou sistemas especializados, mas disponibilizar **soluções pequenas e práticas para problemas específicos**.

---

## 🗺️ Roadmap

Possíveis melhorias para este diretório:

* [ ] Adicionar novos utilitários Bash
* [ ] Padronizar argumentos CLI
* [ ] Implementar `--help`
* [ ] Implementar `--version`
* [ ] Adicionar `--dry-run` quando aplicável
* [ ] Melhorar tratamento de erros
* [ ] Padronizar códigos de saída
* [ ] Adicionar testes automatizados
* [ ] Integrar ShellCheck via GitHub Actions
* [ ] Padronizar documentação
* [ ] Criar índice automático dos utilitários

---

## 🤝 Contribuindo

Contribuições são bem-vindas.

Para adicionar um novo utilitário:

1. Crie um diretório dentro de `bash/utils/`.
2. Adicione o script Bash.
3. Crie um `README.md` específico.
4. Documente requisitos e dependências.
5. Teste o script.
6. Execute `bash -n`.
7. Execute o ShellCheck quando possível.
8. Documente limitações e riscos.
9. Abra um Pull Request.

Exemplo:

```bash
git checkout -b feature/new-bash-utility
```

Depois:

```bash
git add bash/utils/
git commit -m "feat: add new bash utility"
git push origin feature/new-bash-utility
```

---

## 📜 Licença

Os utilitários deste diretório fazem parte do projeto **Scripts Collections** e são distribuídos sob a licença **MIT**.

Consulte o arquivo [`LICENSE`](../../LICENSE) para os termos completos.

---

## ⚠️ Disclaimer

Os scripts são fornecidos **"como estão"**, sem garantia de funcionamento em todos os ambientes.

O usuário é responsável por:

* Validar o código antes da execução
* Confirmar as dependências
* Verificar permissões
* Testar alterações
* Manter backups adequados
* Avaliar os riscos de cada operação

Em especial, ferramentas que realizam sincronização, exclusão ou alterações administrativas devem ser utilizadas com atenção.

---

## ⭐ Utilitários Disponíveis

| Projeto       | Finalidade             | Documentação                  |
| ------------- | ---------------------- | ----------------------------- |
| 🖥️ **Fetch** | Fastfetch / Neofetch   | [`README`](./fetch/README.md) |
| 💾 **Rsync**  | Sincronização e backup | [`README`](./rsync/README.md) |

---

<div align="center">

### 🛠️ Bash Utils

**Small scripts. Practical automation. Linux focused.**

Parte do projeto **Scripts Collections**

⭐ Se algum utilitário foi útil para você, considere deixar uma estrela no repositório.

</div>
