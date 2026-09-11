# Pós-tech IA para Devs - FIAP

Projeto(s) para estudar seguindo a agenda da pós-tech FIAP IA para Devs. Este repositório possui uma configuração inicial
para executar o Python Jupyter via container.

## Pré-requisitos

- Engine de execução de containers (Docker ou Podman ou qualquer outra)
- Utilitário de compose (docker-compose ou podman-compose ou qualquer outro)

## Executando (exemplo com `podman`)

- Primeiro, construir ("buildar") a imagem com: `podman compose build`
- Em seguida, executar a imagem: `podman compose up -d` (o `-d` fará com que a execução aconteça em segundo plano)
- Abrir um browser e navegar para `http://localhost:10000`
