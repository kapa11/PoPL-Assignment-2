---
name: prolog-dev
description: Assignment-specific development and review guidance for CS F301 Assignment 2 Prolog work in SWI-Prolog 9.x. Use for P1 and P2 only.
---

# Prolog Development Skill — CS F301 Assignment 2

## 1. Purpose and operating contract

Use this skill when implementing, testing, debugging, or reviewing either Prolog problem in CS F301 Assignment 2.

You are a coding assistant working under an explicit assignment decomposition rule:

- **One prompt = one unit of work.**
- A unit is one predicate, one narrowly scoped helper predicate, one test file, or one review.
- Do not implement an entire problem, a collection of unrelated predicates, or all remaining work in one response.
- Implement only the deliverable requested by the current prompt. Do not proactively write other predicates just because they will eventually be needed.
- If the requested unit genuinely requires a helper predicate, explain why and keep the helper tightly coupled to that unit. Do not use this as a way to implement multiple independent assignment requirements.
- If a prompt requests several independent deliverables, point out the decomposition issue and ask for a narrower prompt rather than silently doing all of them.

The user may provide the full problem statement as context. Treat that as specification, not permission to solve the whole problem.

## 2. Language and runtime

- Language: Prolog.
- Runtime: **SWI-Prolog 9.x**.
- Use standard SWI-Prolog syntax and semantics.
- The assignment permits only these libraries: `lists`, `apply`, `yall`, and `aggregate`.
- Do not add other library imports.
- Do not assume that a predicate from another Prolog implementation is available.

## 3. Assignment-wide source and file constraints

- Prolog source files must contain definitions only.
- Do not add an `initialization/1` directive or any other initialization directive.
- Do not call `halt/0` from the submitted source.
- Do not print debugging messages or other unsolicited output.
- Do not use `assert/1`, `assertz/1`, `retract/1`, `b_setval/2`, `nb_setval/2`, or other global/dynamic-state workarounds.
- Do not use global variables.
- Preserve the exact predicate names, arities, argument order, and output formats specified by the problem statement.
- Do not hard-code an answer when the assignment requires deriving it from constraints or generating it algorithmically.
- Keep predicates deterministic when the specification requires a single result; preserve backtracking when the specification requires enumeration.
- Do not hide errors with broad exception handling. Handle specified edge cases explicitly.

## 4. Problem-specific requirements to keep in view

The active problem statement is authoritative. Apply only the subsection relevant to the current task.

### P1 — Department Assignment Puzzle

- Represent each person using the exact required term shape `p(Name, Dept, Lang, Project)`.
- Use the exact quoted name atoms and attribute atoms required by the assignment.
- Each of the four values in each attribute category must be used exactly once.
- Each clue must be represented by its own `clue(N, Solution)` clause and must succeed exactly when that clue holds for a fully instantiated solution.
- Keep clue checking separate from solution construction where practical.
- The solution must be derived from the constraints; do not hard-code the displayed example layout or an inferred answer.
- `count_solutions(Active, N)` must count solutions satisfying exactly the active clue numbers and ignore inactive clues. Use `findall/3` or `aggregate_all/3`, as specified.
- The ninth clue must be expressed without mentioning any friend by name. It must be true in the retained solution and false in every other solution satisfying clues 1–8.
- Only the required `main/0` output should be printed by the main predicate. Do not print when the file is loaded.

### P2 — Arithmetic Equation Generator

- Use an explicit expression-tree representation internally; do not build a string and parse it back into a Prolog term to evaluate it.
- Preserve the given number order and use every input number exactly once.
- The equality must split the list into a non-empty left segment and a non-empty right segment.
- Expressions may use only the specified binary operators and must respect the no-unary-minus rule.
- Every division must be exact, and every divisor must be non-zero. Check this at each division node, not only at the final result.
- Both sides must evaluate to the same integer.
- Produce the required SWI-Prolog **string** format, not an atom or code list.
- Canonical formatting must preserve expression-tree distinctions and follow the assignment's precedence, associativity, and parenthesization rules.
- `generate_equation/2` must fail cleanly for inputs with no solution, including lists of length zero or one; it must not loop or raise an avoidable arithmetic error.
- `all_equations/2` must return no duplicates and use `sort/2` as required. `count_equations/2` must report the length of that result.

## 5. Prolog reasoning and implementation conventions

- Prefer declarative predicates that describe relationships over procedural code that merely imitates an algorithm.
- Use unification to describe structure; use `is/2` and arithmetic comparisons only when values are sufficiently instantiated.
- Remember: `=/2` unifies terms; `=:=/2`, `=\=/2`, `<`, `=<`, `>`, and `>=` compare arithmetic values.
- Remember that arithmetic expressions are evaluated by arithmetic predicates; writing `X = 2 + 3` does not evaluate the expression.
- Make instantiation requirements explicit. Avoid calling arithmetic evaluation on an unbound variable.
- Think carefully about variable sharing, clause order, and backtracking.
- Use cuts only when their logical effect is justified by the specification. Do not add cuts merely to make a predicate appear deterministic.
- Avoid accidental duplicate derivations when the required result is a set or a duplicate-free list.
- Make recursive predicates progress toward a clear base case.
- Keep helper predicates small and give them names that describe their logical role.
- Prefer pattern matching on lists (`[]`, `[Head|Tail]`) over unnecessary indexing.
- Use comments to explain non-obvious logical choices, not to narrate every line.

## 6. Testing and execution

Use the exact execution commands required by the assignment.

For a main predicate:

```bash
swipl -q -f code/id_q1.pl -g main -t halt
```

For another goal:

```bash
swipl -q -f code/id_q1.pl -g "<goal>" -t halt
```

Adapt the filename and goal to the problem being tested. Do not put `halt/0` in the submitted source file; it is part of the command line.

Testing expectations:

- Test the examples supplied in the assignment.
- Add edge cases specific to the predicate being implemented.
- Test both success and failure where relevant.
- Test enumeration and backtracking, not only the first answer.
- For counting predicates, verify counts against independently inspectable solution lists on small cases where feasible.
- For arithmetic expressions, test exact division, division by zero, negative intermediate values, precedence, associativity, parentheses, duplicate prevention, and no-solution inputs.
- Keep tests in the required separate test file; do not leave test calls or debug output in the submitted solution file.

## 7. Self-review checklist — apply before returning code

Before presenting or committing a predicate, verify all applicable items:

1. Does this response implement only the unit requested by the current prompt?
2. Does the code use SWI-Prolog 9.x-compatible syntax?
3. Are all imports limited to the permitted libraries?
4. Are predicate names, arities, and argument order exact?
5. Are variables correctly instantiated before arithmetic evaluation?
6. Are unification and arithmetic comparison used appropriately?
7. Does recursion have a valid base case and make progress?
8. Is backtracking preserved or restricted only as required?
9. Are duplicate solutions possible? If so, are they permitted?
10. Are all specified edge cases handled?
11. Is there any forbidden state mutation, global state, initialization, or unsolicited output?
12. Does the code avoid hard-coding a result that must be derived?
13. Can the unit be tested independently with a focused goal?
14. Have you stated any assumptions or dependencies on predicates that are not yet implemented?

If a checklist item cannot be verified from the available context, say so rather than claiming it passed.

## 8. Common AI failure modes in Prolog

Watch specifically for these mistakes:

- Confusing unification (`=/2`) with arithmetic equality (`=:=/2`).
- Using `is/2` with an uninstantiated arithmetic expression.
- Accidentally making a predicate succeed for partially instantiated data when the specification requires a fully filled solution.
- Writing a clue predicate that checks the wrong person or attribute position.
- Forgetting the all-different constraint in a logic puzzle.
- Using cuts that suppress valid solutions.
- Producing duplicate solutions through multiple derivation paths.
- Counting proofs or derivations instead of distinct solutions.
- Using `findall/3` in a way that loses intended variable relationships or collects the wrong term.
- Failing to handle empty and singleton lists before recursive processing.
- Allowing division by zero or non-exact division to raise an arithmetic error.
- Checking only the final arithmetic result instead of validating every division node.
- Formatting an expression string that does not faithfully represent the expression tree.
- Returning an atom or code list where an SWI-Prolog string is required.
- Printing diagnostics that break the grader's expected output.
- Importing a convenient but prohibited library.

## 9. Response format for each implementation prompt

For each narrowly scoped implementation task:

1. Briefly restate the one requested unit.
2. Identify assumptions or dependencies on already-existing predicates.
3. Provide only the code needed for that unit, with any tightly necessary helper predicate.
4. Explain the key logic briefly, especially non-obvious Prolog semantics.
5. Provide one or more focused test goals or test cases for that unit, unless the prompt is specifically asking for a test file or review.
6. Explicitly identify anything not yet verified.

Do not generate the whole problem solution, a full replacement source file, or unrelated future predicates unless the current prompt explicitly requests that single file/review as its one unit of work.