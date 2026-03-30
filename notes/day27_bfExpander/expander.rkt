#lang br/quicklang
(require racket/pretty)
; let's brainstorm functionality / implementation!!
; - 30,000 bytes
; - a pointer
; - pointer manipulation
; - byte manipulation
; - input reading
; - displaying a byte
; - command "dispatcher", which handles the parse tree
; - functions for the above functionality


; reminders:
; - #' is like ', except instead of a datum, what we get is actual syntax which
;   can be executed later
; - ALL-CAPS-VARS are "pattern variables"
; - ... indicate repeats


; expander stub: it does nothing but display the produced module datum
; your expander can look the same for now!
(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     'PARSE-TREE)) ; leave this ticked until we're ready to test!
(provide (rename-out [bf-module-begin #%module-begin]))

; implementation:
; - provide a bf-program handler
(define-macro (bf-program OP-OR-LOOP-ARG ...)
  #'(void OP-OR-LOOP-ARG ...))
(provide bf-program)

; - provide a bf-loop handler
(define-macro (bf-loop "[" OP-OR-LOOP-ARG ... "]")
  #'(until (zero? (current-byte)) ; when do we stop looping?
      OP-OR-LOOP-ARG ...))
(provide bf-loop)

; - provide a bf-op handler: bf-op has several cases
(define-macro-cases bf-op
  'todo) ; should handle all of the different (bf-op "?") cases
(provide bf-op)