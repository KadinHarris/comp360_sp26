#lang br/quicklang
(provide (matching-identifiers-out #rx"^smpl-" (all-defined-out)))

;; The #%module-begin macro: destructures the parse tree
;; and places all statements at the module top level
(define-macro (smpl-module-begin (smpl-program STATEMENT ...))
  #'(#%module-begin
     STATEMENT ...))
(provide (rename-out [smpl-module-begin #%module-begin]))

;; Assignment: expand (smpl-assign "x" <expr>) into (define x <expr>)
(define-macro (smpl-assign ID VAL)
  (with-pattern ([VAR-NAME (format-id #'ID "~a" (syntax->datum #'ID))])
    #'(define VAR-NAME VAL)))

;; Variable lookup: expand (smpl-id "x") into x
(define-macro (smpl-id ID)
  (with-pattern ([VAR-NAME (format-id #'ID "~a" (syntax->datum #'ID))])
    #'VAR-NAME))

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
