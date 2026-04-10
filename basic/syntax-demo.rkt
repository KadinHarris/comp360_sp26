#lang br/quicklang
;; Datum: just a list of symbols/numbers
'DATUM
(define d '(+ 1 x))
(displayln d)              ;=> (+ 1 x)
(syntax? d)                ;=> #f
(car d)                    ;=> '+    (a symbol)

;; Syntax object from a template
'SYNTAX
(define s #'(+ 1 x))
(displayln s)              ;=> #<syntax:...:line:9:12 (+ 1 x)>
(syntax? s)                ;=> #t
(syntax-source s)          ;=> "syntax-demo.rkt"
(syntax-line s)            ;=> 9
(syntax->datum s)          ;=> '(+ 1 x)   <- strips context to get the datum
(car (syntax-e s))         ;=> #<syntax:...:line:9:13 +>
(syntax->datum (car (syntax-e s)))
;(eval s)                   ;=> error, x not defined
; be VERY careful with eval!
; better yet, just don't use it!

'PATTERNS
(define-macro (m3 MID ... LAST) ; what is MID? what is LAST?
  (with-pattern ([(ONE TWO THREE) (syntax LAST)] ; defines a new PATTERN (ONE TWO THREE) (a group of 3!)
                                                 ; #' is the shortcut for (syntax ...)
                 [(ARG ...) #'(MID ...)])        ; redefines (MID ...) as (ARG ...)
    #'(list ARG ... THREE TWO ONE)))             ; what is ARG ... now? What is THREE? TWO? ONE?

(m3 25 42 ("foo" "bar" "zam")) ; '(25 42 "zam" "bar" "foo")

(define-macro (swap-around FIRST (A B) MIDDLE ... (X Y) LAST) ; what will these patterns be?
  (with-pattern ([(THING ...) #'(MIDDLE ...)
                  ])                ; what will (THING ...) become?
    #'(list LAST Y X THING ... B A FIRST)))                   ; what will the result be?

(swap-around 1 (2 3) 4 5 6 (7 8) 9) ; produces a SYNTAX OBJECT
