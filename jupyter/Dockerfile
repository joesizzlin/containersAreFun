FROM python:3.12-slim

# Create a non-root user and group
RUN useradd -m -s /bin/bash devuser

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install JupyterLab
RUN pip install --no-cache-dir jupyterlab

# Set working directory
WORKDIR /workspace

# Give the non-root user ownership of the workspace
RUN chown -R devuser:devuser /workspace

# Switch to the non-root user
USER devuser

# Expose JupyterLab port
EXPOSE 8888

# Start JupyterLab normally (no --allow-root needed)
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
