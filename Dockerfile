FROM python:3.9.7-slim-buster

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

RUN useradd -m appuser && \
    mkdir -p /app/logs && \
    chown -R appuser:appuser /app/logs

COPY --chown=appuser:appuser . /app/
WORKDIR /app/

USER appuser  # Switch user BEFORE installing pip packages

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

CMD ["sh", "-c", "python3 modules/main.py >> /app/logs/app.log 2>&1"]
