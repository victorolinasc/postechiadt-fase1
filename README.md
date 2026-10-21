# Pós-Tech IA para Devs – FIAP

Este repositório contém notebooks Python que analisam datasets usando algoritmos de **Machine Learning**. O projeto foi desenvolvido como solução para o **Tech Challenge – Fase 1** da Pós-Tech IA para Devs da FIAP.

## Integrantes do grupo

| Nome | RM | GitHub |
|---|---|---|
| Arnold | 377310 | [@ArnoldReis](https://github.com/ArnoldReis) |
| Bhendon | 377937 | [@bhendon-soares](https://github.com/bhendon-soares) |
| Laercio | 378529 | [@laercioalves](https://github.com/laercioalves) |
| Marcos | 378872 | [@MarcosAngeloPintoAlves](https://github.com/MarcosAngeloPintoAlves) |
| Victor | 378625 | [@victorolinasc](https://github.com/victorolinasc) |

## 1. Objetivo

Aplicar os conhecimentos da primeira fase do curso em análise de dados e classificação com Machine Learning. Os notebooks documentam as etapas por meio de células Markdown e código. Os resultados foram reproduzidos pelos integrantes do grupo.

## 2. Datasets escolhidos

### 2.1. Saúde mental de estudantes universitários

Dados sobre estilo de vida de estudantes e sua relação com a depressão, utilizados para estudar a classificação de registros relacionados à presença de depressão.

- Dataset: `notebooks/saude_mental/dataset.csv`
- Notebook: `notebooks/saude_mental/analysis.ipynb`

### 2.2. Wisconsin Diagnostic Breast Cancer (WDBC)

Dados de diagnóstico de câncer de mama utilizados para classificação de tumores benignos e malignos.

- Dataset: `notebooks/wdbc/dataset.csv`
- Notebook: `notebooks/wdbc/analysis.ipynb`

## 3. Estrutura do projeto

```text
postechiadt-fase1/
├── AGENTS.md              # Instruções para agentes de IA
├── Dockerfile             # Imagem do ambiente JupyterLab
├── README.md              # Documentação do projeto
├── TECH_CHALLENGE.md      # Descrição do desafio
├── compose.yaml           # Configuração do container
└── notebooks/
    ├── saude_mental/
    │   ├── dataset.csv
    │   └── analysis.ipynb
    └── wdbc/
        ├── dataset.csv
        └── analysis.ipynb
```

## 4. Pré-requisitos

- **Git**, para obter o repositório.
- **Podman ou Docker**, com um provedor **Compose** funcional.
- **Navegador web**, para acessar o JupyterLab.

Não é necessário instalar Python ou JupyterLab diretamente no computador quando se utiliza o container do projeto.

## 5. Obtendo o projeto

Clone o repositório usando sua URL real no GitHub:

```bash
git clone <URL_DO_REPOSITORIO>
cd postechiadt-fase1
```

Se o repositório já estiver clonado, basta acessar seu diretório.

## 6. Construindo e iniciando o ambiente

Execute os comandos a seguir **dentro do diretório `postechiadt-fase1`**, onde está o arquivo `compose.yaml`.

### Opção A — Podman

```bash
podman compose build
podman compose up -d
podman ps
```

> **Linux com Podman:** caso apareça um erro de conexão com `podman.sock`, verifique o serviço do socket com `systemctl --user status podman.socket`. Se necessário, inicie-o com `systemctl --user enable --now podman.socket` e tente novamente.

### Opção B — Docker

```bash
docker compose build
docker compose up -d
docker ps
```

O `build` prepara a imagem com as dependências; o `up -d` inicia o ambiente em segundo plano. Não é necessário reconstruir a imagem a cada utilização, a menos que sua configuração ou suas dependências tenham mudado.

## 7. Acessando o JupyterLab

Com o container em execução, abra no navegador:

**http://localhost:10000**

Essa é a porta de acesso informada para o projeto e utilizada nos testes com Podman. Se o mapeamento de portas no `compose.yaml` for alterado, ajuste o endereço conforme a configuração.

> **Segurança:** o ambiente foi configurado para acesso local. Não exponha a porta do JupyterLab diretamente à internet sem configurar autenticação e controles de acesso apropriados.

## 8. Executando os notebooks

1. No painel de arquivos à esquerda do JupyterLab, abra `saude_mental` ou `wdbc`.
2. Dê dois cliques em `analysis.ipynb`.
3. Leia as células Markdown e execute as células de código **na ordem apresentada**.
4. Use **Shift + Enter** para executar uma célula ou o menu **Run → Run All Cells** para executar todas.

## 9. Dependências Python

As bibliotecas necessárias são instaladas automaticamente durante a construção da imagem definida no `Dockerfile`. Entre as bibliotecas disponíveis no ambiente estão:

| Biblioteca | Finalidade |
|---|---|
| NumPy | Operações numéricas |
| Pandas | Manipulação e análise de dados |
| Matplotlib | Gráficos e visualização |
| Seaborn | Visualização estatística |
| Scikit-learn | Algoritmos de Machine Learning |
| SHAP | Interpretação de modelos |
| JupyterLab | Execução interativa dos notebooks |

**Não é necessário executar `pip install` manualmente** ao utilizar o ambiente fornecido pelo projeto. Em outros ambientes, as dependências podem precisar de instalação própria.

## 10. Gerenciando o ambiente

| Ação | Podman | Docker |
|---|---|---|
| Ver containers ativos | `podman ps` | `docker ps` |
| Acompanhar logs | `podman compose logs -f` | `docker compose logs -f` |
| Parar e remover containers | `podman compose down` | `docker compose down` |
| Iniciar novamente | `podman compose up -d` | `docker compose up -d` |

O comando `compose down` remove os containers do projeto; a preservação de arquivos criados durante a execução depende dos volumes configurados no `compose.yaml`. Para manter alterações importantes, salve-as nos arquivos do repositório ou em volumes persistentes.

## 11. Reprodutibilidade

Os datasets e notebooks estão incluídos no repositório, e o `Dockerfile` define o ambiente de execução. Recomenda-se utilizar o container disponibilizado para reduzir diferenças entre instalações e facilitar a reprodução dos experimentos.

---

**Projeto acadêmico — Pós-Tech IA para Devs / FIAP — Tech Challenge, Fase 1.**
