#lang racket/base

;; ---------- Inorder ----------

;; inorder-acc: tree, list -> list
;; Returns the inorder values of `tree` followed by the elements of `rest`.
(define (inorder-acc tree rest)
  (if (null? tree)
      rest
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) rest)))))

;; tree-inorder: tree -> list
(define (tree-inorder tree)
  (inorder-acc tree '()))

;; ---------- Preorder ----------

;; preorder-acc: tree, list -> list
;; Returns the preorder values of `tree` followed by the elements of `rest`.
(define (preorder-acc tree rest)
  (if (null? tree)
      rest
      (cons (car tree)
            (preorder-acc (cadr tree)
                          (preorder-acc (caddr tree) rest)))))

;; tree-preorder: tree -> list
(define (tree-preorder tree)
  (preorder-acc tree '()))

;; ---------- Postorder ----------

;; postorder-acc: tree, list -> list
;; Returns the postorder values of `tree` followed by the elements of `rest`.
(define (postorder-acc tree rest)
  (if (null? tree)
      rest
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree)
                                    (cons (car tree) rest)))))

;; tree-postorder: tree -> list
(define (tree-postorder tree)
  (postorder-acc tree '()))

;; ---------- Height and leaves ----------

;; tree-height-and-leaves: tree -> (height leaf-count)
(define (tree-height-and-leaves tree)
  (if (null? tree)
      (list 0 0)
      (let* ((left  (tree-height-and-leaves (cadr tree)))
             (right (tree-height-and-leaves (caddr tree)))
             (h     (+ 1 (max (car left) (car right)))))
        (if (and (null? (cadr tree)) (null? (caddr tree)))
            (list h 1)
            (list h (+ (cadr left) (cadr right)))))))

;; ---------- Required printing functions ----------

;; print-inorder: tree -> void
(define (print-inorder tree)
  (begin
    (display (tree-inorder tree))
    (newline)))

;; print-all-traversals: tree -> void
(define (print-all-traversals tree)
  (begin
    (display (tree-inorder tree))
    (newline)
    (display (tree-preorder tree))
    (newline)
    (display (tree-postorder tree))
    (newline)))

;; print-height-and-leaves: tree -> void
(define (print-height-and-leaves tree)
  (begin
    (display (tree-height-and-leaves tree))
    (newline)))
