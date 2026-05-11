FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    build-essential \
    && apt-get clean

# Install code-server (VS Code Server)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a non-root user
RUN useradd -m -s /bin/bash devuser

# Working directory
WORKDIR /workspace

# Give devuser ownership
RUN chown -R devuser:devuser /workspace

# Switch to non-root user
USER devuser

# Expose VS Code Server port
EXPOSE 8080

# Start VS Code Server with password auth
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "/workspace"]

