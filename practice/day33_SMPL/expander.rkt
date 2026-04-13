#lang br/quicklang

;; ============================================================
;; SMPL Expander Practice
;; ============================================================
;; SMPL is a simple language with assignment, print, and math.
;;
;; A sample SMPL program:
;;   x = 5
;;   y = 10
;;   print x + y
;;
;; After parsing, the reader hands us an s-expression like:
;;   (smpl-program
;;     (smpl-assign "x" (smpl-sum (smpl-product 5)))
;;     (smpl-assign "y" (smpl-sum (smpl-product 10)))
;;     (smpl-print (smpl-sum (smpl-product (smpl-id "x"))
;;                           "+"
;;                           (smpl-product (smpl-id "y")))))
;;
;; Our job: define macros and functions so that each smpl-___
;; node becomes executable Racket code.
;; ============================================================


;; ============================================================
;; TOPIC 1: The provide statement
;; ============================================================
;; In Beautiful Racket, the expander must provide all identifiers
;; that the parsed s-expression uses. Since every node from our
;; parser starts with "smpl-", we can provide them all at once
;; using a regex matcher:

(provide (matching-identifiers-out #rx"^smpl-" (all-defined-out)))

;; This says: "provide everything defined in this file whose
;; name starts with smpl-."


;; ============================================================
;; TOPIC 2: Variable storage
;; ============================================================
;; SMPL supports variable assignment (x = 5). We need somewhere
;; to store variable values at runtime. A mutable hash table
;; is the simplest approach:

(define vars (make-hash))

;; When we see (smpl-assign "x" 5), we'll store "x" -> 5.
;; When we see (smpl-id "x"), we'll look up "x".


;; ============================================================
;; TOPIC 3: The #%module-begin macro (syntax templates/patterns)
;; ============================================================
;; Every Racket module needs a #%module-begin form at the top.
;; The reader wraps our parsed tree in:
;;   (module smpl-mod day33_SMPL/expander (smpl-program ...))
;;
;; Racket then looks for #%module-begin in our expander.
;; We define a macro that destructures the smpl-program node
;; and emits #%module-begin with the statements inside.
;;
;; KEY CONCEPTS:
;;   - define-macro creates a compile-time transformation
;;   - The pattern (smpl-module-begin (smpl-program STATEMENT ...))
;;     matches the incoming syntax and binds STATEMENT to each
;;     child of smpl-program
;;   - #'(...) is a "syntax template" — it creates new syntax
;;     with the pattern variables filled in
;;   - The ... (ellipsis) means "repeat for each match"
;;
;; TODO: Fill in the syntax template for smpl-module-begin.
;; It should expand to (#%module-begin STATEMENT ...)
;; which simply places all statements at the module top-level.

(define-macro (smpl-module-begin (smpl-program STATEMENT ...))
  #'(#%module-begin
     'TODO))

(provide (rename-out [smpl-module-begin #%module-begin]))
;; ^ This rename is what makes our macro THE module-begin for SMPL.


;; ============================================================
;; TOPIC 4: Variable definitions — smpl-assign
;; ============================================================
;; The parser produces: (smpl-assign "x" <expr>)
;; where "x" is the variable name (a string from the ID token)
;; and <expr> is the value expression.
;;
;; Since the arguments are evaluated before the function is called,
;; <expr> will already be a number by the time we receive it.
;; We just need to store it in our hash table.
;;
;; TODO: Define smpl-assign as a function that stores a value
;; in the vars hash table.
;; HINT: use hash-set!

(define (smpl-assign id val)
  'TODO)


;; ============================================================
;; TOPIC 5: Variable lookup — smpl-id
;; ============================================================
;; The parser produces: (smpl-id "x")
;; We need to look up the variable's value in the hash table.
;;
;; TODO: Define smpl-id as a function that retrieves a value
;; from the vars hash table.
;; HINT: use hash-ref. For a nice error on undefined variables:
;;   (hash-ref vars name
;;     (λ () (error 'smpl "undefined variable: ~a" name)))

(define (smpl-id name)
  'TODO)


;; ============================================================
;; TOPIC 6: Print — smpl-print
;; ============================================================
;; The parser produces: (smpl-print val1 val2 ...)
;; where each val is either a STRING or an evaluated expression.
;; We want to concatenate them all into one line of output.
;;
;; TODO: Define smpl-print. It takes an arbitrary number of
;; arguments (use the dot syntax: . vals).
;; HINT: (displayln (string-append* (map ~a vals)))
;;   - ~a converts any value to a string
;;   - string-append* joins a list of strings
;;   - displayln prints with a newline

(define (smpl-print . vals)
  'TODO)


;; ============================================================
;; TOPIC 7: Math helpers — smpl-sum and smpl-product
;; ============================================================
;; The parser produces math nodes like:
;;   (smpl-sum <term1> "+" <term2> "-" <term3> ...)
;;   (smpl-product <atom1> "*" <atom2> "/" <atom3> ...)
;;
;; The arguments alternate: value, operator, value, operator, ...
;; When there's only one value (no operators), just return it.
;;
;; For example:
;;   (smpl-sum 3 "+" 7 "-" 2)  => 8
;;   (smpl-product 5)           => 5
;;
;; TODO: Define smpl-sum. Process the argument list left to right,
;; applying each operator to the running result.
;; HINT: Use a recursive helper:
;;   (define (helper result remaining)
;;     (cond
;;       [(null? remaining) result]
;;       [else
;;        (define op (car remaining))     ; "+" or "-"
;;        (define val (cadr remaining))   ; next number
;;        (helper ??? (cddr remaining))]))
;;   (helper (car args) (cdr args))
;;
;; Choose + or - based on whether op is "+".

(define (smpl-sum . args)
  'TODO)


;; TODO: Define smpl-product. Same pattern as smpl-sum,
;; but with "*" and "/" instead of "+" and "-".

(define (smpl-product . args)
  'TODO)
