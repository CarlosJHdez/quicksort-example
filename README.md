# quicksort-example

A small programming example for quicksort referencing [Wikipedia's Quicksort article](https://en.wikipedia.org/wiki/Quicksort) and the Hoare's scheme.

## Features

- Implementation of quicksort using Hoare's partition scheme
- Comprehensive test suite with pytest
- Handles various edge cases including empty arrays, duplicates, and negative numbers

## Installation

1. Clone the repository
2. Create a virtual environment (recommended):

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

## Usage

Run the quicksort example:

```bash
python quicksort.py
```

## Testing

This project includes comprehensive tests using pytest. To run the tests:

```bash
# Run all tests
pytest

# Run tests with verbose output
pytest -v

# Run specific test file
pytest test_quicksort.py

# Run specific test class
pytest test_quicksort.py::TestQuicksort

# Run specific test method
pytest test_quicksort.py::TestQuicksort::test_empty_array
```

The test suite includes:

- Edge cases (empty arrays, single elements)
- Various input scenarios (sorted, reverse sorted, random)
- Duplicate elements handling
- Negative numbers and mixed positive/negative numbers
- Large arrays
- Floating point numbers
- Parametrized tests for comprehensive coverage

## Project Structure

```text
quicksort-example/
├── quicksort.py          # Main quicksort implementation
├── test_quicksort.py     # Comprehensive test suite
├── requirements.txt      # Python dependencies
├── pyproject.toml        # Pytest configuration
├── README.md            # This file
└── LICENSE              # License file
```