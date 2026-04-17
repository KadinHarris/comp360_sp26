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



;; BEFORE YOU BEGIN:
;;  - Run tokenize-only-test.rkt or read lexer.rkt:
;;    what are the tokens in this language?
;;  - Run parse-only-test.rkt AND the parser:
;;    what kind of parse-tree nodes are there?

;; Therefore, what functions/macros/definitions will we need
;; for this language?
;; ANSWER: Everything in the parse-tree needs to be a macro or function



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
;; SMPL supports variable assignment (x = 5). Instead of a hash
;; table, we use macros to expand assignments into real Racket
;; (define ...) forms, and variable references into identifiers.
;; format-id converts the string name into a Racket identifier
;; at compile time.


;; ============================================================
;; TOPIC 3: The #%module-begin macro (syntax templates/patterns)
;; ============================================================
;; Every Racket module needs a #%module-begin form.
;; The reader wraps our parsed tree in:
;;   (module smpl-mod day33_SMPL/expander (smpl-program ...))
;;
;; Racket then looks for #%module-begin in our expander.
;; We define a macro that destructures the smpl-program node
;; and emits #%module-begin with the statements inside.
;;
;; KEY CONCEPTS:
;;   - define-macro creates a compile-time transformation (vs run-time execution)
;;   - The pattern (smpl-module-begin (smpl-program STATEMENT ...))
;;     matches the incoming syntax and binds STATEMENT to each
;;     child node of smpl-program
;;   - #'(...) is a "syntax template" — it creates new syntax
;;     with the pattern variables filled in
;;   - The ... (ellipsis) means "repeat for each match"
;;
;; TODO: Fill in the syntax template for smpl-module-begin.
;; It should expand to (#%module-begin STATEMENT ...)
;; which simply places all statements at the module top-level.

(define-macro (smpl-module-begin (smpl-program STATEMENT ...))
  #'(#%module-begin
     STATEMENT ...))
 
(provide (rename-out [smpl-module-begin #%module-begin]))
;; This rename is what makes our macro THE module-begin for SMPL.


;; ============================================================
;; TOPIC 4: Variable definitions - smpl-assign
;; ============================================================
;; The parser produces: (smpl-assign "x" <expr>)
;; where "x" is the variable name (a string from the ID token)
;; and <expr> is the value expression.
;;
;; We use a macro to expand (smpl-assign "x" <expr>) into
;; (define x <expr>), turning SMPL variables into real Racket
;; bindings.
;;
;; TODO: Fill in the macro body.
;; GIVEN: use format-id to create an identifier from the string,
;;        with-pattern to bind it, and expand to (define VAR-NAME VAL).

(define-macro (smpl-assign ID VAL)
  (with-pattern ([VAR-NAME (format-id #'ID "~a" (syntax->datum #'ID))])
    (define VAR-NAME VAL))) ; this just needs to define a variable VAR-NAME with value VAL!


;; ============================================================
;; TOPIC 5: Variable lookup - smpl-id
;; ============================================================
;; The parser produces: (smpl-id "x")
;; We expand this into the actual Racket identifier, so
;; (smpl-id "x") becomes just x.
;;
;; TODO: Fill in the macro body.

(define-macro (smpl-id ID)
  (with-pattern ([VAR-NAME (format-id #'ID "~a" (syntax->datum #'ID))])
    (define ID VAR-NAME))) ; this just needs to expand an ID to its actual variable name!


;; ============================================================
;; TOPIC 6: Print - smpl-print
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
  ())


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
;;        (define new-result ???) ; this is for you to figure out! use val and result
;;        (helper new-result (cddr remaining))]))
;;   (helper (car args) (cdr args))

(define (smpl-sum . args)
  'TODO)


;; TODO: Define smpl-product. Same pattern as smpl-sum,
;; but with "*" and "/" instead of "+" and "-".

(define (smpl-product . args)
  'TODO)
