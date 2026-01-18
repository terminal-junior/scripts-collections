## Explicação detalhada do código

```bash
#!/usr/bin/env bash
```

Indica que o script deve ser executado usando o bash, independente do caminho exato do bash no sistema.

```bash
Função command_exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
```

Verifica se um comando existe no sistema

command -v retorna o caminho do comando se existir

```bash
>/dev/null 2>&1 oculta qualquer saída
```

Retorna 0 (true) se existir, 1 (false) se não existir

Detecção do gerenciador de pacotes

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
```

Aqui o script detecta automaticamente o sistema:

apt → Debian, Ubuntu

dnf → Fedora, RHEL

pacman → Arch Linux

zypper → openSUSE

Salva o gerenciador em PKG_MANAGER

Se nenhum for encontrado, o script termina

Verificação se já está instalado

```bash
if command_exists fastfetch; then
    fastfetch
    exit 0
fi
```

Se fastfetch já existir:

Executa

Encerra o script com sucesso

```bash
if command_exists neofetch; then
    neofetch
    exit 0
fi
```

Mesmo processo para neofetch

Função para instalar pacotes

```bash
install_package() {
    case "$PKG_MANAGER" in
```

Cria uma função reutilizável que:

Recebe o nome do pacote como argumento ($1)

Usa o gerenciador correto para instalar

Exemplo para apt:

```bash
sudo apt update && sudo apt install -y "$1"
```

Atualiza os repositórios

Instala sem perguntar confirmação (-y)

Cada gerenciador tem sua sintaxe própria.

Tentativa de instalar fastfetch

```bash
echo "Tentando instalar fastfetch..."
```

Apenas informa o usuário.

```bash
if install_package fastfetch; then
```

Tenta instalar

Se o comando não existir nos repositórios, a instalação falha

```bash
if command_exists fastfetch; then
    fastfetch
    exit 0
fi
```

Confirma se realmente foi instalado

Executa e encerra

Tentativa de instalar neofetch

```bash
echo "Fastfetch não disponível. Tentando instalar neofetch..."
```

Executa o mesmo fluxo, mas agora para neofetch.

Mensagem final de erro
echo "Nenhum dos pacotes (fastfetch ou neofetch) está disponível nos repositórios."
exit 1


Executado apenas se nenhum dos dois puder ser instalado

exit 1 indica erro

▶️ Como usar o script

Salve como, por exemplo:

```bash
installer.sh
```

Torne executável:

```bash
chmod +x installer.sh
```

Execute:

```bash
./installer.sh
```

---
