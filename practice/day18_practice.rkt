#lang br/quicklang
;;; COMP 360 - Day 18 Practice
;;; Stacker: Reader, Expander, and Helpers
;;;
;;;
;;; ============================================================
;;; PROBLEM 1: Tracing the Reader
;;; ============================================================
;;;
;;; Consider this stacker program:
;;;
;;;   #lang reader "stacker.rkt"
;;;   10
;;;   20
;;;   +
;;;   2
;;;   *
;;;
;;; The reader calls (port->lines port) to get a list of strings,
;;; one per source line. The #lang line is NOT included.
;;;
;;; 1a: What does src-lines contain after (port->lines port)?
;;;     Write it as a Racket list literal.
;;; Answer: (list 10 20 + 2 *) ; src-lines
;;;
;;; 1b: After (format-datums '(handle ~a) src-lines), what does
;;;     src-datums contain? Write it as a list of s-expressions.
;;; Answer: (list '(handle) '(handle 10) '(handle 20) '(handle +) '(handle 2) '(handle *))
;;;  '('a 'b 'c)
;;; 1c: Write out the full module-datum that is produced.
;;; Answer: '(module stacker-mod "stacker.rkt"
;;;             (handle)
;;;             (handle 10)
;;;              etc)
;;;
;;; 1d: Trace the stack after EACH handle call. Fill in the table.
;;;
;;;     Call              Stack
;;;     (handle 10)       '(10)
;;;     (handle 20)       '(20 10)
;;;     (handle +)        '(30)
;;;     (handle 2)        '(2 30)
;;;     (handle *)        '(60)
;;;
;;; 1e: What does the program print when run?
;;; Answer: 60


;;; ============================================================
;;; PROBLEM 2: Tracing the Expander
;;; ============================================================
;;;
;;; The stacker-module-begin macro rewrites
;;;   (stacker-module-begin EXPR-1 EXPR-2 ... EXPR-N)
;;; into
;;;   (#%module-begin EXPR-1 EXPR-2 ... EXPR-N (display (first stack)))
;;;
;;; 2a: Fully expand (stacker-module-begin (handle 5) (handle 3) (handle +)).
;;;     Write the resulting s-expression.
;;; Answer: (#%module-begin (handle 5) (handle 3) (handle +) (display (first stack))
;;;
;;; 2b: Why does the macro display (first stack) rather than stack?
;;;     What would happen if you changed it to (display stack)?
;;; Answer:
;;;
;;; 2c: COMPILE time vs RUN time: does the expander run the handle expressions
;;;     during compile time or run time? 
;;; Answer:


;;; ============================================================
;;; PROBLEM 3: Comment Support -- Modify the Reader
;;; ============================================================
;;;
;;; Add support for line comments: any line whose first character
;;; is ; should be treated as a comment and ignored.
;;;
;;; 3a: What predicate detects a comment line?
;;;     (string-ref s 0) returns the first character of string s.
;;;     (char=? c1 c2) compares characters?

#\; ; a semi-colon character!

;;; Answer:
;;;
;;; 3b: Modify read-syntax to filter out comment lines as well.
;;;     Hint: modify src-lines!
;;;
;;; Test your modified language with comments!
;;;   ; push two numbers
;;;   10
;;;   20
;;;   ; add them together
;;;   +


;;; ============================================================
;;; PROBLEM 4: Changing the Expander
;;; ============================================================
;;;
;;; 4:  Modify the expander macro so that instead of just
;;;     displaying the top of the stack, it displays a nice
;;;     message: "Result: x"
;;;     Hint: you can use string-append


;;; ============================================================
;;; PROBLEM 5: Subtraction
;;; ============================================================
;;;
;;; Add support for subtraction (-).
;;;
;;; Unlike + and *, subtraction is NOT commutative. Order matters.
;;; In RPN (Reverse Polish Notation), "10 3 -" means 10 - 3 = 7.
;;;
;;; 5a: Which value do you pop first? Which second?
;;;     If b = first pop and a = second pop, is the result (- a b)
;;;     or (- b a) to get "10 - 3"?
;;; Answer:
;;;
;;; 5b: Add a subtraction case to handle and add - to the provide statement.
;;;
;;; Test your modified language with subtraction!
;;;   #lang reader "stacker.rkt"
;;;   10
;;;   3
;;;   -
;;;
;;; 5c: Now write a program to produce the result of 3 - 10.


;;; ============================================================
;;; PROBLEM 6: Division
;;; ============================================================
;;;
;;; Add support for division (/).
;;;
;;; 6a: Same ordering question: in "20 4 /", which value is
;;;     popped first? Write the correct expression using pop-stack!.
;;; Answer:
;;;
;;; 6b: Add a division case to handle and provide /.
;;;     Hint/challenge: instead of adding an entire
;;;     new branch in your cond, can you modify
;;;     the subtraction branch to handle division, too?
;;;     Recall: arg is an actual Racket function: +*-/
;;;
;;; Test your modified language with division!
;;;   #lang reader "stacker.rkt"
;;;   20
;;;   4
;;;   /
;;;
;;; 6d: What happens if you write:
;;;
;;;   20
;;;   0
;;;   /
;;;
;;;     Try it. What error does Racket give?
;;;     How might you guard against division by zero inside handle?
;;;     Just describe an approach.
;;; Answer:
;;;
;;;  6e: (Optional) Implement division-by-zero error handling.


;;; ============================================================
;;; PROBLEM 7: The dump Operator
;;; ============================================================
;;;
;;; Add a dump operator that:
;;;   1. Displays the current top of the stack
;;;   2. Clears the entire stack (sets it to '())
;;;
;;; This lets a stacker program print an intermediate result
;;; and start fresh. Example program:
;;;
;;;   #lang reader "stacker.rkt"
;;;   3
;;;   5
;;;   +
;;;   dump     ; prints 8, then clears the stack
;;;   10
;;;   2
;;;   *        ; computes 10 * 2 = 20; now on fresh stack
;;;            ; module-begin prints 20
;;;
;;; 7a: Define dump. The problem to solve is this: 
;;;     The handler needs to check: (equal? arg dump)
;;;     But also the handler needs to call: (dump)
;;;
;;; 7b: Add a case in handle: when arg is dump, display the first
;;;     element of the stack and then set! stack to '().
;;;
;;; 7c: Provide dump (expose it to other modules).
;;;
;;; Test your modified language on the above example!
;;;
;;; 7d: CONNECT TO THE EXPANDER: The module-begin macro calls
;;;     (display (first stack)) unconditionally at the end.
;;;     What happens if dump was the last operation and the stack
;;;     is now empty when the macro tries to display?
;;;     Try it. How would you fix this? 
;;; Answer:


;;; ============================================================
;;; CHALLENGE: The swap Operator
;;; ============================================================
;;;
;;; Add a swap operator that swaps the top two elements of the stack.
;;; If the stack is (a b ...) before swap, it is (b a ...) after.
;;;
;;; a: Define swap, add it to handle, and provide it.
;;;
;;; b: Trace through this program step by step.
;;;    What is the final output?
;;;
;;;   3
;;;   10
;;;   swap
;;;   -