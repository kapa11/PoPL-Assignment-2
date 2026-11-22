# P1 — Department Assignment Puzzle

## Solution Count

Using `count_solutions([1,2,3,4,5,6,7,8], N)`, we obtained:

**N = 3**

This means that the first eight clues do not uniquely determine the assignments. There are three distinct valid solutions satisfying all eight clues.

Therefore, the original puzzle is under-constrained: additional information is needed to identify exactly one arrangement.

## Ninth Clue

To resolve this ambiguity, we introduced the following ninth clue:

> The friend whose favorite language is Python prefers the AI project.

This clue does not identify any friend by name. It establishes a relationship between two attributes.

After adding the ninth clue, we evaluated:

`count_solutions([1,2,3,4,5,6,7,8,9], N)`

The result was:

**N = 1**

Thus, the ninth clue eliminates the ambiguity and leaves exactly one valid solution.

## Final Solution

- Alex = [design, java, embedded]
- Ben = [development, javascript, web]
- Carla = [testing, python, AI]
- Dana = [research, c++, data]

## Verification

The implementation was tested using SWI-Prolog 9.x.

- Total automated tests: 32
- Tests passed: 32
- Tests failed: 0
- Final solution count: 1
- `main/0` output: Verified against the required four-line format.