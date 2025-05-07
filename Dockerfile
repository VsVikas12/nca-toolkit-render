FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies including FFmpeg
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    wget \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Create directory for local storage if doesn't exist
RUN mkdir -p /app/storage

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080
ENV LOCAL_STORAGE_PATH=/app/storage

# Expose the port the app will run on
EXPOSE 8080

# Command to run the application with Gunicorn
CMD gunicorn --bind 0.0.0.0:${PORT:-8080} --workers=${GUNICORN_WORKERS:-2} --timeout=${GUNICORN_TIMEOUT:-300} app:app
