# --------------------------------------------
# Base Image: Python 3.9 Slim
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
    chown -R appuser:appuser /app/logs

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
