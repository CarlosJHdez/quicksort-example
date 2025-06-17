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
   python -m venv .venv
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

# Other options as per pytest standards.
```

### Docker Testing

```bash
# Run tests in Docker
docker run --rm quicksort-example pytest -v

# Or using docker-compose
docker-compose --profile test up quicksort-test
```