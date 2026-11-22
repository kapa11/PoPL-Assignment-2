#lang racket/base

(define (my-length lst)
  (let loop ([rem lst] [acc 0])
    (if (null? rem)
        acc
        (loop (cdr rem) (+ acc 1)))))

