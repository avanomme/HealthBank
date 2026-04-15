# Made with assistance of generative AI
"""
Example: Parametrized Tests
Tests the same function with different inputs without code duplication.
"""
import pytest


def add(a, b):
    """Simple addition function"""
    return a + b


def is_even(n):
    """Check if number is even"""
    return n % 2 == 0


# Example 1: Basic parametrized test
@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (0, 0, 0),
    (-1, 1, 0),
    (10, 20, 30),
])
def test_add(a, b, expected):
    """Test addition with multiple inputs"""
    assert add(a, b) == expected


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
