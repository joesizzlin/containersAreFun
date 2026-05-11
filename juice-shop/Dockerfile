FROM node:20-slim

# Create a non-root user and group
RUN useradd -m -s /bin/bash devuser

# Install Juice Shop
RUN npm install -g --no-progress @juice-shop/juice-shop

# Working directory
WORKDIR /workspace

# Give the non-root user ownership
RUN chown -R devuser:devuser /workspace

# Switch to non-root user
USER devuser

# Expose Juice Shop port
EXPOSE 3000

# Start OWASP Juice Shop
CMD ["juice-shop"]
