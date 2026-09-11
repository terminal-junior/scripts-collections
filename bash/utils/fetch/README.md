# 🖥️ Fastfetch / Neofetch Installer

[![Shell Script](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash\&logoColor=white)](#)
[![Linux](https://img.shields.io/badge/OS-Linux-FCC624?logo=linux\&logoColor=black)](#)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-Passed-success?logo=gnu-bash\&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Stable-success)](#)
[![GitHub Stars](https://img.shields.io/github/stars/SEU-USUARIO/fastfetch-neofetch-installer?style=flat\&logo=github)](https://github.com/SEU-USUARIO/fastfetch-neofetch-installer/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/SEU-USUARIO/fastfetch-neofetch-installer?style=flat\&logo=github)](https://github.com/SEU-USUARIO/fastfetch-neofetch-installer/issues)

> **Automação simples para instalar e executar Fastfetch ou Neofetch em diferentes distribuições Linux.**

O **Fastfetch / Neofetch Installer** é um script Bash desenvolvido para detectar automaticamente o gerenciador de pacotes disponível no sistema, verificar se o Fastfetch ou Neofetch já está instalado e, quando necessário, realizar a instalação de forma automatizada.

O projeto foi desenvolvido com foco em **simplicidade, portabilidade, automação e facilidade de manutenção**.

---

## ✨ Principais recursos

* 🐧 Detecção automática do gerenciador de pacotes
* 📦 Suporte a múltiplas distribuições Linux
* ⚡ Prioridade para o Fastfetch
* 🔄 Fallback automático para o Neofetch
* 🔎 Verificação antes da instalação
* 🧩 Função reutilizável para gerenciamento de pacotes
* 🚫 Evita reinstalações desnecessárias
* 🖥️ Executa automaticamente a ferramenta instalada
* ❌ Retorna códigos de saída apropriados
* 🔐 Utiliza os repositórios configurados no sistema

---

# 🐧 Distribuições suportadas

O script detecta o gerenciador de pacotes disponível no sistema.

| Gerenciador | Distribuições                   |
| ----------- | ------------------------------- |
| `apt`       | Debian, Ubuntu e derivados      |
| `dnf`       | Fedora, RHEL e derivados        |
| `pacman`    | Arch Linux, Manjaro e derivados |
| `zypper`    | openSUSE                        |

> A detecção é baseada na disponibilidade do gerenciador de pacotes, e não diretamente no nome da distribuição.

---

# 🔄 Fluxo de execução

```text
┌─────────────────────────┐
│         Início          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Detectar gerenciador    │
│       de pacotes        │
└────────────┬────────────┘
             │
       ┌─────┴─────┐
       │ Encontrado?│
       └─────┬─────┘
             │
       ┌─────┴───────────────┐
       │                     │
      SIM                   NÃO
       │                     │
       ▼                     ▼
┌───────────────┐     ┌──────────────────┐
│ Verificar     │     │ Encerrar com erro│
│ Fastfetch     │     │      exit 1      │
└───────┬───────┘     └──────────────────┘
        │
   ┌────┴─────┐
   │ Existe?  │
   └────┬─────┘
        │
   ┌────┴───────────────┐
   │                    │
  SIM                  NÃO
   │                    │
   ▼                    ▼
┌──────────┐      ┌────────────────┐
│ Executar │      │ Instalar       │
│ Fastfetch│      │ Fastfetch      │
└──────────┘      └───────┬────────┘
                           │
                      ┌────┴─────┐
                      │ Instalou?│
                      └────┬─────┘
                           │
                      ┌────┴───────────┐
                      │                │
                     SIM              NÃO
                      │                │
                      ▼                ▼
                ┌──────────┐    ┌───────────────┐
                │ Executar │    │ Instalar      │
                │ Fastfetch│    │ Neofetch      │
                └──────────┘    └───────┬───────┘
                                        │
                                   ┌────┴─────┐
                                   │ Instalou?│
                                   └────┬─────┘
                                        │
                                   ┌────┴───────────┐
                                   │                │
                                  SIM              NÃO
                                   │                │
                                   ▼                ▼
                             ┌──────────┐    ┌───────────────┐
                             │ Executar │    │ Encerrar      │
                             │ Neofetch │    │ com erro      │
                             └──────────┘    │    exit 1     │
                                             └───────────────┘
```

---

# 📁 Estrutura do projeto

```text
fastfetch-neofetch-installer/
├── installer.sh
├── README.md
├── LICENSE
├── .gitignore
└── .github/
    └── workflows/
        └── shellcheck.yml
```

| Arquivo              | Descrição                   |
| -------------------- | --------------------------- |
| `installer.sh`       | Script principal            |
| `README.md`          | Documentação do projeto     |
| `LICENSE`            | Licença open-source         |
| `.gitignore`         | Arquivos ignorados pelo Git |
| `.github/workflows/` | Automação de CI/CD          |

---

# 🚀 Instalação

## Requisitos

* Linux
* Bash
* Um dos gerenciadores de pacotes suportados
* Acesso aos repositórios da distribuição
* `sudo`, quando necessário para instalação

Verifique o Bash:

```bash
bash --version
```

---

## 1. Clone o repositório

```bash
git clone https://github.com/SEU-USUARIO/fastfetch-neofetch-installer.git
cd fastfetch-neofetch-installer
```

> Substitua `SEU-USUARIO` pelo usuário ou organização responsável pelo repositório.

---

## 2. Torne o script executável

```bash
chmod +x installer.sh
```

---

## 3. Execute

```bash
./installer.sh
```

Se necessário:

```bash
sudo ./installer.sh
```

---

# 🔍 Explicação técnica

## Shebang

O script utiliza:

```bash
#!/usr/bin/env bash
```

O *shebang* informa que o script deve ser executado pelo Bash.

O uso de `/usr/bin/env` permite localizar o Bash através do `PATH`, evitando assumir um caminho fixo para o interpretador.

---

## 🧰 Função `command_exists`

```bash
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
```

Essa função verifica se determinado comando está disponível no sistema.

Exemplo:

```bash
command_exists fastfetch
```

O comando:

```bash
command -v "$1"
```

procura o executável no `PATH`.

As redireções:

```bash
>/dev/null 2>&1
```

impedem que a saída seja exibida no terminal.

### Código de retorno

|           Código | Significado            |
| ---------------: | ---------------------- |
|              `0` | Comando encontrado     |
| Diferente de `0` | Comando não encontrado |

---

# 📦 Detecção do gerenciador de pacotes

O script verifica os gerenciadores nesta ordem:

```bash
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
```

O gerenciador detectado é armazenado em:

```bash
PKG_MANAGER
```

Isso permite que uma única função de instalação trate diferentes distribuições.

---

# ⚡ Verificação do Fastfetch

Antes de instalar qualquer pacote, o script verifica se o Fastfetch já existe:

```bash
if command_exists fastfetch; then
    fastfetch
    exit 0
fi
```

Se estiver instalado:

1. O Fastfetch é executado;
2. Nenhuma instalação é realizada;
3. O script termina com sucesso.

---

# 🔁 Fallback para Neofetch

Caso o Fastfetch não esteja disponível, o script verifica o Neofetch:

```bash
if command_exists neofetch; then
    neofetch
    exit 0
fi
```

Isso fornece uma segunda alternativa antes de iniciar qualquer instalação.

---

# 📥 Instalação de pacotes

A instalação é centralizada em uma função:

```bash
install_package() {
    case "$PKG_MANAGER" in
        ...
    esac
}
```

A função recebe o nome do pacote através de:

```bash
$1
```

Exemplo:

```bash
install_package fastfetch
```

Nesse caso:

```text
$1 = fastfetch
```

A função seleciona o comando apropriado para o gerenciador detectado.

---

## APT

```bash
sudo apt update && sudo apt install -y "$1"
```

---

## DNF

```bash
sudo dnf install -y "$1"
```

---

## Pacman

```bash
sudo pacman -S --noconfirm "$1"
```

---

## Zypper

```bash
sudo zypper install -y "$1"
```

> A implementação deve evitar operações de atualização parcial em distribuições baseadas em Arch.

---

# 🚀 Instalação do Fastfetch

Quando necessário:

```bash
echo "Tentando instalar fastfetch..."
```

Depois:

```bash
if install_package fastfetch; then
```

Após a instalação, o script verifica novamente:

```bash
if command_exists fastfetch; then
    fastfetch
    exit 0
fi
```

Essa verificação adicional garante que o executável realmente esteja disponível antes de tentar executá-lo.

---

# 🔄 Instalação do Neofetch

Se o Fastfetch não puder ser instalado:

```bash
echo "Fastfetch não disponível. Tentando instalar neofetch..."
```

O script executa o mesmo processo utilizando:

```bash
install_package neofetch
```

Depois confirma:

```bash
command_exists neofetch
```

Se estiver disponível:

```bash
neofetch
exit 0
```

---

# ❌ Tratamento de erro

Se nenhum dos dois pacotes puder ser instalado:

```bash
echo "Nenhum dos pacotes (fastfetch ou neofetch) está disponível nos repositórios."
exit 1
```

O código `1` indica falha na execução.

---

# 📊 Exit Codes

| Código | Significado                                             |
| -----: | ------------------------------------------------------- |
|    `0` | Execução concluída com sucesso                          |
|    `1` | Falha, pacote indisponível ou gerenciador não suportado |

Esses códigos permitem integrar o script com outros sistemas de automação.

---

# 🧪 Testes

Antes de utilizar o script em máquinas de produção, recomenda-se testar cada cenário.

### Fastfetch já instalado

```bash
command -v fastfetch
```

### Neofetch já instalado

```bash
command -v neofetch
```

### Verificar gerenciador

```bash
command -v apt
command -v dnf
command -v pacman
command -v zypper
```

### Validar sintaxe do Bash

```bash
bash -n installer.sh
```

Se nenhum erro for apresentado, a sintaxe básica do script está válida.

---

# 🔎 ShellCheck

O projeto recomenda utilizar o **ShellCheck** para identificar possíveis problemas no código Bash.

Execute:

```bash
shellcheck installer.sh
```

O objetivo é manter o script livre de:

* Variáveis mal utilizadas;
* Problemas de quoting;
* Redirecionamentos incorretos;
* Construções Bash potencialmente problemáticas;
* Erros comuns de shell scripting.

---

# 🔐 Considerações de segurança

O instalador executa comandos com privilégios administrativos através do `sudo`.

Por isso:

* ✅ Revise o código antes da execução;
* ✅ Utilize repositórios confiáveis;
* ✅ Evite executar versões modificadas de fontes desconhecidas;
* ✅ Não utilize `curl | bash` sem revisar previamente o conteúdo;
* ✅ Teste em ambiente controlado antes de utilizar em máquinas críticas.

O script não deve baixar e executar código arbitrário de fontes externas.

---

# 🐛 Troubleshooting

## Gerenciador de pacotes não suportado

Execute:

```bash
command -v apt
command -v dnf
command -v pacman
command -v zypper
```

Se nenhum comando retornar um caminho, a distribuição ou ambiente provavelmente não é suportado.

---

## Fastfetch não está disponível

Verifique diretamente no gerenciador de pacotes.

### Debian / Ubuntu

```bash
apt search fastfetch
```

### Fedora

```bash
dnf search fastfetch
```

### Arch Linux

```bash
pacman -Ss fastfetch
```

### openSUSE

```bash
zypper search fastfetch
```

---

## Permissão negada

Torne o arquivo executável:

```bash
chmod +x installer.sh
```

Depois:

```bash
./installer.sh
```

---

## Verificar instalação

Fastfetch:

```bash
command -v fastfetch
```

Neofetch:

```bash
command -v neofetch
```

---

# 🗺️ Roadmap

* [ ] Adicionar `--help`
* [ ] Adicionar `--version`
* [ ] Adicionar modo `--dry-run`
* [ ] Adicionar escolha manual entre Fastfetch e Neofetch
* [ ] Melhorar tratamento de erros
* [ ] Adicionar logs opcionais
* [ ] Detectar distribuição através de `/etc/os-release`
* [ ] Adicionar testes automatizados
* [ ] Adicionar GitHub Actions
* [ ] Integrar ShellCheck ao CI
* [ ] Adicionar suporte a novos gerenciadores de pacotes

---

# 🤝 Contribuindo

Contribuições são bem-vindas.

### 1. Faça um fork

Crie um fork do projeto no GitHub.

### 2. Crie uma branch

```bash
git checkout -b feature/minha-melhoria
```

### 3. Faça suas alterações

Teste o script em uma ou mais distribuições suportadas.

### 4. Valide o código

```bash
bash -n installer.sh
shellcheck installer.sh
```

### 5. Faça o commit

```bash
git add installer.sh README.md
git commit -m "feat: adiciona nova funcionalidade"
```

### 6. Envie a branch

```bash
git push origin feature/minha-melhoria
```

### 7. Abra um Pull Request

Descreva claramente:

* O problema;
* A solução;
* Como foi testado;
* Distribuições utilizadas.

---

# 📜 Licença

Este projeto está disponível sob a licença **MIT**.

Consulte [`LICENSE`](LICENSE) para obter os termos completos.

---

# ⚖️ Disclaimer

Este software pode executar operações administrativas no sistema operacional.

O uso deste projeto é de responsabilidade do usuário. Sempre revise o código e valide seu comportamento antes de utilizá-lo em ambientes de produção.

---

## ⭐ Gostou do projeto?

Se este projeto foi útil para você, considere deixar uma ⭐ no GitHub.

Issues, sugestões, correções e Pull Requests são bem-vindos.

---

<p align="center">
  <strong>Fastfetch / Neofetch Installer</strong><br>
  Automação simples e multiplataforma para ferramentas de informações do sistema Linux.
</p>
