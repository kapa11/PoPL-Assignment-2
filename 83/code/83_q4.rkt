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
