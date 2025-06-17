import pytest
from quicksort import quicksort


class TestQuicksort:
    """Test cases for the quicksort function."""
    
    def test_empty_array(self):
        """Test that an empty array returns an empty array."""
        assert quicksort([]) == []
    
    def test_single_element(self):
        """Test that a single element array returns the same array."""
        assert quicksort([42]) == [42]
    
    def test_two_elements_sorted(self):
        """Test with two elements already sorted."""
        assert quicksort([1, 2]) == [1, 2]
    
    def test_two_elements_reverse(self):
        """Test with two elements in reverse order."""
        assert quicksort([2, 1]) == [1, 2]
    
    def test_already_sorted(self):
        """Test with an already sorted array."""
        arr = [1, 2, 3, 4, 5]
        assert quicksort(arr.copy()) == [1, 2, 3, 4, 5]
    
    def test_reverse_sorted(self):
        """Test with a reverse sorted array."""
        arr = [5, 4, 3, 2, 1]
        assert quicksort(arr.copy()) == [1, 2, 3, 4, 5]
    
    def test_random_order(self):
        """Test with randomly ordered elements."""
        arr = [9, 2, 7, 6, 3, 10, 4]
        expected = [2, 3, 4, 6, 7, 9, 10]
        assert quicksort(arr.copy()) == expected
    
    def test_duplicates(self):
        """Test with duplicate elements."""
        arr = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3]
        expected = [1, 1, 2, 3, 3, 4, 5, 5, 6, 9]
        assert quicksort(arr.copy()) == expected
    
    def test_all_same_elements(self):
        """Test with all elements being the same."""
        arr = [5, 5, 5, 5, 5]
        assert quicksort(arr.copy()) == [5, 5, 5, 5, 5]
    
    def test_negative_numbers(self):
        """Test with negative numbers."""
        arr = [-3, -1, -4, -1, -5, -9, -2]
        expected = [-9, -5, -4, -3, -2, -1, -1]
        assert quicksort(arr.copy()) == expected
    
    def test_mixed_positive_negative(self):
        """Test with both positive and negative numbers."""
        arr = [-3, 5, -1, 8, 0, -7, 2]
        expected = [-7, -3, -1, 0, 2, 5, 8]
        assert quicksort(arr.copy()) == expected
    
    def test_large_array(self):
        """Test with a larger array."""
        arr = list(range(100, 0, -1))  # [100, 99, 98, ..., 2, 1]
        expected = list(range(1, 101))  # [1, 2, 3, ..., 99, 100]
        assert quicksort(arr.copy()) == expected
    
    def test_original_array_unchanged(self):
        """Test that the original array is modified in place."""
        original = [3, 1, 4, 1, 5]
        result = quicksort(original)
        # quicksort modifies the array in place and returns it
        assert result is original
        assert original == [1, 1, 3, 4, 5]


class TestQuicksortEdgeCases:
    """Test edge cases and error conditions."""
    
    def test_float_numbers(self):
        """Test with floating point numbers."""
        arr = [3.14, 2.71, 1.41, 0.57]
        expected = [0.57, 1.41, 2.71, 3.14]
        result = quicksort(arr.copy())
        assert result == expected
    
    def test_large_numbers(self):
        """Test with large numbers."""
        arr = [10000000, 9999999, 10000001]
        expected = [9999999, 10000000, 10000001]
        assert quicksort(arr.copy()) == expected


# Parametrized tests for comprehensive coverage
@pytest.mark.parametrize("input_arr,expected", [
    ([1], [1]),
    ([1, 2], [1, 2]),
    ([2, 1], [1, 2]),
    ([1, 3, 2], [1, 2, 3]),
    ([3, 2, 1], [1, 2, 3]),
    ([1, 1, 1], [1, 1, 1]),
    ([5, 2, 8, 1, 9], [1, 2, 5, 8, 9]),
])
def test_quicksort_parametrized(input_arr, expected):
    """Parametrized tests for various input scenarios."""
    assert quicksort(input_arr.copy()) == expected
