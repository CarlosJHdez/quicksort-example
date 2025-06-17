# quicksort-example

A small programming example for quicksort referencing [Wikipedia's Quicksort article](https://en.wikipedia.org/wiki/Quicksort) and the Hoare's scheme.

## Features

- Implementation of quicksort using Hoare's partition scheme
- Comprehensive test suite with pytest
- Docker support for easy deployment and testing

## Installation

### Option 1: Local Development

1. Clone the repository
2. Create a virtual environment (recommended, for pytest):

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate 
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

### Option 2: Docker

1. Clone the repository
2. Build and run with Docker:

   ```bash
   # Build the Docker image
   docker build -t quicksort-example .
   
   # Run the quicksort example
   docker run --rm quicksort-example
   
   # Run tests
   docker run --rm quicksort-example pytest -v
   ```

### Option 3: Docker Compose

   ```bash
   # Run the quicksort example
   docker-compose up quicksort-app
   
   # Run tests
   docker-compose --profile test up quicksort-test
   ```

## Usage

### Local Usage

Run the quicksort example:

```bash
python quicksort.py
```

### Docker Usage

```bash
# Run the example
docker run --rm quicksort-example

# Run with custom array (interactive)
docker run --rm -it quicksort-example python -c "
from quicksort import quicksort
import sys
arr = [int(x) for x in sys.argv[1:]]
print('Input:', arr)
result = quicksort(arr)
print('Sorted:', result)
" 64 34 25 12 22 11 90

# Run tests
docker run --rm quicksort-example pytest -v
```

## Testing

We included tests using pytest. To run the tests:

### Local Testing

```bash
# Run all tests
pytest

# Run tests with verbose output
pytest -v

# Run tests with coverage
pytest --cov=quicksort

# Other options as per pytest standards
```

### Docker Testing

```bash
# Run tests in Docker
docker run --rm quicksort-example pytest -v

# Or using docker-compose
docker-compose --profile test up quicksort-test
```

## Kubernetes Deployment

This project includes Kubernetes manifests for deployment to Google Kubernetes Engine (GKE) or any Kubernetes cluster.

### Quick Deployment to Google Cloud

1. **Prerequisites:**
   - Google Cloud account with billing enabled
   - `gcloud` CLI installed and authenticated
   - `kubectl` installed
   - Docker installed

2. **Automated Deployment:**

   ```bash   
   # Deploy to Google Cloud (replace with your project ID)
   ./deploy-gcp.sh your-project-id us-central1 quicksort-cluster
   ```

### Manual Deployment Steps

#### Step 1: Build and Push Docker Image

```bash
# Set your Google Cloud project ID
export PROJECT_ID="quicksort-example-alpha"

# Build the Docker image
docker build -t gcr.io/${PROJECT_ID}/quicksort-example:latest .

# Configure Docker for GCR
gcloud auth configure-docker

# Push to Google Container Registry
docker push gcr.io/${PROJECT_ID}/quicksort-example:latest
```

#### Step 2: Create GKE Cluster (if needed)

```bash
# Create a GKE cluster
gcloud container clusters create quicksort-cluster \
    --region=us-central1 \
    --machine-type=e2-medium \
    --num-nodes=2 \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=4

# Get cluster credentials
gcloud container clusters get-credentials quicksort-autopilot --region=us-central1
```
