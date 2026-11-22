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
