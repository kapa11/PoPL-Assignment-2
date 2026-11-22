#lang racket/base

(require rackunit)

(define solution-path (build-path (current-directory) "83" "code" "83_q4.rkt"))
(dynamic-require solution-path #f)
(define solution-namespace (module->namespace solution-path))

(define (run expr)
  (parameterize ([current-namespace solution-namespace])
    (eval expr)))

(check-equal? (run '(my-length '())) 0)
(check-equal? (run '(my-length '((1 2) (3) ()))) 3)
(check-equal? (run '(my-map (lambda (x) (* x 2)) '(1 2 3))) '(2 4 6))
(check-equal? (run '(my-map my-length '((1 2) (3 4 5) (6) ()))) '(2 3 1 0))
(check-equal? (run '(insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)) '((42 1 2) (3 4 5) (42 6) (42)))
(check-equal? (run '(insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)) '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))
(check-equal? (run '(insert-if-short 7 '() 3)) '(7))
(check-equal? (run '(insert-if-short 7 '() 0)) '())
(check-equal? (run '(insert-if-short 7 '(()) 3)) '(7 (7)))
(check-equal? (run '(insert-if-short 'a '(1 2 3) 3)) '(1 2 3))
(check-equal? (run '(insert-if-short 'a '(1 2 3) 0)) '(1 2 3))
(check-equal? (run '(insert-if-short 'a '(1) 2)) '(a 1))

(define printed
  (parameterize ([current-input-port (open-input-string "42 ((1 2) (3 4 5) (6) ()) 3")]
                 [current-output-port (open-output-string)])
    (run '(print-insert-result))
    (get-output-string (current-output-port))))
(check-equal? printed "((42 1 2) (3 4 5) (42 6) (42))\n")

(define deep (for/fold ([acc '()]) ([i (in-range 100)]) (list acc)))
(define deep-result (run `(insert-if-short 7 ',deep 0)))
(check-equal? deep-result deep)

(define large (build-list 10000 (lambda (i) i)))
(check-equal? (run `(my-length ',large)) 10000)
(check-equal? (run `(insert-if-short 7 ',large 0)) large)

(displayln "S2 tests passed")
