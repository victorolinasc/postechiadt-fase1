# ============================================================
# Etapa 1 - Ambiente original
# ============================================================
FROM python:3.14-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       wget curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install uv

WORKDIR /workspace

# Bibliotecas originais - Python 3.14
RUN uv pip install --system \
    jupyterlab \
    jupyterlab_widgets \
    jupyter-collaboration \
    ipykernel \
    ipywidgets \
    pandas \
    numpy \
    scikit-learn \
    matplotlib \
    seaborn \
    shap \
    ty

# ============================================================
# Python 3.12 isolado
# ============================================================

# Instalar Python 3.12 isoladamente
RUN uv python install 3.12

# Criar ambiente virtual para pneumonia
RUN uv venv --python 3.12 /opt/pneumonia-venv


# Instalar TensorFlow e dependências
RUN uv pip install \
    --python /opt/pneumonia-venv/bin/python \
    tensorflow==2.21.0 \
    ipykernel \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    scipy \
    pillow

# Registrar kernel do notebook de pneumonia
RUN /opt/pneumonia-venv/bin/python -m ipykernel install \
    --prefix=/usr/local \
    --name=pneumonia \
    --display-name="Python 3.12 (Pneumonia - TensorFlow)"

# ============================================================
# Configuração JupyterLab
# ============================================================

EXPOSE 8888

ENV UV_CACHE_DIR=/workspace/.uv-cache
ENV JUPYTER_CONFIG_DIR=/workspace/.jupyter
ENV IPYTHONDIR=/workspace/.jupyter/ipython

CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--ServerApp.token=", \
     "--ServerApp.password=", \
     "--ServerApp.allow_origin=*", \
     "--ServerApp.disable_check_xsrf=True", \
     "--ServerApp.root_dir=/workspace/notebooks"]
