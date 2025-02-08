# --------------------------------------------
# Base Image: Python 3.9 Slim
# --------------------------------------------
FROM python:3.9.7-slim-buster

# --------------------------------------------
# Install System Dependencies
# --------------------------------------------
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gcc \                  # C compiler
        libffi-dev \           # Foreign Function Interface
        musl-dev \             # Musl C library
        ffmpeg \               # Video processing
        aria2 \                # Download accelerator
        python3-pip \          # Python package manager
        libssl-dev \           # SSL/TLS support
        zlib1g-dev \           # Compression library
    && apt-get clean \         # Clean package cache
    && rm -rf /var/lib/apt/lists/*  # Remove temp files

# --------------------------------------------
# Create Non-Root User & Logs Directory
# --------------------------------------------
RUN useradd -m appuser && \
    mkdir -p /app/logs && \
    chown -R appuser:appuser /app/logs  # Set permissions

# --------------------------------------------
# Copy App Code with Correct Permissions
# --------------------------------------------
COPY --chown=appuser:appuser . /app/
WORKDIR /app/

# --------------------------------------------
# Install Python Dependencies
# --------------------------------------------
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# --------------------------------------------
# Switch to Non-Root User (Security)
# --------------------------------------------
USER appuser

# --------------------------------------------
# Start Application with Logging
# --------------------------------------------
CMD ["sh", "-c", "python3 modules/main.py >> /app/logs/app.log 2>&1"]
