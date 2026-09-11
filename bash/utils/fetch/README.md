# 🖥️ Fastfetch / Neofetch Installer

Script Bash para **detectar automaticamente o gerenciador de pacotes do sistema Linux e instalar uma ferramenta de informações do sistema**.

O script prioriza o **Fastfetch** e, caso ele não esteja disponível nos repositórios configurados, tenta instalar o **Neofetch** como alternativa.

O objetivo é fornecer uma instalação simples e automatizada, evitando que o usuário precise identificar manualmente a distribuição ou utilizar comandos específicos de cada gerenciador de pacotes.

---

## ✨ Principais recursos

* 🐧 Detecção automática do gerenciador de pacotes
* 📦 Suporte a múltiplas distribuições Linux
* ⚡ Prioridade para o Fastfetch
* 🔄 Fallback automático para o Neofetch
* 🔎 Verificação antes da instalação
* 🧩 Função reutilizável para instalação de pacotes
* 🚫 Não reinstala ferramentas já disponíveis
* 🖥️ Executa automaticamente a ferramenta instalada
* ❌ Retorna código de erro quando nenhuma alternativa está disponível

---

# 🐧 Distribuições suportadas

O script identifica o gerenciador de pacotes disponível no sistema.

| Gerenciador | Principais distribuições        |
| ----------- | ------------------------------- |
| `apt`       | Debian, Ubuntu e derivados      |
| `dnf`       | Fedora, RHEL e derivados        |
| `pacman`    | Arch Linux, Manjaro e derivados |
| `zypper`    | openSUSE                        |

> A detecção é baseada na disponibilidade do gerenciador de pacotes, e não diretamente no nome da distribuição.

Isso permite que o script também funcione em distribuições derivadas que utilizem um dos gerenciadores suportados.

---

# 🔄 Fluxo de execução

O funcionamento geral pode ser representado da seguinte forma:

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

# 🔍 Explicação técnica

## 1. Shebang

O script começa com:

```bash
#!/usr/bin/env bash
```

O *shebang* informa ao sistema que o script deve ser executado utilizando o **Bash**.

A utilização de:

```bash
/usr/bin/env bash
```

permite localizar o Bash através do `PATH`, em vez de assumir que ele está obrigatoriamente em um caminho específico, como:

```text
/bin/bash
```

Isso torna o script mais portátil entre diferentes sistemas Unix-like.

---

# 🧰 2. Função `command_exists`

O script utiliza uma função auxiliar para verificar se determinado comando está disponível:

```bash
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
```

Essa função recebe o nome de um comando como argumento.

Por exemplo:

```bash
command_exists fastfetch
```

ou:

```bash
command_exists apt
```

### Como funciona

O comando:

```bash
command -v "$1"
```

verifica se o comando informado existe e, quando encontrado, normalmente retorna seu caminho.

Exemplo:

```text
/usr/bin/fastfetch
```

A saída é descartada através de:

```bash
>/dev/null
```

Enquanto:

```bash
2>&1
```

redireciona a saída de erro para a mesma saída padrão.

Assim, a função não imprime informações desnecessárias no terminal.

### Código de retorno

A função utiliza o código de saída do `command -v`:

|           Código | Significado            |
| ---------------: | ---------------------- |
|              `0` | Comando encontrado     |
| diferente de `0` | Comando não encontrado |

Isso permite utilizá-la diretamente em estruturas condicionais:

```bash
if command_exists fastfetch; then
    fastfetch
fi
```

---

# 📦 3. Detecção do gerenciador de pacotes

O script identifica automaticamente qual gerenciador está disponível:

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

O resultado é armazenado na variável:

```bash
PKG_MANAGER
```

### Mapeamento

```text
apt     → Debian / Ubuntu
dnf     → Fedora / RHEL
pacman  → Arch Linux / Manjaro
zypper  → openSUSE
```

A vantagem dessa abordagem é que o restante do script não precisa conhecer diretamente qual distribuição está sendo utilizada.

---

# ⚡ 4. Verificação do Fastfetch

Depois de identificar o gerenciador de pacotes, o script verifica se o Fastfetch já está instalado:

```bash
if command_exists fastfetch; then
    fastfetch
    exit 0
fi
```

Caso esteja disponível:

1. O Fastfetch é executado;
2. Nenhuma instalação é realizada;
3. O script termina com sucesso.

O código:

```bash
exit 0
```

representa uma execução bem-sucedida.

### Por que verificar antes?

Isso evita:

* Reinstalações desnecessárias;
* Atualizações de pacotes sem necessidade;
* Alterações desnecessárias no sistema;
* Consumo adicional de rede.

---

# 🖥️ 5. Fallback para Neofetch

Se o Fastfetch não estiver instalado, o script verifica se o Neofetch já está disponível:

```bash
if command_exists neofetch; then
    neofetch
    exit 0
fi
```

O comportamento é semelhante:

```text
Fastfetch existe?
       │
      SIM ──────► Executa Fastfetch
       │
      NÃO
       │
       ▼
Neofetch existe?
       │
      SIM ──────► Executa Neofetch
       │
      NÃO
       │
       ▼
   Continua para instalação
```

---

# 📥 6. Função `install_package`

Para evitar duplicação de código, o script utiliza uma função responsável pela instalação:

```bash
install_package() {
    case "$PKG_MANAGER" in
```

A função recebe o nome do pacote através de:

```bash
$1
```

Por exemplo:

```bash
install_package fastfetch
```

Nesse caso:

```text
$1 = fastfetch
```

A função então seleciona automaticamente o comando correspondente ao gerenciador detectado.

---

## APT

Para sistemas Debian/Ubuntu:

```bash
sudo apt update && sudo apt install -y "$1"
```

O fluxo é:

1. Atualizar os índices dos repositórios;
2. Instalar o pacote;
3. Utilizar `-y` para confirmar automaticamente.

---

## DNF

Para Fedora/RHEL e derivados:

```bash
sudo dnf install -y "$1"
```

O parâmetro:

```text
-y
```

confirma automaticamente a instalação.

---

## Pacman

Para Arch Linux/Manjaro:

```bash
sudo pacman -Sy --noconfirm "$1"
```

> ⚠️ Para uso em produção, recomenda-se avaliar cuidadosamente a estratégia de sincronização e atualização utilizada pelo script. Em Arch Linux, operações parciais de atualização podem causar problemas de dependências.

---

## Zypper

Para openSUSE:

```bash
sudo zypper install -y "$1"
```

O parâmetro `-y` evita a necessidade de confirmação manual.

---

# 🔄 7. Tentativa de instalação do Fastfetch

Caso o Fastfetch não esteja instalado:

```bash
echo "Tentando instalar fastfetch..."
```

O script tenta instalar o pacote:

```bash
if install_package fastfetch; then
```

O resultado da função é utilizado diretamente pela estrutura condicional.

Se a instalação for bem-sucedida, o script verifica novamente:

```bash
if command_exists fastfetch; then
    fastfetch
    exit 0
fi
```

Essa segunda verificação é importante porque **o comando de instalação ter terminado não deve ser considerado, sozinho, uma garantia de que o executável está disponível**.

---

# 🔁 8. Fallback para Neofetch

Se o Fastfetch não estiver disponível nos repositórios ou não puder ser instalado, o script tenta o Neofetch:

```bash
echo "Fastfetch não disponível. Tentando instalar neofetch..."
```

Depois:

```bash
if install_package neofetch; then
```

Caso a instalação seja concluída:

```bash
if command_exists neofetch; then
    neofetch
    exit 0
fi
```

O fluxo final fica:

```text
Fastfetch
   │
   ├── Já instalado? ──► Executa
   │
   └── Não
        │
        ▼
   Tentar instalar
        │
        ├── Sucesso ──► Executa
        │
        └── Falha
             │
             ▼
          Neofetch
             │
             ├── Já instalado? ──► Executa
             │
             └── Não
                  │
                  ▼
             Tentar instalar
                  │
                  ├── Sucesso ──► Executa
                  │
                  └── Falha ──► exit 1
```

---

# ❌ 9. Erro final

Se nenhum dos dois programas estiver disponível:

```bash
echo "Nenhum dos pacotes (fastfetch ou neofetch) está disponível nos repositórios."
exit 1
```

O código:

```bash
exit 1
```

indica que a execução terminou com erro.

Isso é especialmente útil quando o script é executado por:

* Automação;
* CI/CD;
* Scripts externos;
* Provisionamento;
* Ferramentas de gerenciamento de configuração.

---

# 📊 Códigos de saída

O script utiliza códigos de saída para indicar o resultado da execução:

| Código | Significado                     |
| -----: | ------------------------------- |
|    `0` | Execução concluída com sucesso  |
|    `1` | Falha ou recurso não disponível |

Exemplos:

```bash
exit 0
```

indica sucesso.

```bash
exit 1
```

indica erro.

---

# ▶️ Como utilizar

## 1. Salvar o script

Por exemplo:

```text
installer.sh
```

---

## 2. Tornar executável

```bash
chmod +x installer.sh
```

---

## 3. Executar

```bash
./installer.sh
```

Em sistemas onde privilégios administrativos são necessários, o próprio script utiliza `sudo` durante a instalação.

Se necessário, execute:

```bash
sudo ./installer.sh
```

---

# 🧪 Exemplos

### Fastfetch já instalado

```text
Fastfetch encontrado.
```

O script executará diretamente:

```bash
fastfetch
```

---

### Fastfetch não instalado

```text
Tentando instalar fastfetch...
```

Se a instalação for bem-sucedida:

```text
Fastfetch instalado com sucesso.
```

O programa será executado automaticamente.

---

### Fastfetch indisponível

```text
Fastfetch não disponível. Tentando instalar neofetch...
```

O script então utilizará o Neofetch como alternativa.

---

### Nenhuma alternativa disponível

```text
Nenhum dos pacotes (fastfetch ou neofetch) está disponível nos repositórios.
```

Nesse caso:

```text
exit 1
```

---

# 🔐 Considerações de segurança

O script instala software utilizando privilégios administrativos.

Por isso:

* ✅ Revise o código antes de executar;
* ✅ Utilize repositórios oficiais ou confiáveis;
* ✅ Evite executar scripts baixados de fontes desconhecidas;
* ✅ Verifique os comandos executados como `root`;
* ✅ Teste em ambiente controlado antes de utilizar em máquinas críticas.

O projeto não deve utilizar `curl | bash` ou mecanismos equivalentes para executar código remoto sem validação.

---

# 🐛 Troubleshooting

## O script informa que o gerenciador não é suportado

Verifique quais gerenciadores estão disponíveis:

```bash
command -v apt
command -v dnf
command -v pacman
command -v zypper
```

Pelo menos um deles deve retornar um caminho.

---

## O pacote não pode ser instalado

Verifique se os repositórios estão funcionando.

### Debian / Ubuntu

```bash
sudo apt update
```

### Fedora / RHEL

```bash
sudo dnf check-update
```

### Arch Linux

```bash
sudo pacman -Sy
```

### openSUSE

```bash
sudo zypper refresh
```

Depois tente executar o instalador novamente.

---

## O script não possui permissão de execução

Execute:

```bash
chmod +x installer.sh
```

Depois:

```bash
./installer.sh
```

---

## Verificar manualmente se o programa está instalado

Fastfetch:

```bash
command -v fastfetch
```

Neofetch:

```bash
command -v neofetch
```

---

# 🗂️ Estrutura recomendada do projeto

```text
scripts-collections/
└── bash/
    └── utils/
        └── fetch/
            ├── README.md
            └── installer.sh
```

### Descrição

| Arquivo        | Função                      |
| -------------- | --------------------------- |
| `installer.sh` | Script principal            |
| `README.md`    | Documentação                |
| `LICENSE`      | Licença do projeto          |
<!-- | `.gitignore`   | Arquivos ignorados pelo Git | -->

---

# 🗺️ Roadmap

Possíveis melhorias futuras:

* [ ] Adicionar modo `--help`
* [ ] Adicionar modo `--dry-run`
* [ ] Adicionar opção para escolher Fastfetch ou Neofetch manualmente
* [ ] Adicionar detecção explícita da distribuição através de `/etc/os-release`
* [ ] Melhorar tratamento de erros
* [ ] Adicionar logs opcionais
* [ ] Adicionar testes automatizados
* [ ] Adicionar ShellCheck ao CI
<!-- * [ ] Criar GitHub Actions para testar diferentes distribuições -->
* [ ] Adicionar suporte a outros gerenciadores de pacotes

---

# 🤝 Contribuindo

Contribuições são bem-vindas.

Para contribuir:

1. Faça um fork do projeto;
2. Crie uma branch:

```bash
git checkout -b feature/minha-melhoria
```

3. Faça suas alterações;
4. Teste o script;
5. Faça o commit:

```bash
git commit -m "feat: adiciona nova funcionalidade"
```

6. Envie a branch:

```bash
git push origin feature/minha-melhoria
```

7. Abra um Pull Request.

### Antes de enviar

Verifique:

* [ ] O script funciona no Bash;
* [ ] As permissões estão corretas;
* [ ] O código foi testado;
* [ ] Não existem comandos desnecessariamente destrutivos;
* [ ] A documentação foi atualizada;
* [ ] O comportamento de erro foi validado.

---

# 📜 Licença

Este projeto está disponível sob a licença **MIT**.

Consulte o arquivo [`LICENSE`](LICENSE) para obter os termos completos.

---

# ⚖️ Disclaimer

Este software executa operações de instalação utilizando privilégios administrativos.

O uso deste projeto é de responsabilidade do usuário. Sempre revise o código e valide seu comportamento antes de executá-lo em ambientes de produção.

---

## ⭐ Gostou do projeto?

Se este script foi útil para você, considere deixar uma ⭐ no GitHub.

Issues, sugestões, correções e Pull Requests são bem-vindos.

---

<p align="center">
  <strong>Fastfetch / Neofetch Installer</strong><br>
  Instalação automatizada e multiplataforma para ferramentas de informações do sistema Linux.
</p>
