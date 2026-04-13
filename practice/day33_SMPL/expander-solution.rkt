#lang br/quicklang
(provide (matching-identifiers-out #rx"^smpl-" (all-defined-out)))

;; Variable storage
(define vars (make-hash))

;; The #%module-begin macro: destructures the parse tree
;; and places all statements at the module top level
(define-macro (smpl-module-begin (smpl-program STATEMENT ...))
  #'(#%module-begin
     STATEMENT ...))
(provide (rename-out [smpl-module-begin #%module-begin]))

;; Assignment: store a value in the variable hash
(define (smpl-assign id val)
  (hash-set! vars id val))

;; Variable lookup: retrieve a value from the hash
(define (smpl-id name)
  (hash-ref vars name
            (λ () (error 'smpl "undefined variable: ~a" name))))

;; Print: concatenate and display all values
(define (smpl-print . vals)
  (displayln (string-append* (map ~a vals))))

;; Math: smpl-sum handles + and -
;; Arguments alternate: value, operator, value, operator, ...
(define (smpl-sum . args)
  (define (helper result remaining)
    (cond
      [(null? remaining) result]
      [else
       (define op (car remaining))
       (define val (cadr remaining))
       (helper ((if (equal? op "+") + -) result val)
               (cddr remaining))]))
  (helper (car args) (cdr args)))

;; Math: smpl-product handles * and /
(define (smpl-product . args)
  (define (helper result remaining)
    (cond
      [(null? remaining) result]
      [else
       (define op (car remaining))
       (define val (cadr remaining))
       (helper ((if (equal? op "*") * /) result val)
               (cddr remaining))]))
  (helper (car args) (cdr args)))
