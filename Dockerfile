# Use Python 3.13 slim image as base
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Copy requirements first for better Docker layer caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY quicksort.py .
COPY test_quicksort.py .
COPY pyproject.toml .

# Create a non-root user for security
RUN adduser --disabled-password --gecos '' --shell /bin/bash user && \
    chown -R user:user /app
USER user

# Default command runs the quicksort example
CMD ["python", "quicksort.py"]

# Add labels for better image management
LABEL maintainer="CJ Hernandez"
LABEL description="Quicksort example with unit tests"
LABEL version="0.1"
