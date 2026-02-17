#lang racket
;;; ============================================================
;;; COMP 360 - Midterm Exam 1 - Early Release
;;; ============================================================
;;;
;;; Pledge:  On the day of the test, I did not reference any
;;;          materials or receive any assistance whatsoever.
;;; Pledged: 
;;;
;;; Instructions:
;;; - This early release version is subject to change!
;;; - You will take this exam in person on Monday 2/23.
;;; - You may use DrRacket to write and test your code.
;;; - You may NOT use the internet, notes, or other resources in class.
;;; - You MAY prepare for the exam however you like: AI, friends, notes, etc.
;;; - Test cases are provided — uncomment them to verify your work.
;;; - Replace every 'todo with your solution.
;;; - Read each problem carefully before writing code.


;;; ============================================================
;;; QUESTION 0: pre-test questions
;;; ============================================================ 

;;; --- 0a ---
;;; How did you prepare for the exam? How long did you spend?
;;; Be specific but brief.



;;; --- 0b ---
;;; If I correctly answer x questions, a fair grade is:
;;; 0 questions: ???
;;; 1 question:  ???
;;; 2 questions: ???
;;; 3 questions: ???
;;; 4 questions: ???
;;; 5 questions: ???
;;; 6 questions: ???



;;; --- 0c ---
;;; Please provide meaningful/actionable feedback for me.
;;; This will not affect your grade.
;;; Consider: lectures/practice, projects, difficulty/clarity,
;;; and especially accessibility.



;;; ============================================================
;;; QUESTION 1: count-satisfies
;;; ============================================================

;;; Write a recursive function (count-satisfies pred lst) that
;;; returns how many elements in lst satisfy the predicate pred.
;;;
;;; You may NOT use the built-in count, filter, or foldl/foldr.
;;;
;;; See tests for examples.

(define (count-satisfies pred lst)
  'todo)

;;; Test cases (uncomment to test):
; (count-satisfies even? '(1 2 3 4 5))          ; => 2
; (count-satisfies string? '(1 "a" 2 "b" 3))    ; => 2
; (count-satisfies even? '())                   ; => 0
; (count-satisfies positive? '(-3 -1 0 2 5))    ; => 2


;;; ============================================================
;;; QUESTION 2: Fix the Scoping Bugs
;;; ============================================================

;;; Each snippet below has a scoping bug. Fix the code so it
;;; produces the expected output. You may only change the let/let*
;;; form -- do not change the body expression or add new variables.

;;; --- 2a ---
;;; Expected result: 11
;;; Bug: the binding of y should see the NEW value of x, not the old one.

(define x 10)

(let ([x 5]
      [y (+ x 1)])
  (+ x y))


;;; --- 2b ---
;;; Expected result: "hello world"
;;; Bug: b should use the value of a defined in the same binding block.

(define a "goodbye")

(let ([a "hello"]
      [b (string-append a " world")])
  b)


;;; ============================================================
;;; QUESTION 3: Rewrite Using Curry/Curryr
;;; ============================================================

;;; For each expression below, rewrite it using curry or curryr
;;; so that it produces the same result. Do NOT use lambda.

(define nums '(1 2 3 4 5))

;;; 3a: Add 10 to every number
;;; Lambda-version: (map (lambda (x) (+ x 10)) nums)
;;; Expected:       '(11 12 13 14 15)

; (map 'todo nums)


;;; 3b: Raise every number to the 2nd power
;;; Original: (map (lambda (x) (expt x 2)) nums)
;;; Expected: '(1 4 9 16 25)
;;; Hint: (expt base power) — which argument are you fixing?

; (map 'todo nums)


;;; 3c: Keep only lists of exactly 5 elements
(define particles (list (list 1 2 3 4 5)
                        (list 10 10 0 0 60)
                        (list 4 4 4)
                        (list 4 4 4 4)
                        (list 100 100 10 10 20)))
;;; Lambda-version: (filter (lambda (p) (= (length p) 5) particles)
;;; Expected:       '((1 2 3 4 5) (10 10 0 0 60) (100 100 10 10 20))

; (filter 'todo nums)

;;; ============================================================
;;; QUESTION 4: Tail Recursion Conversion -- zip
;;; ============================================================

;;; 4a:
;;; Here is a non-tail-recursive function that interleaves
;;; two lists into a single list:
;;;
;;; Comment the code to show you understand what it's doing
;;; and how it's doing it.

(define (zip-not-tr lst1 lst2)
  (cond
    [(null? lst1) lst2]
    [(null? lst2) lst1]
    [else (cons (car lst1)
                (cons (car lst2)
                      (zip-not-tr (cdr lst1) (cdr lst2))))]))

;;; Examples:
;;;   (zip-not-tr '(1 2 3) '(a b c))     => '(1 a 2 b 3 c)
;;;   (zip-not-tr '(1 2) '(a b c d))     => '(1 a 2 b c d)
;;;   (zip-not-tr '() '(x y))            => '(x y)

;;; 4b:
;;; Convert zip to a tail-recursive version.
;;; Remember the methodology:
;;;   1. Create a helper with an accumulator
;;;   2. The old base case return value becomes the initial accumulator
;;;   3. Do the computation first, then make the recursive call last
;;;   4. Call the helper once with the accumulator as the original base case
;;;   5. You may need to reverse the accumulator at the end

(define (zip lst1 lst2)
  'todo)

;;; Test cases (uncomment to test):
; (zip '(1 2 3) '(a b c))     ; => '(1 a 2 b 3 c)
; (zip '(1 2) '(a b c d))     ; => '(1 a 2 b c d)
; (zip '() '(x y))            ; => '(x y)
; (zip '(1 2 3) '())          ; => '(1 2 3)


;;; ============================================================
;;; QUESTION 5: Closure — make-toggle
;;; ============================================================

;;; Write a function (make-toggle val1 val2) that returns a
;;; zero-argument function. Each time the returned function is
;;; called, it alternates between returning val1 and val2.
;;; The first call should return val1.
;;;
;;; Hint: You will need a mutable variable captured by the
;;; closure. Use set! to update it.
;;;
;;; Hint 2: How can you make sure the first call returns val1
;;; and not val2?
;;;
;;; Examples:
;;;   (define t (make-toggle "on" "off"))
;;;   (t)   ; => "on"
;;;   (t)   ; => "off"
;;;   (t)   ; => "on"
;;;   (t)   ; => "off"

(define (make-toggle val1 val2)
  'todo)

;;; Test cases (uncomment to test):
; (define t (make-toggle "on" "off"))
; (t)   ; => "on"
; (t)   ; => "off"
; (t)   ; => "on"
; (define t2 (make-toggle 0 1))
; (t2)  ; => 0
; (t2)  ; => 1
; (t)   ; => "off"  (t and t2 are independent)


;;; ============================================================
;;; QUESTION 6: Putting It All Together -- make-transformer
;;; ============================================================

;;; 6a: Write a function (make-transformer ops) where ops is a
;;; list of single-argument functions. It returns a NEW function
;;; that applies every function in ops to its argument, from
;;; left to right.
;;;
;;; Hint: You could use foldl or regular recursion or tail-recursion.
;;; You MUST use lambda(s).
;;;
;;; Examples:
;;;   (define t (make-transformer (list add1 add1 add1)))
;;;   (t 0)   ; => 3
;;;
;;;   (define t2 (make-transformer (list add1 (lambda (x) (* x 2)))))
;;;   (t2 5)  ; => 12   (because 5 -> 6 -> 12)

(define (make-transformer ops)
  'todo)

;;; Test cases (uncomment to test):
; (define t (make-transformer (list add1 add1 add1)))
; (t 0)    ; => 3
; (t 10)   ; => 13
;
; (define t2 (make-transformer (list add1 (lambda (x) (* x 2)))))
; (t2 5)   ; => 12
;
; (define empty-t (make-transformer '()))
; (empty-t 42)  ; => 42


;;; 6b: Now WITHOUT using lambda, use make-transformer and
;;; curry/curryr to build a function that takes a number and:
;;;   1. Adds 1
;;;   2. Multiplies by 10
;;;   3. Subtracts 5
;;;   4. Turns it into a string
;;;   5. Adds "Result: " to the front of the string
;;;
;;; So (my-transform 3) => "Result: 35"   because 3 -> 4 -> 40 -> 35 -> "35" -> "Result: 35"

; (define my-transform (make-transformer (list 'todo 'todo 'todo 'todo 'todo)))

;;; Test cases (uncomment to test):
; (my-transform 3)    ; => 35
; (my-transform 0)    ; => 5
; (my-transform 10)   ; => 105
