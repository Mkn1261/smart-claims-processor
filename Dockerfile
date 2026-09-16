FROM python:3.11-slim

# Prevent Python from writing .pyc files and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file first for Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Create required data directories
RUN mkdir -p /app/data /app/data/chroma

# FastAPI port
EXPOSE 8000

# Start backend
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
