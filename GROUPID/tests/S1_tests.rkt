;; tests/id_q3_tests.rkt  -- S1 tests (no #lang line; see run command below)
;; Run from the repo root:
;;   cat code/id_q3.rkt tests/id_q3_tests.rkt > /tmp/s1_run.rkt && racket /tmp/s1_run.rkt

;; ---------- Test utilities (test-only, permitted built-ins only) ----------

(define (same? a b)
  (cond ((null? a) (null? b))
        ((pair? a) (and (pair? b)
                        (same? (car a) (car b))
                        (same? (cdr a) (cdr b))))
        (else (eq? a b))))

(define (check name actual expected)
  (begin
    (display (if (same? actual expected) "PASS " "FAIL "))
    (display name)
    (newline)))

;; Test-only builder for deep trees: values n, n-1, ..., 1 along the left spine.
(define (build-left-skewed n)
  (if (= n 0)
      '()
      (list n (build-left-skewed (- n 1)) '())))

;; ---------- Test trees ----------

(define t1 '(4 (2 (1 () ()) (3 () ()))
               (6 (5 () ()) (7 () ()))))      ; balanced (assignment)
(define t2 '(1 () (2 () (3 () ()))))          ; right-skewed (assignment)
(define t3 '(a (b () ()) (c () ())))          ; symbols (assignment)
(define t-empty '())
(define t-single '(5 () ()))
(define t-left '(3 (2 (1 () ()) ()) ()))      ; left-skewed
(define t-one-child '(1 (2 () ()) ()))        ; one empty child: not a leaf
(define t-mixed '(1 (2 () (3 () ())) (4 () ())))
(define t-deep (build-left-skewed 1000))

;; ---------- Automated checks: traversal lists ----------

(check "inorder empty"        (tree-inorder t-empty) '())
(check "preorder empty"       (tree-preorder t-empty) '())
(check "postorder empty"      (tree-postorder t-empty) '())

(check "inorder single"       (tree-inorder t-single) '(5))
(check "preorder single"      (tree-preorder t-single) '(5))
(check "postorder single"     (tree-postorder t-single) '(5))

(check "inorder t1"           (tree-inorder t1) '(1 2 3 4 5 6 7))
(check "preorder t1"          (tree-preorder t1) '(4 2 1 3 6 5 7))
(check "postorder t1"         (tree-postorder t1) '(1 3 2 5 7 6 4))

(check "inorder t2"           (tree-inorder t2) '(1 2 3))
(check "preorder t2"          (tree-preorder t2) '(1 2 3))
(check "postorder t2"         (tree-postorder t2) '(3 2 1))

(check "inorder t3 symbols"   (tree-inorder t3) '(b a c))
(check "preorder t3 symbols"  (tree-preorder t3) '(a b c))
(check "postorder t3 symbols" (tree-postorder t3) '(b c a))

(check "inorder left-skewed"   (tree-inorder t-left) '(1 2 3))
(check "preorder left-skewed"  (tree-preorder t-left) '(3 2 1))
(check "postorder left-skewed" (tree-postorder t-left) '(1 2 3))

(check "inorder one-child"    (tree-inorder t-one-child) '(2 1))
(check "preorder one-child"   (tree-preorder t-one-child) '(1 2))
(check "postorder one-child"  (tree-postorder t-one-child) '(2 1))

(check "inorder mixed"        (tree-inorder t-mixed) '(2 3 1 4))
(check "preorder mixed"       (tree-preorder t-mixed) '(1 2 3 4))
(check "postorder mixed"      (tree-postorder t-mixed) '(3 2 4 1))

;; ---------- Automated checks: height and leaves ----------

(check "h&l empty"        (tree-height-and-leaves t-empty) '(0 0))
(check "h&l single"       (tree-height-and-leaves t-single) '(1 1))
(check "h&l t1 balanced"  (tree-height-and-leaves t1) '(3 4))
(check "h&l t2 right"     (tree-height-and-leaves t2) '(3 1))
(check "h&l t3 symbols"   (tree-height-and-leaves t3) '(2 2))
(check "h&l left-skewed"  (tree-height-and-leaves t-left) '(3 1))
(check "h&l one-child"    (tree-height-and-leaves t-one-child) '(2 1))
(check "h&l mixed"        (tree-height-and-leaves t-mixed) '(3 2))

;; ---------- Automated checks: deep tree (stack/recursion sanity) ----------

(check "h&l deep 1000"       (tree-height-and-leaves t-deep) '(1000 1))
(check "inorder deep first"  (car (tree-inorder t-deep)) 1)
(check "preorder deep first" (car (tree-preorder t-deep)) 1000)
(check "postorder deep first" (car (tree-postorder t-deep)) 1)

;; ---------- Manual checks: exact printed output ----------
;; Compare "actual" with "expected". The <end> marker must appear on its own
;; line, which confirms the function ended with exactly one newline.

(begin (display "=== MANUAL: print-inorder t1") (newline)
       (display "expected: (1 2 3 4 5 6 7)") (newline)
       (display "actual:   ")
       (print-inorder t1)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-inorder empty") (newline)
       (display "expected: ()") (newline)
       (display "actual:   ")
       (print-inorder t-empty)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-all-traversals t1") (newline)
       (display "expected: (1 2 3 4 5 6 7) / (4 2 1 3 6 5 7) / (1 3 2 5 7 6 4), one per line") (newline)
       (display "actual:") (newline)
       (print-all-traversals t1)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-all-traversals t2") (newline)
       (display "expected: (1 2 3) / (1 2 3) / (3 2 1)") (newline)
       (display "actual:") (newline)
       (print-all-traversals t2)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-all-traversals t3") (newline)
       (display "expected: (b a c) / (a b c) / (b c a)") (newline)
       (display "actual:") (newline)
       (print-all-traversals t3)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-all-traversals empty") (newline)
       (display "expected: () / () / ()") (newline)
       (display "actual:") (newline)
       (print-all-traversals t-empty)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-height-and-leaves t1") (newline)
       (display "expected: (3 4)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t1)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-height-and-leaves t2") (newline)
       (display "expected: (3 1)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t2)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-height-and-leaves t3") (newline)
       (display "expected: (2 2)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t3)
       (display "<end>") (newline))

(begin (display "=== MANUAL: print-height-and-leaves empty") (newline)
       (display "expected: (0 0)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t-empty)
       (display "<end>") (newline))


#|
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
|#

(define (same? a b)
  (cond ((null? a) (null? b))
        ((pair? a) (and (pair? b)
                        (same? (car a) (car b))
                        (same? (cdr a) (cdr b))))
        (else (eq? a b))))

(define (check name actual expected)
  (begin
    (display (if (same? actual expected) "PASS " "FAIL "))
    (display name)
    (newline)))

(define (build-left-skewed n)
  (if (= n 0)
      '()
      (list n (build-left-skewed (- n 1)) '())))

(define t1 '(4 (2 (1 () ()) (3 () ()))
               (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define t-empty '())
(define t-single '(5 () ()))
(define t-left '(3 (2 (1 () ()) ()) ()))
(define t-one-child '(1 (2 () ()) ()))
(define t-mixed '(1 (2 () (3 () ())) (4 () ())))
(define t-deep (build-left-skewed 1000))

(check "inorder empty"        (tree-inorder t-empty) '())
(check "preorder empty"       (tree-preorder t-empty) '())
(check "postorder empty"      (tree-postorder t-empty) '())
(check "inorder single"       (tree-inorder t-single) '(5))
(check "preorder single"      (tree-preorder t-single) '(5))
(check "postorder single"     (tree-postorder t-single) '(5))
(check "inorder t1"           (tree-inorder t1) '(1 2 3 4 5 6 7))
(check "preorder t1"          (tree-preorder t1) '(4 2 1 3 6 5 7))
(check "postorder t1"         (tree-postorder t1) '(1 3 2 5 7 6 4))
(check "inorder t2"           (tree-inorder t2) '(1 2 3))
(check "preorder t2"          (tree-preorder t2) '(1 2 3))
(check "postorder t2"         (tree-postorder t2) '(3 2 1))
(check "inorder t3 symbols"   (tree-inorder t3) '(b a c))
(check "preorder t3 symbols"  (tree-preorder t3) '(a b c))
(check "postorder t3 symbols" (tree-postorder t3) '(b c a))
(check "inorder left-skewed"   (tree-inorder t-left) '(1 2 3))
(check "preorder left-skewed"  (tree-preorder t-left) '(3 2 1))
(check "postorder left-skewed" (tree-postorder t-left) '(1 2 3))
(check "inorder one-child"    (tree-inorder t-one-child) '(2 1))
(check "preorder one-child"   (tree-preorder t-one-child) '(1 2))
(check "postorder one-child"  (tree-postorder t-one-child) '(2 1))
(check "inorder mixed"        (tree-inorder t-mixed) '(2 3 1 4))
(check "preorder mixed"       (tree-preorder t-mixed) '(1 2 3 4))
(check "postorder mixed"      (tree-postorder t-mixed) '(3 2 4 1))

(check "h&l empty"        (tree-height-and-leaves t-empty) '(0 0))
(check "h&l single"       (tree-height-and-leaves t-single) '(1 1))
(check "h&l t1 balanced"  (tree-height-and-leaves t1) '(3 4))
(check "h&l t2 right"     (tree-height-and-leaves t2) '(3 1))
(check "h&l t3 symbols"   (tree-height-and-leaves t3) '(2 2))
(check "h&l left-skewed"  (tree-height-and-leaves t-left) '(3 1))
(check "h&l one-child"    (tree-height-and-leaves t-one-child) '(2 1))
(check "h&l mixed"        (tree-height-and-leaves t-mixed) '(3 2))

(check "h&l deep 1000"       (tree-height-and-leaves t-deep) '(1000 1))
(check "inorder deep first"  (car (tree-inorder t-deep)) 1)
(check "preorder deep first" (car (tree-preorder t-deep)) 1000)
(check "postorder deep first" (car (tree-postorder t-deep)) 1)

(begin (display "=== MANUAL: print-inorder t1") (newline)
       (display "expected: (1 2 3 4 5 6 7)") (newline)
       (display "actual:   ")
       (print-inorder t1)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-inorder empty") (newline)
       (display "expected: ()") (newline)
       (display "actual:   ")
       (print-inorder t-empty)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-all-traversals t1") (newline)
       (display "expected: (1 2 3 4 5 6 7) / (4 2 1 3 6 5 7) / (1 3 2 5 7 6 4)") (newline)
       (display "actual:") (newline)
       (print-all-traversals t1)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-all-traversals t2") (newline)
       (display "expected: (1 2 3) / (1 2 3) / (3 2 1)") (newline)
       (display "actual:") (newline)
       (print-all-traversals t2)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-all-traversals t3") (newline)
       (display "expected: (b a c) / (a b c) / (b c a)") (newline)
       (display "actual:") (newline)
       (print-all-traversals t3)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-all-traversals empty") (newline)
       (display "expected: () / () / ()") (newline)
       (display "actual:") (newline)
       (print-all-traversals t-empty)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-height-and-leaves t1") (newline)
       (display "expected: (3 4)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t1)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-height-and-leaves t2") (newline)
       (display "expected: (3 1)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t2)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-height-and-leaves t3") (newline)
       (display "expected: (2 2)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t3)
       (display "<end>") (newline))
(begin (display "=== MANUAL: print-height-and-leaves empty") (newline)
       (display "expected: (0 0)") (newline)
       (display "actual:   ")
       (print-height-and-leaves t-empty)
       (display "<end>") (newline))
