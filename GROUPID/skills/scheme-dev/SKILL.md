---
name: scheme-dev
description: Assignment-specific development and review guidance for CS F301 Assignment 2 Scheme work in Racket 8.x. Use for S1 and S2 only.
---

# Scheme Development Skill — CS F301 Assignment 2

## 1. Purpose and operating contract

Use this skill when implementing, testing, debugging, or reviewing either Scheme problem in CS F301 Assignment 2.

You are a coding assistant working under an explicit assignment decomposition rule:

- **One prompt = one unit of work.**
- A unit is one function, one narrowly scoped helper function, one test file, or one review.
- Do not implement an entire problem, a collection of unrelated functions, or all remaining work in one response.
- Implement only the deliverable requested by the current prompt. Do not proactively write other functions just because they will eventually be needed.
- If the requested unit genuinely requires a helper function, explain why and keep the helper tightly coupled to that unit. Do not use this as a way to implement multiple independent assignment requirements.
- If a prompt requests several independent deliverables, point out the decomposition issue and ask for a narrower prompt rather than silently doing all of them.

The user may provide the full problem statement as context. Treat that as specification, not permission to solve the whole problem.

## 2. Language and runtime

- Language: Scheme, using **Racket 8.x**.
- Every submitted Scheme source file must begin with:

```scheme
#lang racket/base
```

- Use only the built-ins explicitly permitted by the assignment. Do not assume that a procedure is allowed merely because it is part of `racket/base`.
- Do not add `require` declarations or import extra libraries.
- Do not use any external packages.

## 3. Exact permitted built-ins

The assignment permits the following forms and procedures for both S1 and S2:

- Forms: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, and `quote` (written with `'`).
- List construction and access: `cons`, `car`, `cdr`, `list`.
- Predicates and association lookup: `null?`, `pair?`, `eq?`, `assq`, `assoc`.
- Selectors: compositions of `car` and `cdr` up to four levels, including selectors such as `cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, and `cddddr`.
- Arithmetic and comparison: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`.
- Output: `display`, `newline`.

**S2 additionally permits `read`.**

Do not use any other built-in unless the assignment statement is explicitly amended by the instructor.

In particular, these are forbidden:

- Mutation: `set!` and related mutation forms.
- Data structures: vectors, hash tables, strings.
- Iteration forms: `do`, `for`, and similar loop constructs.
- Common list procedures: `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, and `list-tail`.
- Other convenient procedures not in the permitted list, even if they are normally available in Racket.

If a needed operation is absent, implement a suitable helper using only permitted constructs. Examples include a custom list length or custom map.

## 4. Assignment-wide source and execution constraints

- Scheme files must contain definitions only, apart from the required `#lang racket/base` declaration.
- Do not call the submitted functions at the top level.
- Do not print anything merely because a file is loaded.
- The grader appends its own calls to the end of the file.
- Preserve exact function names, arities, argument order, and output format from the problem statement.
- Pass state through function arguments; do not use mutation or hidden global state.
- Do not add imports, helper libraries, or unsupported language features.
- Do not solve a task by converting the input into a forbidden representation such as strings or vectors.
- Handle empty lists and other specified edge cases explicitly.

## 5. Problem-specific requirements to keep in view

The active problem statement is authoritative. Apply only the subsection relevant to the current task.

### S1 — Binary Tree Traversals

- A tree is either the empty list `()` or a three-element list `(value left right)`.
- The empty tree has height 0 and no leaves.
- A node's height is one plus the larger of its left and right subtree heights.
- A leaf is a node whose left and right subtrees are both empty.
- Visit the left subtree before the right subtree.
- Inorder order: left, node, right.
- Preorder order: node, left, right.
- Postorder order: left, right, node.
- Match the exact required printed output: use `display` and end each function's output with `newline`.
- The grader supplies the trees and calls the functions. Do not add your own top-level calls.
- Prefer tail recursion where it is natural, but do not sacrifice correctness or clarity merely to force tail recursion.

### S2 — Conditionally Insert into a Nested List

- `insert-if-short` takes an atom `x`, a possibly nested list `lst`, and an integer `n`.
- Insert `x` at the front of every list whose length is strictly less than `n`, at every nesting level.
- A list's length is the number of its top-level elements, measured on the **original list before insertion**.
- The top-level list is treated exactly like every other list.
- Empty lists are not special: they have length 0 and become `(x)` when `0 < n`; this includes an empty top-level input.
- `x` is an atom; list elements are atoms or nested lists; there are no dotted pairs; `n` is non-negative.
- Implement your own `my-length` and `my-map` using permitted built-ins.
- Implement `make-inserter` as a higher-order function: it takes `x` and a one-argument predicate `len-ok?`, and returns a function that processes a list recursively at every nesting level.
- The final `insert-if-short` definition must use `make-inserter`. The final file must contain only one definition of `insert-if-short`—the one based on `make-inserter`.
- `print-insert-result` reads `x`, then `lst`, then `n` from standard input, and prints only the resulting list followed by a newline. It must not print a prompt or explanatory text.
- S2 hidden tests include nesting depth 100 and lists of 10,000 elements. Avoid unnecessarily expensive repeated traversals and ensure recursive processing is appropriate for these sizes.

## 6. Scheme reasoning and implementation conventions

- Use structural recursion over lists and trees.
- For an empty list, test with `null?` before applying `car` or `cdr`.
- Use `pair?` when distinguishing a non-empty pair/list from an atom, according to the problem's input guarantees.
- Use `eq?` for symbol identity where appropriate; do not assume it is a general numeric equality test.
- Use `=` for numeric equality.
- Remember that Scheme treats the empty list `()` as false? **No.** In Scheme, only `#f` is false; the empty list is truthy. Do not use a list as a Boolean condition.
- Use `let`, `let*`, `letrec`, or named `let` for local bindings and recursion where appropriate.
- Prefer pure functions: return constructed values rather than mutating existing data.
- When building a list recursively, reason carefully about element order. Avoid accidentally reversing traversal order.
- For nested lists, distinguish an atom from a sublist and recurse only where the specification requires it.
- Measure list lengths before insertion, not after insertion.
- Keep helper functions small and name them according to their purpose.
- Use `begin` when multiple output actions must occur in sequence.
- Do not add debugging `display` calls.

## 7. Testing and execution

Use the commands required by the assignment:

```bash
racket code/id_q3.rkt
racket code/id_q4.rkt
```

The submitted files should not print anything simply from being loaded. The grader appends calls to the file. For local testing, use a separate test file or a temporary harness that does not become part of the submitted solution file.

Testing expectations:

### S1 tests
- Empty tree.
- Single-node tree.
- Balanced tree.
- Left-skewed tree.
- Right-skewed tree.
- Trees containing symbols as values.
- Confirm exact inorder, preorder, and postorder ordering.
- Confirm height and leaf count, including the empty-tree result.

### S2 tests
- All three examples in the assignment.
- Empty top-level list with `n > 0` and with `n = 0`.
- Empty nested lists.
- Lists whose length is exactly `n` (must not receive insertion).
- Lists shorter than `n` and longer than `n`.
- Multiple nesting levels.
- Confirm the original-list-length rule.
- A nesting depth of 100.
- A list containing 10,000 elements.
- Confirm that output contains no prompts or extra text.

## 8. Self-review checklist — apply before returning code

Before presenting or committing a function, verify all applicable items:

1. Does this response implement only the unit requested by the current prompt?
2. Does the file begin with `#lang racket/base`?
3. Does the code use only the explicitly permitted built-ins?
4. Are there any accidental uses of `length`, `append`, `map`, `reverse`, `list-ref`, strings, vectors, hashes, mutation, or imports?
5. Are function names, arities, and argument order exact?
6. Are empty lists handled before `car` or `cdr` is used?
7. Does recursion make progress and terminate for the specified input?
8. Is list/tree traversal order correct?
9. Is the distinction between atoms and nested lists handled correctly?
10. Are values computed from the original input where the specification requires it?
11. Is state passed through arguments rather than mutation?
12. Does loading the file produce no output?
13. Are output formatting and newline requirements exact?
14. Have the relevant edge cases been tested?
15. Have you stated any assumptions or dependencies on functions not yet implemented?

If a checklist item cannot be verified from the available context, say so rather than claiming it passed.

## 9. Common AI failure modes in Scheme/Racket

Watch specifically for these mistakes:

- Using a convenient but prohibited built-in such as `map`, `append`, `length`, or `reverse`.
- Assuming every procedure available in `racket/base` is allowed by the assignment.
- Adding `require` to access a helper library.
- Using `set!`, vectors, hashes, strings, or forbidden loop constructs.
- Treating `()` as false in a conditional.
- Calling `car` or `cdr` on an empty list.
- Confusing an atom with a nested list.
- Returning a value in the wrong list order because of recursive construction.
- Incorrectly handling the empty tree or empty nested list.
- Counting a node as a leaf when only one child is empty.
- Computing tree traversals in the wrong order.
- Calculating height incorrectly for skewed trees.
- In S2, measuring list length after inserting `x` instead of before insertion.
- Forgetting that the top-level list is subject to insertion too.
- Treating empty lists as exempt from insertion.
- Defining `insert-if-short` more than once in the final file.
- Implementing `insert-if-short` directly instead of defining it through `make-inserter`.
- Making repeated traversals that are unnecessarily expensive for the 10,000-element test.
- Printing prompts, debugging information, or output during file loading.
- Using non-tail-recursive patterns in a way that causes avoidable stack problems on the specified large inputs.

## 10. Response format for each implementation prompt

For each narrowly scoped implementation task:

1. Briefly restate the one requested unit.
2. Identify assumptions or dependencies on already-existing functions.
3. Provide only the code needed for that unit, with any tightly necessary helper function.
4. Explain the key recursion and list/tree logic briefly.
5. Provide focused test cases for that unit, unless the prompt is specifically asking for a test file or review.
6. Explicitly identify anything not yet verified.

Do not generate the whole problem solution, a full replacement source file, or unrelated future functions unless the current prompt explicitly requests that single file/review as its one unit of work.