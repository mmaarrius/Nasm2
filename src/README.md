# My implementation

## Task 1
- First of all, I search for the element with the minimum value (which is 1) and memorise his address in the **head** variable. This represents the address of the array.
- The numbers are consecutive, so the next element in the array can be calculated. In a loop-like structure I look for the element, and for the last element found (**crt**), the **next** field is set to the address of the new element. The algorithm repeats until all the elements are sorted.

## Task 2
1. **get_words**    

    This function works on the principle of searching the delimiters, replacing them withh NULL characters and marking the beginning of a word as the character immediately after the delimiter.

2. **sort**

    The main challenge in this subtask was to create the `compare` function, but it wasn't too bad. It follows the specified rules. I also created `is_delimiter` function to check whether a character is a delimiter.

## Task 3
  
- The function computes the sum of the k elements in a generalized Fibonnaci array, using a loop. Imagine that at each point of time when the algorithm computes the sum, all the subsums are returned by the function in the eax register, one by one. So this function needs to call itself multiple times (k times), add the results in a variable and return it. So I chose edx register to accumulate all this subsums and, at the end, I copy the value from edx to eax.

## Task 4
1. **check_palindrome**
This function iterates through the string from the first character to the middle, checking each character against the one in the opposite position. (opposite_position = length - index)

2. **composite_palindrome**

To solve this subtask, I implemented another functions to help me:
1. `concatenate` -> appends to str1 another string from a specific position in an array of strings, similar to the `strcat` function from C.
2. `compare` -> compares two strings based on their length and lexicographically.
3. `new_string` -> takes as parameters the array of words, a number and a destination address. The number has 15 bits, because we have 15 words, and each combination of bits basically represents a combination of words.   
Examples:
```
number in binnary:  1   0   1       = 5
array of words:     Ana has apples

The new string: Anaapples
```
```
number in binnary:  1   1   0       = 6
array of words:     Ana has apples

The new string: Anahas
```
Using this principle we can generate any combination of words.

So with this finctions implemented, the program checks the best palindromic string that can be formed from an array of words.

> For this task, I was forced by the linter to align the code to the left.