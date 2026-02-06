#lang racket
;;; COMP 360 - Day 10 Practice Problems
;;; Lexical Scope, Closures, and Environment Diagrams

;;; Key concepts:
;;; - Lexical scope: look where the function was DEFINED, not where it was CALLED
;;; - A closure = code + the environment when the function was defined
;;; - Rule 1: Every function definition creates a closure
;;; - Rule 2: Every function call creates a new frame
;;; - Rule 2a: Every let expression creates a new frame


;;; ============================================================
;;; PROBLEM 1: Predict the Output
;;; ============================================================

;;; For each snippet below, predict the value of z WITHOUT running
;;; the code. Then uncomment to verify.

;;; 1a:
(define x 10)
(define (f y) (+ x y))
(define z1 (let ((x 20)) (f 5)))

;;; What is z1?
;;; Answer:
;;; Explanation (which x does f use and why?):


;;; 1b:
(define a 1)
(define (g b) (+ a b))
(define (h a) (g a))
(define z2 (h 10))

;;; What is z2?
;;; Answer:
;;; Explanation:


;;; 1c:
(define m 5)
(define (p n) (lambda (q) (+ m n q)))
(define r (p 3))
(define z3 (let ((m 100)) (r 2)))

;;; What is z3?
;;; Answer: 
;;; Explanation:


;;; ============================================================
;;; PROBLEM 2: Free vs. Bound Variables
;;; ============================================================

;;; For each function below, identify ALL free variables and
;;; ALL bound variables in the function body.

;;; 2a:
; (define (func-a x y) (+ x y z))

;;; Bound variables in func-a's body:
;;; Free variables in func-a's body:

;;; 2b:
; (define (func-b x) (lambda (y) (+ x y z)))

;;; For the OUTER function (func-b):
;;;   Bound variables in func-b's body:
;;;   Free variables in func-b's body:

;;; For the INNER lambda:
;;;   Bound variables in the lambda's body:
;;;   Free variables in the lambda's body:


;;; 2c:
; (define (func-c f lst) (map f lst))

;;; Bound variables in func-c's body:
;;; Free variables in func-c's body:


;;; ============================================================
;;; PROBLEM 3: How Many Frames?
;;; ============================================================

;;; For each code snippet, determine how many NEW frames
;;; (not counting the global frame) are created during evaluation.

;;; 3a:
; (define x 1)
; (define (f y) (+ x y))
; (define z (f 5))

;;; Number of new frames:
;;; What creates each frame:


;;; 3b:
; (define x 1)
; (define (f y) (+ x y))
; (define z (let ((x 2)) (f (+ x 3))))

;;; Number of new frames:
;;; What creates each frame:


;;; 3c:
; (define (f g) (let ((x 3)) (g 2)))
; (define x 4)
; (define (h y) (+ x y))
; (define z (f h))

;;; Number of new frames:
;;; What creates each frame:


;;; ============================================================
;;; PROBLEM 4: Closures in Action
;;; ============================================================

;;; 4a: Write a function (make-multiplier n) that returns a function
;;; which multiplies its argument by n.

(define (make-multiplier n)
  'todo)

;;; Test cases (uncomment to test):
; (define times3 (make-multiplier 3))
; (times3 5)    ; => 15
; (times3 10)   ; => 30
; (define times7 (make-multiplier 7))
; (times7 4)    ; => 28


;;; 4b: Write a function (make-between lo hi) that returns a
;;; predicate (a function returning #t or #f) which checks if its
;;; argument is strictly between lo and hi.

(define (make-between lo hi)
  'todo)

;;; Test cases (uncomment to test):
; (define between-1-10 (make-between 1 10))
; (between-1-10 5)    ; => #t
; (between-1-10 1)    ; => #f
; (between-1-10 10)   ; => #f
; (between-1-10 15)   ; => #f


;;; ============================================================
;;; PROBLEM 5: Tracing Environment Diagrams
;;; ============================================================

;;; Trace through the following code step by step.
;;; For each step, describe what happens (binding, frame creation,
;;; closure creation, variable lookup).

; 1  (define a 2)
; 2  (define (f x) (lambda (y) (+ a x y)))
; 3  (define g (f 3))
; 4  (define a 10)    ; Racket allows redefinition at the top level
; 5  (define z (g 4))

;;; Step by step:
;;; Line 1:
;;; Line 2:
;;; Line 3 (what frame is created? what closure is returned?):
;;; Line 4:
;;; Line 5 (what frame is created? what is the result?):
;;;
;;; What is the value of z?
;;; Answer:
;;;
;;; TRICKY: Does line 4 affect the result? Why or why not?
;;; (Hint: think about what the closure's environment pointer
;;; points to, and what happens when a is looked up.)
;;; Answer:


;;; ============================================================
;;; PROBLEM 6: Higher-Order Functions with Closures
;;; ============================================================

;;; 6a: Write a function (apply-twice f) that returns a new function
;;; which applies f twice to its argument.

(define (apply-twice f)
  'todo)

;;; Test cases (uncomment to test):
; ((apply-twice add1) 5)                       ; => 7
; ((apply-twice (lambda (x) (* x x))) 3)       ; => 81


;;; 6b: Write a function (compose f g) that returns a new function
;;; which computes f(g(x)).

(define (compose f g)
  'todo)

;;; Test cases (uncomment to test):
; ((compose add1 add1) 5)                           ; => 7
; ((compose (lambda (x) (* x 2))
;           (lambda (x) (+ x 1))) 3)                ; => 8


;;; ============================================================
;;; ADDITIONAL CHALLENGE: Counter
;;; ============================================================

;;; Write a function (make-counter start) that returns a function.
;;; Each time the returned function is called (with no arguments),
;;; it returns the next number in sequence starting from start.
;;;
;;; This requires mutation (set!) which we haven't covered much,
;;; but it's a classic closure example. Try it if you're curious!

; (define (make-counter start)
;   'todo)

;;; Test cases (uncomment to test):
; (define c (make-counter 0))
; (c)   ; => 0
; (c)   ; => 1
; (c)   ; => 2
; (define d (make-counter 10))
; (d)   ; => 10
; (c)   ; => 3
