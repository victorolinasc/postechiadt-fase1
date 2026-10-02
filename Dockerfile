FROM python:3.14-slim

RUN apt-get update \
    && apt-get install -y wget curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install uv

# Set working directory
WORKDIR /workspace

# Install Jupyter Lab and jupyter-ai using uv
# Installing to system Python since this is a container
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

# Expose Jupyter Lab port
EXPOSE 8888

# Set environment variables
# UV_CACHE_DIR will be overridden by bind mount
ENV UV_CACHE_DIR=/workspace/.uv-cache
ENV JUPYTER_CONFIG_DIR=/workspace/.jupyter
ENV IPYTHONDIR=/workspace/.jupyter/ipython

# Start Jupyter Lab with no authentication
# This is a local sandbox environment
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
