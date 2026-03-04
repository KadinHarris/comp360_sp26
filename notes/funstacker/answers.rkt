#lang br/quicklang

;;; 1. What was "wrong" with the stacker language?
;;;    MUTATION!

;;; 2. Describe a more Racket-like reading of a stacker program.
;;;    (handle arg1 (handle arg2 (handle arg3))))
;;;    or (handle arg1 arg2 arg3)

;;; 3. How is funstacker's reader different than stacker's?
;;;    it produces a function like (handle arg1 arg2 arg3) in the module

;;; 4. Figure out how to view the module funstacker's reader produces.
;;;    add (displayln module-datum)

;;; 5. How is funstacker's expander different than stacker's?
;;;    it only takes in ONE expression: the (handle ...) expression
;;;    then we display the first value of that function's resulting list (the stack)

;;; 6. Review what provide does in racket. What are we providing, and why?
;;;    provide exposes functions from a module to other modules
;;;    we provide our custom function handle-args as well as + * since those
;;;    are defined by the language our reader/expander is written in
;;;    and have to be exposed as well

;;; 7. Without reading the new handler, brainstorm how you would make it work.
;;;    Remember: we're avoiding mutation.
;;;    fold?

;;; 8. Read the new handler. Make note of functions/patterns you aren't
;;;    familiar with. How do they work?
;;;    the . operator: denotes arbitrary number of following arguments as a list
;;;    for/fold: iterates over a list/sequence, folding into some accumulator
;;;              similar to foldr or foldl!
;;;    in-list: denotes a sequence, not necessary?
;;;    #:unless: a "guard" statement: skips iterations under a certain condition
;;;    drop: returns a list with some of the front elements missing

;;; 9. What's similar to the old handler? How is it different?
;;;    a lot of the cond code is very similar, but we aren't mutating
;;;    an externally defined stack: we're accumulating the stack in a
;;;    local accumulator

;; 10. Do you think you could convert this for/fold into a regular foldr or foldl
;;     expression?
;;     Hint: the answer is YES! (use foldl)
;;     Behavior: you want to FOLD a list of arguments, from LEFT to RIGHT, accumulating
;;               the arguments into a stack. The "cond" here would probably fit nicely
;;               in a lambda expression!
;;     Hint: (foldl (lambda (val acc) ???) init lst)
;;           val is an element of the list.
;;           What is lst? What is the initial "thing" you fold into? What is the acc?
;;     Hint: (filter (negate void?) lst) will filter out voids from the list
;;     Hint: Employ liberal use of "print debugging" with (displayln x)!
(define (handle-args . args)
  (foldl (lambda (arg stack)
           (cond [(number? arg) (cons arg stack)]
                 [(or (equal? * arg) (equal? + arg))
                  (define op-result
                    (arg (first stack) (second stack)))
                  (cons op-result (drop stack 2))]))
         '() (filter (negate void?) args)))

;; 11. Can you implement some of the additional features we added to stacker?
;;     - subtraction / division
;;     - comments
;;     - a "dump" operation
;;     - a "swap" operation
;;     (see Day 18 practice for more details)

;; 12. Brainstorm how you would add VARIABLE ASSIGNMENT to this language:
;;     STORE X ; stores the top of the stack in a variable called X
;;     X ; pushes the variable X onto the stack
