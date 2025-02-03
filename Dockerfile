# --------------------------------------------
# Base Image: Python 3.9 Slim Version
# --------------------------------------------
FROM python:3.9.7-slim-buster

# --------------------------------------------
# Install System Dependencies
# --------------------------------------------
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        musl-dev \
        ffmpeg \
        aria2 \
        python3-pip \
        libssl-dev \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------
# Create Non-Root User & Logs Directory
# --------------------------------------------
RUN useradd -m appuser && \
    mkdir -p /app/logs && \
    chown appuser:appuser /app/logs

# --------------------------------------------
# Copy Code & Set Permissions
# --------------------------------------------
COPY --chown=appuser:appuser . /app/
WORKDIR /app/

# --------------------------------------------
# Install Python Dependencies
# --------------------------------------------
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

# --------------------------------------------
# Switch to Non-Root User
# --------------------------------------------
USER appuser

# --------------------------------------------
#
