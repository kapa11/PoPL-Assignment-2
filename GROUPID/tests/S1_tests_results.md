# S1: Binary Tree Traversals: Test Results

**Implementation:** `code/id_q3.rkt`
**Tests:** `tests/id_q3_tests.rkt`
**Environment:** Racket v8.10 [cs] (the assignment specifies Racket 8.x)

## Summary

| Check | Result |
|---|---|
| Load check (`racket code/id_q3.rkt` prints nothing) | Pass |
| Automated checks | **36 / 36 passed**, 0 failed |
| Manual printed-output checks | **10 / 10 matched** expected output |

## How to reproduce

The implementation file has no `provide`, and test calls must stay out of it. The test file therefore has no `#lang` line and is concatenated after the implementation, the same way the grader appends its own calls.

```bash
# 1. Load check: must print nothing
racket code/id_q3.rkt

# 2. Run all tests
cat code/id_q3.rkt tests/id_q3_tests.rkt > /tmp/s1_run.rkt
racket /tmp/s1_run.rkt
```

## Automated checks (36)

Each check compares the actual result with the expected value using a test-only `same?` (built from `null?`, `pair?`, `eq?`).

### Traversal order (24)

| Tree | Shape | Inorder | Preorder | Postorder |
|---|---|---|---|---|
| `()` | Empty | `()` | `()` | `()` |
| `(5 () ())` | Single node | `(5)` | `(5)` | `(5)` |
| `t1` | Balanced (assignment) | `(1 2 3 4 5 6 7)` | `(4 2 1 3 6 5 7)` | `(1 3 2 5 7 6 4)` |
| `t2` | Right-skewed (assignment) | `(1 2 3)` | `(1 2 3)` | `(3 2 1)` |
| `t3` | Symbols (assignment) | `(b a c)` | `(a b c)` | `(b c a)` |
| `(3 (2 (1 () ()) ()) ())` | Left-skewed | `(1 2 3)` | `(3 2 1)` | `(1 2 3)` |
| `(1 (2 () ()) ())` | One empty child | `(2 1)` | `(1 2)` | `(2 1)` |
| `(1 (2 () (3 () ())) (4 () ()))` | Mixed | `(2 3 1 4)` | `(1 2 3 4)` | `(3 2 4 1)` |

All 24: **PASS**

### Height and leaf count (8)

| Tree | Expected `(height leaves)` | Result |
|---|---|---|
| Empty | `(0 0)` | PASS |
| Single node | `(1 1)` | PASS |
| `t1` | `(3 4)` | PASS |
| `t2` | `(3 1)` | PASS |
| `t3` | `(2 2)` | PASS |
| Left-skewed | `(3 1)` | PASS |
| One empty child | `(2 1)` | PASS |
| Mixed | `(3 2)` | PASS |

The one-child and mixed trees confirm that a node with only one empty subtree is not counted as a leaf.

### Deep tree, depth 1000 (4)

| Check | Result |
|---|---|
| Height and leaves = `(1000 1)` | PASS |
| First element of inorder = `1` | PASS |
| First element of preorder = `1000` | PASS |
| First element of postorder = `1` | PASS |

## Manual printed-output checks (10)

Capturing printed text needs strings or ports, which the assignment forbids. These checks print `expected` and `actual` side by side and end with an `<end>` marker. `<end>` appearing on its own line confirms exactly one trailing newline.

| Function | Tree | Expected output | Matched |
|---|---|---|---|
| `print-inorder` | `t1` | `(1 2 3 4 5 6 7)` | Yes |
| `print-inorder` | empty | `()` | Yes |
| `print-all-traversals` | `t1` | `(1 2 3 4 5 6 7)` / `(4 2 1 3 6 5 7)` / `(1 3 2 5 7 6 4)` | Yes |
| `print-all-traversals` | `t2` | `(1 2 3)` / `(1 2 3)` / `(3 2 1)` | Yes |
| `print-all-traversals` | `t3` | `(b a c)` / `(a b c)` / `(b c a)` | Yes |
| `print-all-traversals` | empty | `()` / `()` / `()` | Yes |
| `print-height-and-leaves` | `t1` | `(3 4)` | Yes |
| `print-height-and-leaves` | `t2` | `(3 1)` | Yes |
| `print-height-and-leaves` | `t3` | `(2 2)` | Yes |
| `print-height-and-leaves` | empty | `(0 0)` | Yes |

## Scope and limitations

- Tests cover the assignment's examples plus the edge cases listed above. They do not guarantee that the grader's hidden tests pass.
- Depth was tested only to 1000.
- The manual printed-output checks were verified by reading the output, not by an automated comparison.
- `same?` uses `eq?`, which is safe for the small integers and symbols used here but not for large or non-integer numbers.
