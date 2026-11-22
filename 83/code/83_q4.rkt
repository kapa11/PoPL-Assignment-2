#lang racket/base

(define (my-length lst)
  (let loop ([rem lst] [acc 0])
    (if (null? rem)
        acc
        (loop (cdr rem) (+ acc 1)))))

(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst)) (my-map f (cdr lst)))))

(define (make-inserter x len-ok?)
  (letrec ([process-list
            (lambda (lst)
              (let ([orig-len (my-length lst)]
                    [mapped (my-map (lambda (elem)
                                      (if (or (pair? elem) (null? elem))
                                          (process-list elem)
                                          elem))
                                    lst)])
                (if (len-ok? orig-len)
                    (cons x mapped)
                    mapped)))])
    process-list))

(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)])
    (display (insert-if-short x lst n))
    (newline)))