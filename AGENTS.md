# AGENTS.md

Orientações para agentes de IA (e colaboradores humanos) que trabalham neste repositório.

## Visão Geral do Projeto

Repositório de estudos para a agenda da **Pós-tech IA para Devs (FIAP)**: um projeto de Machine Learning construído em torno de **notebooks Jupyter em Python** que analisam os datasets incluídos em `notebooks/` com **algoritmos de aprendizado supervisionado** (classificação e regressão).

O ambiente é um Jupyter Lab containerizado. **Não há toolchain de Python no host** — todo o código roda dentro do container.

## Estrutura do Repositório

```
.
├── AGENTS.md                  # Este arquivo
├── README.md                  # Contexto da disciplina + como executar
├── Dockerfile                 # Python 3.13-slim + Jupyter Lab + stack de ML
├── compose.yaml               # Ambiente com setup para rodar local
└── notebooks/                 # Único volume montado no container
```

## Ambiente

- **Execução**: `docker compose build` e depois `docker compose up -d` (também funciona com Podman). Jupyter Lab em `http://localhost:10000` (sem autenticação — apenas sandbox local).
- **Diretório raiz dentro do container**: `/workspace/notebooks` (montado a partir de `./notebooks`). Qualquer coisa fora de `notebooks/` fica invisível para o kernel do notebook.
- **Python 3.13**, instalado via `uv` no Dockerfile: `pandas`, `numpy`, `scikit-learn`, `torch`, `tensorflow`, `matplotlib`, `seaborn`, `duckdb`, `psycopg2-binary`, `jupyterlab`, `jupyter-ai`, `jupyter-collaboration`, `ty`.
- **Não** tente executar `python3` no host — ele não está instalado. Edite os notebooks como arquivos a partir do host, ou execute o código dentro do container.
- Para adicionar um pacote: edite o bloco `uv pip install --system` no `Dockerfile` e refaça o build — pip instalado diretamente no container em execução é perdido no `docker compose down`.

## Datasets

| Dataset | Caminho | Linhas | Alvo | Observações |
|---|---|---:|---|---|
| Estilo de vida / saúde mental de estudantes | `notebooks/student_lifestyle_db.csv` | 100.000 | `Depression` (binário) | Features: `Age`, `Gender`, `Department`, `CGPA`, `Sleep_Duration`, `Study_Hours`, `Social_Media_Hours`, `Physical_Activity`, `Stress_Level`. `Student_ID` é um identificador — nunca usar como feature. |
| Predição de diabetes (sintético) | `notebooks/diabetes_dataset/Diabetes_prediction.csv` | 1.000 | `Diagnosis` (binário) | Colunas no estilo Pima, valores contínuos, **tem linha de header**. |
| Pima Indians Diabetes | `notebooks/pina_diabetes/diabetes_pima.csv` | 767 | última coluna (resultado do diabetes, binário) | **Sem linha de header** — carregar com `header=None` e atribuir nomes às colunas. Particularidade conhecida: `0` em `Glucose`, `BloodPressure`, `SkinThickness`, `Insulin`, `BMI` significa *ausente*, não zero real. Fazer imputação; não modelar como 0. |

## Notebooks

| Notebook | Propósito |
|---|---|
| `notebooks/eda_mental_health.ipynb` | EDA sobre `student_lifestyle_db.csv` (estresse/depressão) com train/test split estratificado. |
| `notebooks/diabetes_dataset/diabetes-dataset.ipynb` | Classificação no conjunto sintético de diabetes (SVC, XGBoost). |
| `notebooks/diabetes_dataset/victor_nascimento_exploracao.ipynb` | Regressão exploratória (LinearRegression, R², MSE). |
| `notebooks/pina_diabetes/diabetes-dataset-pima.ipynb` | Pipeline mais completa: Imputer + StandardScaler + LogisticRegression / DecisionTree / KNeighbors, avaliada com accuracy e ROC-AUC. |

## Convenções de Notebooks

- Estruturar os notebooks nesta ordem: **título e contexto → imports → carregamento dos dados → EDA → pré-processamento → modelagem → avaliação → conclusões**.
- Um dataset por subpasta (como em `pina_diabetes/`, `diabetes_dataset/`); manter o CSV ao lado dos notebooks.
- Sempre definir `random_state` (e seeds) em splits, samplers e modelos para que os resultados sejam reproduzíveis.
- Limpar os outputs (`jupyter nbconvert --clear-output` ou pela interface do Jupyter) antes de commitar; nunca commitar `.ipynb_checkpoints/` (já está no gitignore) nem o estado de runtime `.jupyter/`.
- Quando um notebook passar de ~200 linhas de código, extrair a lógica reutilizável (pré-processamento, helpers de métricas) para um módulo `.py` na mesma subpasta e importá-lo — mas manter o notebook autocontido o suficiente para rodar de ponta a ponta.

## Boas Práticas de ML (aprendizado supervisionado)

1. **Reprodutibilidade em primeiro lugar**: fixar as seeds de `numpy`/`random`/`torch` e passar `random_state` para todo estimador e split. Registrar as versões dos pacotes (`pip freeze` dentro do container) na primeira célula do notebook ou numa nota de `requirements` ao publicar resultados.
2. **Sem vazamento de dados (data leakage)**: ajustar scalers, imputers, encoders e qualquer engenharia de features **apenas no split de treino**, e depois `transform` no split de teste. A forma mais segura é um `sklearn.pipeline.Pipeline` — ajustar o pipeline inteiro no treino e avaliar no teste. Nunca fazer `StandardScaler().fit_transform(X)` no dataset completo antes do split.
3. **Fazer o split antes de qualquer pré-processamento**: `train_test_split` primeiro; só depois imputar/escalar/codificar dentro do pipeline.
4. **Estratificar splits de classificação**: `train_test_split(..., stratify=y)` para que as proporções de classe fiquem iguais em treino e teste (relevante para os três datasets — os alvos de diabetes são desbalanceados).
5. **Tratar valores ausentes explicitamente**: para `diabetes_pima.csv`, substituir os `0` sentinela (ver Datasets) por `np.nan` *antes* de ajustar um `SimpleImputer` (mediana para numéricos). Nunca descartar linhas em silêncio no conjunto Pima de 767 linhas — cada linha conta.
6. **Escalar features** para algoritmos sensíveis à distância e à regularização (KNN, SVC, LogisticRegression); ensembles de árvores (RandomForest, XGBoost) não precisam, mas manter o pipeline consistente.
7. **Codificar categoriais corretamente**: `OneHotEncoder` (ou `pd.get_dummies` aplicado de forma idêntica a treino/teste) para colunas nominais como `Gender`, `Department`; `LabelEncoder` apenas para o alvo — nunca para features alimentando modelos lineares.
8. **Considerar o desbalanceamento de classes**: relatar mais do que accuracy (ver métricas abaixo); considerar `class_weight="balanced"`, reamostragem ou ajuste de limiar. Para o conjunto Pima (~35% positivos), o trade-off precisão/recall importa mais que accuracy.
9. **Começar com uma baseline** (ex.: LogisticRegression ou um preditor da classe majoritária) e só declarar vitória para um modelo complexo se ele superar a baseline na validação.
10. **Verificar overfitting**: comparar desempenho em treino vs. validação; uma diferença grande indica necessidade de regularização, modelo mais simples ou mais dados.
11. **Cuidado com dados pequenos**: o conjunto Pima (767 linhas) é pequeno — preferir modelos simples e interpretáveis e validação cruzada a um único split "sortudo"; evitar redes profundas a menos que a comparação de arquiteturas seja o objetivo.

## Técnicas de Validação

- **Avaliação final — holdout estratificado**: um único `train_test_split(..., test_size=0.2, stratify=y, random_state=42)`; o conjunto de teste é tocado **apenas uma vez**, no final, para os números finais.
- **Seleção de modelo — validação cruzada k-fold**: `cross_validate` / `cross_val_score` com `StratifiedKFold(n_splits=5)` (ou 10 para o conjunto de 1.000 linhas) em classificação, `KFold` em regressão. Reportar **média ± desvio padrão** entre as folds, não um número único.
- **Busca de hiperparâmetros com CV**: `GridSearchCV` / `RandomizedSearchCV` com `scoring` apropriado à tarefa (ex.: `roc_auc` ou `f1` para classificação desbalanceada, `neg_mean_squared_error` para regressão) e `cv=StratifiedKFold(...)`. Ajustar o modelo final com todos os dados de treino depois de escolher os melhores parâmetros.
- **CV aninhada para estimativas honestas** (opcional, quando se faz tuning + avaliação no mesmo notebook): laço interno para seleção de modelo, laço externo para estimativa de desempenho — evita o "viés de otimismo" de avaliar em dados que influenciaram a escolha.
- **Métricas por tarefa**:
  - *Classificação*: `classification_report` (precisão, recall, F1 por classe) + `roc_auc_score`; accuracy sozinha é enganosa para alvos desbalanceados.
  - *Regressão*: `r2_score`, `mean_squared_error` (e `root_mean_squared_error` para interpretabilidade), `mean_absolute_error`.
- **Verificação de sensibilidade**: repetir o split holdout 3–5 vezes com valores diferentes de `random_state` e confirmar que as métricas são estáveis; um único split pode favorecer ou prejudicar um modelo.
- **Documentar tudo**: registrar tamanho do split, esquema de CV, métrica de scoring, seeds e os números finais no conjunto de teste na célula de conclusões do notebook, para que os resultados sejam auditáveis.

## Convenções de Git

- Estilo de branches e commits já em uso: mensagens curtas no imperativo, ocasionalmente em português (o idioma do repositório é pt-BR).
- O `.gitignore` já exclui `.ipynb_checkpoints/`, `.jupyter/`, `__pycache__/` e venvs — respeitar; nunca forçar o commit de estado de runtime ignorado.
- Os datasets estão commitados (fazem parte do material de estudo); não movê-los para fora de `notebooks/` sem atualizar este arquivo, o `compose.yaml` (montagem de volume) e os notebooks que os referenciam.

## Armadilhas Conhecidas

- `diabetes_pima.csv` **não tem header** — `pd.read_csv` vai tratar a primeira linha de dados como nomes de coluna, a menos que se passe `header=None`.
- `Diabetes_prediction.csv` e `diabetes_prediction.csv` em `diabetes_dataset/` são duplicados (diferem apenas em maiúsculas/minúsculas); `diabetes-dataset.ipynb` / `diabetes_dataset.ipynb` são quase duplicados. Consolidar em um de cada antes de adicionar novo trabalho.
- Apenas `./notebooks` é montado no container — scripts, imagens ou outputs salvos em outro lugar do host não aparecem no Jupyter, e arquivos criados no container fora da montagem são perdidos no rebuild.
- O Jupyter roda sem autenticação e com `--allow-root` em `0.0.0.0` — ok para o sandbox local, mas nunca expor a porta 10000 publicamente.
