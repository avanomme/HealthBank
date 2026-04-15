# Test Discovery

Pytest finds test files by looking through the current directory and all it's subdirectories for files who's names meet the form test_*.py or *_test.py.

# Assert Statements

Assert statements simply check if a statement is true, if it is the test passes otherwise it fails. A common way to ensure a block of code is working is to encapsulate it into a function and then use assert to check if the actual output of the block of code is equivalent to the expected output.

# Fixtures

Fixtures are functions with the @pytest.fixture. Fixtures are used to set up data or conditions before a test. You can think of them like reusable setups. By default you create a new fixture for each instance of a test but that can be changed so that you can use the same instance for a class, file or even an entire test run. Fixtures can also depend on other fixtures, this is denoted by a fixture having the name of the other fixture it's dependant on as a parameter.

# conftest.py Scope

The conftest.py file is where you can define fixtures that you'll use multiple times, saving you the hassle of writing the same fixtures over and over. Pytest searches for conftest.py files my starting in the directory of the file being tested and working its way up the directory tree similar to the way a child class can use methods of its parent in OOP.