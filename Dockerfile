# Use official lightweight Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies as root before switching user
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --break-system-packages -r requirements.txt

# Create non-root user and switch
RUN useradd -m appuser
USER appuser

# Copy remaining project files
COPY . .

# Set entry point
CMD ["python", "main.py"]
