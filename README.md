# Pós-tech IA para Devs - FIAP

Este repositório possui Python notebooks que analisam datasets usando algoritmos de Machine Learning. Ele foi criado em grupo pelos alunos:

- Arnold (rm377310 | Github: @ArnoldReis)
- Bhendon (rm | Github: @bhendon-soares)
- Laercio (rm378529 | Github: @laercioalves)
- Marcos (rm378872 | Github: @MarcosAngeloPintoAlves)
- Victor (rm378625 | Github: @victorolinasc)

## Objetivo

O objetivo é exercitar o conteúdo aprendido no curso e entregar como nossa solução ao Tech Challenge da primeira fase. Cada notebook nesse projeto está documentado passo a passo (usando células de markdown no próprio notebook). Todos os resultados foram reproduzidos por todos do grupo.

## Datasets escolhidos

Para o desafio de criar classificadores que possam predizer diagnósticos de doenças, nós escolhemos dois datasets bem distintos:

1. Grupo de dados sobre estilo de vida e a relação com a doença depressão em estudantes universitários.
2. Grupo de dados do estado de Winsconsin nos EUA sobre câncer de mama ("wdbc" sendo a sigla para Winsconsin Diagnostics Breast Cancer).

## Conteúdo

O repositório possui o seguinte layout:

- `AGENTS.md`: meta instruções para agentes de IA
- `TECH_CHALLENGE.md`: descrição do desafio da fase 1 do curso
- `Dockerfile`: Definição da imagem do serviço Jupyter pela qual os resultados podem ser reproduzidos individualmente
- `compose.yaml`: Configuração da execução do container
- `notebooks/`
  - `saude_mental/`: primeiro caso de análise
    - `dataset.csv`: dataset sobre estilo de vida de estudantes universitários
    - `analysis.ipynb`: notebook com a análise completa do dataset acima
  - `wdbc/`: segundo caso de análise (Winsconsin Diagnostics Breast Cancer)
    - `dataset.csv`: dataset sobre casos de câncer de mama
    - `analysis.ipynb`: notebook com a análise completa do dataset acima      

## Pré-requisitos

- Engine de execução de containers (Docker ou Podman ou qualquer outra compatível com o padrão OCI)
- Utilitário de compose (docker-compose ou podman-compose ou qualquer outro compatível com o padrão OCI)

## Executando a infraestrutura (exemplo com `podman`)

- Primeiro, construir ("buildar") a imagem com: `podman compose build`
- Em seguida, executar a imagem: `podman compose up -d` (o `-d` fará com que a execução aconteça em segundo plano)
- Abrir um browser e navegar para `http://localhost:10000`

## Executando os notebooks

Ao abrir a página inicial, haverá um painel ao lado esquerdo que terá as duas pastas de notebooks. Basta dar dois cliques em um arquivo de notebook (que possui a extensão `ipynb`).

Na sequência, basta seguir o passo a passo e ir executando cada célula de código individualmente.

### !!! ATENÇÃO !!!

Alguns ambientes de notebook já possuem as bibliotecas instaladas e alguns **não permitem** comandos de instalar bibliotecas extras. Assim, células que tenham as instruções abaixo podem falhar:

```python
! pip install xxxxxx
```

Nesse caso, pode-se tentar seguir executando as próximas células.
