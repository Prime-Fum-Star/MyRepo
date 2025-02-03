# --------------------------------------------
# Base Image: Python 3.9 के साथ Slim Version
# --------------------------------------------
FROM python:3.9.7-slim-buster

# --------------------------------------------
# System Dependencies Install करें
# --------------------------------------------
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gcc \                  # C Compiler
        libffi-dev \           # Foreign Function Interface
        musl-dev \             # Musl C Library
        ffmpeg \               # Video Processing
        aria2 \                # Download Accelerator
        python3-pip \          # Python Package Manager
        libssl-dev \           # SSL/TLS Support
        zlib1g-dev \           # Compression Library
    && apt-get clean \         # Cache साफ़ करें
    && rm -rf /var/lib/apt/lists/*  # Temporary Files हटाएं

# --------------------------------------------
# Non-Root User बनाएं (Security के लिए जरूरी)
# --------------------------------------------
RUN useradd -m appuser && \
    mkdir -p /app/logs && \    # Logs Directory बनाएं
    chown appuser:appuser /app/logs  # Permissions Set करें

# --------------------------------------------
# App Code Copy करें और Permissions Set करें
# --------------------------------------------
COPY --chown=appuser:appuser . /app/
WORKDIR /app/  # Working Directory Set करें

# --------------------------------------------
# Python Dependencies Install करें
# --------------------------------------------
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

# --------------------------------------------
# Non-Root User पर Switch करें
# --------------------------------------------
USER appuser

# --------------------------------------------
# Application Start करें + Logging Enable करें
# --------------------------------------------
CMD ["sh", "-c", "python3 modules/main.py >> /app/logs/app.log 2>&1"]
