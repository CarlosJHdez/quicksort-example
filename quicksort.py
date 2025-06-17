# Using https://en.wikipedia.org/wiki/Quicksort as source, with the Hoare partition scheme.

def quicksort(arr):
    # Main work is done in the partition function 
    def partition(lo, hi):
        pivot = arr[lo] # Choose first element as the pivot
        i, j = lo - 1, hi + 1 # Left & right indexes

        # Loop 'forever' (until we break b/c the indexes cross)
        while True:
            i += 1 
            while i < hi and arr[i] < pivot: # Increment left index until we find an element greater than the pivot
                i += 1
            j -= 1
            while j > lo and arr[j] > pivot: # Decrement right index until we find an element less than the pivot
                j -= 1
            if i >= j:
                return j
            arr[i], arr[j] = arr[j], arr[i]

    # Recursive quicksort is mostly for readability
    def quicksort_recursive(lo, hi):
        if 0 <= lo and lo < hi and 0 <= hi < len(arr):
            p = partition(lo, hi)
            quicksort_recursive(lo, p) # Note: the pivot is now included.
            quicksort_recursive(p + 1, hi)

    quicksort_recursive(0, len(arr) - 1)
    return arr

if __name__ == '__main__':
    # super quick example
    arr = [9, 2, 7, 6, 3, 10, 4]
    print("Before quicksort:", arr)
    sorted_arr = quicksort(arr)
    print("Sorted array:", sorted_arr)