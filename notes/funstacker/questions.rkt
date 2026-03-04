#lang br/quicklang

;;; 1. What was "wrong" with the stacker language?

;;; 2. Describe a more Racket-like reading of a stacker program.

;;; 3. How is funstacker's reader different than stacker's?

;;; 4. Figure out how to view the module funstacker's reader produces.

;;; 5. How is funstacker's expander different than stacker's?

;;; 6. Review what provide does in racket. What are we providing, and why?

;;; 7. Without reading the new handler, brainstorm how you would make it work.
;;;    Remember: we're avoiding mutation.

;;; 8. Read the new handler. Make note of functions/patterns you aren't
;;;    familiar with. How do they work?

;;; 9. What's similar to the old handler? How is it different?

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

;; 11. Can you implement some of the additional features we added to stacker?
;;     - subtraction / division
;;     - comments
;;     - a "dump" operation
;;     - a "swap" operation
;;     (see Day 18 practice for more details)

;; 12. Brainstorm how you would add VARIABLE ASSIGNMENT to this language:
;;     STORE X ; stores the top of the stack in a variable called X
;;     X ; pushes the variable X onto the stack
