# 🧰 Scripts Collections

[![Bash](https://img.shields.io/badge/Bash-Scripts-4EAA25?logo=gnu-bash\&logoColor=white)](#)
[![Python](https://img.shields.io/badge/Python-Scripts-3776AB?logo=python\&logoColor=white)](#)
[![PowerShell](https://img.shields.io/badge/PowerShell-Scripts-5391FE?logo=powershell\&logoColor=white)](#)
[![Unix-like](https://img.shields.io/badge/Platform-Unix--like-lightgrey?logo=linux)](#)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/terminal-junior/scripts-collections?style=flat\&logo=github)](https://github.com/terminal-junior/scripts-collections/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/terminal-junior/scripts-collections?style=flat\&logo=github)](https://github.com/terminal-junior/scripts-collections/issues)

> 📚 Coleção de scripts utilitários para **automação, administração, diagnóstico, manutenção e produtividade** em ambientes Unix-like e sistemas diversos.

---

## 📖 Sobre o Projeto

**Scripts Collections** é um repositório dedicado à organização de scripts pequenos, reutilizáveis e práticos para tarefas do dia a dia.

A proposta é centralizar ferramentas desenvolvidas para:

* 🖥️ Administração e manutenção de sistemas
* 🔍 Diagnóstico e troubleshooting
* 🔄 Automação de tarefas repetitivas
* 📦 Gerenciamento de pacotes e software
* 🌐 Rede e conectividade
* 📊 Coleta de informações do sistema
* 🛠️ Utilitários gerais
* 🧪 Experimentação e aprendizado

O projeto também serve como um **laboratório de automação**, permitindo documentar soluções, testar ideias e manter scripts úteis em um único lugar.

---

## ✨ Características

* 📂 Organização por linguagem e finalidade
* 🧩 Scripts independentes e reutilizáveis
* 📚 Documentação individual quando necessária
* 🐧 Foco em ambientes Linux e Unix-like
* 🐍 Suporte a diferentes linguagens
* ⚡ Ferramentas simples e objetivas
* 🔐 Orientação para execução segura
* 🛠️ Projetado para uso prático e aprendizado
* 🚀 Estrutura preparada para crescimento

---

## 📂 Estrutura do Repositório

A estrutura é organizada por **linguagem** e, posteriormente, por **categoria ou finalidade**.

```text
scripts-collections/
│
├── bash/
│   ├── system/
│   ├── network/
│   ├── security/
│   └── utils/
│
├── python/
│   ├── automation/
│   ├── system/
│   ├── network/
│   └── tools/
│
├── powershell/
│   ├── system/
│   ├── automation/
│   └── utils/
│
├── LICENSE
└── README.md
```

A estrutura pode evoluir conforme novas ferramentas e categorias forem adicionadas ao projeto.

---

## 🧰 Categorias

### 🖥️ System

Scripts relacionados à administração e manutenção do sistema.

Exemplos:

```text
Informações do sistema
Gerenciamento de serviços
Limpeza e manutenção
Atualizações
Gerenciamento de processos
Monitoramento de recursos
```

### 🌐 Network

Ferramentas para diagnóstico e gerenciamento de rede.

```text
Testes de conectividade
DNS
Interfaces de rede
Diagnóstico de rotas
Informações de IP
Ferramentas de troubleshooting
```

### 🔐 Security

Scripts voltados para tarefas auxiliares de segurança.

```text
Auditoria básica
Verificação de configurações
Atualizações de segurança
Coleta de informações
Hardening auxiliar
```

> ⚠️ Os scripts de segurança são ferramentas auxiliares e não substituem soluções profissionais de segurança, auditorias ou políticas corporativas.

### 🤖 Automation

Automação de tarefas repetitivas.

```text
Rotinas administrativas
Backup
Organização de arquivos
Execução de tarefas
Automação de workflows
```

### 🛠️ Utils

Pequenas ferramentas e utilitários de uso geral.

```text
Conversores
Geradores
Helpers
CLI utilities
Ferramentas auxiliares
```

---

## 💻 Linguagens

| Linguagem  | Extensão | Uso                                       |
| ---------- | -------- | ----------------------------------------- |
| Bash       | `.sh`    | Automação e administração Unix/Linux      |
| Python     | `.py`    | Automação e ferramentas                   |
| PowerShell | `.ps1`   | Administração e automação multiplataforma |

Novas linguagens podem ser adicionadas conforme a necessidade do projeto.

---

## 🖥️ Compatibilidade

A compatibilidade depende do script utilizado.

| Ambiente   | Suporte                              |
| ---------- | ------------------------------------ |
| 🐧 Linux   | ✅ Principal                          |
| 🍎 macOS   | ⚠️ Dependente do script              |
| 🐡 BSD     | ⚠️ Dependente do script              |
| 🪟 Windows | ⚠️ Principalmente via PowerShell/WSL |

> Nem todos os scripts são compatíveis com todos os sistemas. Consulte a documentação do script antes da execução.

---

## 📜 Requisitos

Cada script pode possuir requisitos específicos.

Antes de executar uma ferramenta, verifique:

```text
• Sistema operacional suportado
• Versão da linguagem/runtime
• Dependências externas
• Comandos necessários
• Permissões exigidas
• Necessidade de acesso root/sudo
```

Scripts individuais devem documentar suas dependências e limitações sempre que necessário.

---

## 🚀 Como Usar

### 1. Clone o repositório

```bash
git clone https://github.com/terminal-junior/scripts-collections.git
```

Entre no diretório:

```bash
cd scripts-collections
```

### 2. Escolha um script

Por exemplo:

```bash
cd bash/utils/
```

### 3. Consulte a documentação

Sempre que disponível, leia o `README.md` ou a documentação específica do script antes de executá-lo.

### 4. Torne o script executável

Para scripts Bash:

```bash
chmod +x script.sh
```

### 5. Execute

```bash
./script.sh
```

Ou, quando apropriado:

```bash
bash script.sh
```

---

## 🔍 Exemplo

Um fluxo típico de utilização:

```text
Clone do repositório
        │
        ▼
Escolha a linguagem
        │
        ▼
Escolha a categoria
        │
        ▼
Leia a documentação
        │
        ▼
Verifique dependências
        │
        ▼
Revise o código
        │
        ▼
Execute o script
```

---

## 🧪 Testes

Sempre que possível, os scripts devem ser testados antes de serem utilizados em ambientes de produção.

### Recomendações

```text
✅ Teste primeiro em ambiente controlado
✅ Leia o código antes da execução
✅ Verifique as dependências
✅ Faça backup quando houver risco de alteração de dados
✅ Use privilégios elevados somente quando necessários
✅ Valide o comportamento antes de automatizar
```

### ⚠️ Importante

**Nunca execute scripts desconhecidos como `root` ou utilizando `sudo` sem antes verificar o conteúdo e entender o que eles fazem.**

Um script aparentemente simples pode:

* Alterar arquivos do sistema
* Instalar ou remover pacotes
* Modificar configurações
* Interromper serviços
* Alterar permissões
* Excluir dados

---

## 🔐 Segurança

A segurança é uma preocupação importante para este projeto.

Antes de executar qualquer script:

```bash
less script.sh
```

ou:

```bash
cat script.sh
```

Procure especialmente por comandos que possam modificar o sistema:

```text
sudo
rm
dd
mkfs
chmod
chown
systemctl
apt
dnf
pacman
zypper
```

Isso não significa que esses comandos sejam inseguros por si só, mas que devem ser utilizados conscientemente.

> **Princípio recomendado:** entenda o que o script faz antes de conceder privilégios elevados.

---

## 📝 Padrão de Documentação

Sempre que um script possuir comportamento específico, recomenda-se documentar:

```text
# Nome
# Descrição
# Requisitos
# Sistemas suportados
# Dependências
# Instalação
# Uso
# Exemplos
# Limitações
# Avisos
```

Exemplo:

```text
script.sh
├── Descrição
├── Requisitos
├── Instalação
├── Uso
├── Exemplos
├── Troubleshooting
└── Limitações
```

Isso mantém o projeto consistente e facilita a utilização por outras pessoas.

---

## 🧹 Boas Práticas

Os scripts deste repositório devem buscar seguir boas práticas de desenvolvimento.

### Bash

Quando aplicável:

```bash
#!/usr/bin/env bash

set -euo pipefail
```

Também é recomendado:

* Utilizar aspas em variáveis
* Validar argumentos
* Verificar dependências
* Tratar erros
* Evitar comandos destrutivos sem confirmação
* Utilizar funções para lógica reutilizável
* Manter mensagens de saída claras
* Evitar privilégios elevados desnecessários

### Python

Preferencialmente:

```text
PEP 8
Type hints quando apropriado
Tratamento de exceções
Argumentos via CLI
Documentação
Dependências claramente definidas
```

### PowerShell

Sempre que possível:

```text
Validação de parâmetros
Tratamento de erros
Mensagens claras
Compatibilidade documentada
Evitar execução privilegiada desnecessária
```

---

## 📌 Status do Projeto

🚧 **Em desenvolvimento contínuo**

Este é um projeto vivo. Novos scripts, melhorias, correções e categorias podem ser adicionados ao longo do tempo.

A organização pode mudar conforme o repositório crescer.

---

## 🗺️ Roadmap

Possíveis melhorias futuras:

* [ ] Adicionar mais scripts Bash
* [ ] Expandir ferramentas Python
* [ ] Adicionar scripts PowerShell
* [ ] Melhorar documentação individual
* [ ] Adicionar testes automatizados
* [ ] Integrar ShellCheck
* [ ] Padronizar logging
* [ ] Adicionar exemplos de uso
* [ ] Criar índice de scripts
* [ ] Adicionar matriz de compatibilidade
* [ ] Criar releases versionadas

---

## 🤝 Contribuindo

Contribuições são bem-vindas.

Antes de enviar uma contribuição:

1. Faça um fork do projeto.
2. Crie uma branch para sua alteração.
3. Desenvolva e teste o script.
4. Documente requisitos e limitações.
5. Verifique possíveis impactos no sistema.
6. Faça um commit descritivo.
7. Abra um Pull Request.

Exemplo:

```bash
git checkout -b feature/new-script
```

Depois:

```bash
git add .
git commit -m "feat: add system information script"
git push origin feature/new-script
```

---

## 💡 Ideias e Sugestões

Encontrou um problema ou tem uma ideia para uma nova ferramenta?

Abra uma **Issue** descrevendo:

```text
• O problema
• O comportamento esperado
• O sistema operacional
• Versão relevante
• Passos para reproduzir
• Logs ou mensagens de erro
```

Sugestões de novos scripts também são bem-vindas.

---

## 📄 Licença

Este projeto é distribuído sob a licença **MIT**.

Consulte o arquivo [`LICENSE`](LICENSE) para obter os termos completos da licença.

---

## ⚠️ Disclaimer

Os scripts deste repositório são fornecidos **"como estão"**, sem garantias de funcionamento em todos os ambientes.

O comportamento de determinadas ferramentas pode variar conforme:

* Distribuição Linux
* Sistema operacional
* Versão do software
* Gerenciador de pacotes
* Configuração do sistema
* Permissões do usuário

**Sempre revise e teste os scripts antes de utilizá-los em sistemas importantes ou ambientes de produção.**

---

## ⭐ Apoie o Projeto

Se este repositório foi útil para você:

* ⭐ Dê uma estrela no GitHub
* 🐛 Reporte problemas
* 💡 Sugira melhorias
* 🔧 Contribua com novos scripts
* 📢 Compartilhe o projeto

Toda contribuição ajuda a tornar a coleção mais útil para a comunidade.

---

<div align="center">

**🧰 Scripts Collections**

Uma coleção de scripts para automatizar, diagnosticar, administrar e aprender.

⭐ **Simple scripts. Practical automation. Open source.**

</div>
