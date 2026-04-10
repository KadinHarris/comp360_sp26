#lang br/quicklang
(provide (matching-identifiers-out #rx"^b-" (all-defined-out))) ; provides all macros/functions starting with "b-"

; this macro defines new functions of the form line-x where x is the line number
; from the s-expression (b-line NUM STATEMENT ...)
; we use with-pattern to create the string line-x using NUM
; syntax/loc and caller-stx are was of passing around source locations
; for error handling
(define-macro (b-line NUM STATEMENT ...) 
  (with-pattern ([LINE-NUM (prefix-id "line-" #'NUM
                                      #:source #'NUM)]) ; assigns LINE-NUM's srcloc to be NUM's srcloc
    (syntax/loc caller-stx                              ; assigns this new syntax's srcloc to be b-line's srcloc
      (define (LINE-NUM) (void) STATEMENT ...))))

; this macro creates a module starting with #%module-begin, which
; all top-level modules require
; it takes in a string that looks like (b-program ...) where ... is a
; bunch of stuff we're calling LINE
; the module this macro creates is filled with the LINEs
; (which, as we know, have the form (b-line ...), which means the b-line macro
;  will expand them!)
; then, the macro creates a hash table, which maps line numbers
; to line function names (like line-20), but line function names aren't
; by default, which is why we define them in the with-pattern
; finally, the macro calls (void (run line-table))), which is a function
; defined later!
; finally, we rename this module, which is called b-module-begin to #%module-begin
; so that it becomes the top-level module for the reader
(define-macro (b-module-begin (b-program LINE ...))
  (with-pattern
      ([((b-line NUM STMT ...) ...) #'(LINE ...)]
       [(LINE-FUNC ...) (prefix-id "line-" #'(NUM ...))])
    #'(#%module-begin
       LINE ...   ; we can put in a SHIMS ' to see what the expander is producing
       (define line-table
         (apply hasheqv (append (list NUM LINE-FUNC) ...))) ; we can also add code inside this macro
       (void (run line-table)))))
(provide (rename-out [b-module-begin #%module-begin]))

(struct end-program-signal ())
(struct change-line-signal (val))

(define (b-end) (raise (end-program-signal))) ; rasie exception!
(define (b-goto expr) (raise (change-line-signal expr))) ; raise exception!

(define (run line-table)
  (define line-vec ; create a vector of sorted line numbers: helps us decide where to start and what is next
    (list->vector (sort (hash-keys line-table) <)))
  (with-handlers ([end-program-signal? (λ (exn-val) (void))])
    (for/fold ([line-idx 0]) ; starting line is the line at index 0
              ([i (in-naturals)] ; loop over the naturals: keep going forever!
               #:break (>= line-idx (vector-length line-vec))) ; if our line index is out of range, stop!
      (define line-num (vector-ref line-vec line-idx)) ; lookup the line number using the index
      (define line-func (hash-ref line-table line-num)) ; lookup the line function using the line number
      (with-handlers
          ([change-line-signal?
            (λ (cls)
              (define clsv (change-line-signal-val cls))
              (or
               (and (exact-positive-integer? clsv)
                    (vector-member clsv line-vec))
               (error
                (format "error in line ~a: line ~a not found"
                        line-num clsv))))])
        (line-func) ; call the line func!
        (add1 line-idx))))) ; increment and return line index!
; now the handlers:
; if we get the end-program-signal, call and return void: this terminates execution
; if we get the change-line-signal:
;  if the line number isn't real, we throw the error
;  if the line number is real, the first condition of the OR fires:
;    that is, both conditions of the AND fire
;    and Racket returns the value of the LAST condition, assuming it isn't false:
;      that is, we return the next line index (which we looked up!)
;      since for/fold is waiting for the next value of line-idx,
;      this exception changes the line-idx to whatever it should be!


(define (b-rem val) (void)) ; void doesn't do anything! so when we see (b-rem ...), we just do nothing!
(define (b-print . vals) ; b-print could have an arbitrary number of values (hence the .)
  (displayln (string-append* (map ~a vals)))) ; map the values to strings (necessary if they're numbers)
(define (b-sum . vals) (apply + vals)) ; apply the + function to the values
(define (b-expr expr)
  (if (integer? expr) (inexact->exact expr) expr)) ; simple if: numbers become exact numbers
; otherwise, if expr is something like (b-sum 1 2 3), return expr will return the result of calling b-sum