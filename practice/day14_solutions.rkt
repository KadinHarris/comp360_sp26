#lang racket
;;; COMP 360 - Day 14 Practice Problems
;;; Review: Recursion, Tail Recursion, Scope, Lambdas, Closures, and Currying


;;; ============================================================
;;; PROBLEM 1: Recursion vs. Tail Recursion — Identification
;;; ============================================================

;;; For each function below, determine:
;;;   1. Is it tail-recursive? (YES or NO)
;;;   2. If NO, explain which operation prevents the recursive call
;;;      from being in tail position.

;;; Function A:
(define (count-evens lst)
  (cond
    [(null? lst) 0]
    [(even? (car lst)) (+ 1 (count-evens (cdr lst)))]
    [else (count-evens (cdr lst))]))

;;; Is count-evens tail-recursive?
;;; Answer: No
;;; Explanation: the second condition has the form (+ 1 (RECURSIVE ...)) -- not at the tail


;;; Function B:
(define (last-element lst)
  (if (null? (cdr lst))
      (car lst)
      (last-element (cdr lst))))

;;; Is last-element tail-recursive?
;;; Answer: Yes
;;; Explanation: All recursive calls have form (RECURSIVE ...) -- at the tail


;;; Function C:
(define (flatten-list lst)
  (cond
    [(null? lst) '()]
    [(list? (car lst))
     (append (flatten-list (car lst)) (flatten-list (cdr lst)))]
    [else (cons (car lst) (flatten-list (cdr lst)))]))

;;; Is flatten-list tail-recursive?
;;; Answer: No
;;; Explanation: Every recursive call occurs before the tail-call


;;; ============================================================
;;; PROBLEM 2: Converting to Tail Recursion
;;; ============================================================

;;; 2a: Convert this function to be tail-recursive.
;;; It computes the product of all numbers in a list.
;;; Hint: 1) define a local helper called "go" or "helper that takes in
;;;          some value (ex, the list) and some accumulator
;;;       2) the base case for the helper is the "final answer"
;;;       3) call the helper on the original list with the non-tail-recursive
;;;          base case as the initial value for the accumulator


(define (product-not-tr lst)
  (if (null? lst)
      1
      (* (car lst) (product-not-tr (cdr lst)))))

;;; Your tail-recursive version:
;;; Hint: What should the initial accumulator be?

(define (product lst) 
  (define (go nums acc)
    (if (null? nums)
        acc
        (go (cdr nums) (* acc (car nums)))))
  (go lst 1))

;;; Test cases (uncomment to test):
(product '())           ; => 1
(product '(2 3 4))      ; => 24
(product '(1 2 3 4 5))  ; => 120


;;; 2b: Convert this function to be tail-recursive.
;;; It computes the maximum value in a non-empty list.

(define (max-not-tr lst)
  (if (null? (cdr lst))
      (car lst)
      (max (car lst) (max-not-tr (cdr lst)))))

;;; Your tail-recursive version:
;;; Hint: What should the initial accumulator be?
;;;       (Think about what a good starting value is.)

(define (max-tr lst)
  (define (go nums acc)
    (if (null? nums)
        acc
        (if (> (car nums) acc)
            (go (cdr nums) (car nums))
            (go (cdr nums) acc))))
  (go lst (car lst)))

;;; Test cases (uncomment to test):
(max-tr '(3))           ; => 3
(max-tr '(1 5 2 8 3))   ; => 8
(max-tr '(-1 -5 -2))    ; => -1


;;; 2c: Convert this function to be tail-recursive.
;;; It builds a string by repeating a character n times.

(define (repeat-char-not-tr ch n)
  (if (= n 0)
      ""
      (string-append (string ch) (repeat-char-not-tr ch (- n 1)))))

;;; Your tail-recursive version:
;;; Hint: The accumulator is a string that you build up.

(define (repeat-char ch n)
  (define (go n acc)
    (if (zero? n)
        acc
        (go (- n 1) (string-append (string ch) acc))))
  (go n ""))

;;; Test cases (uncomment to test):
(repeat-char #\* 0)   ; => ""
(repeat-char #\* 5)   ; => "*****"
(repeat-char #\a 3)   ; => "aaa"


;;; ============================================================
;;; PROBLEM 3: Scope — Predict the Output
;;; ============================================================

;;; For each snippet, predict the result WITHOUT running the code.
;;; Then uncomment to verify.

;;; 3a: let vs. let*
(define x 10)

(let ([x 5]
      [y (+ x 1)])
  (+ x y))

;;; What does this evaluate to?
;;; Answer: 16
;;; Explanation (which x does (+ x 1) see in the let bindings?): the global one


;;; 3b: let* sequential binding
(set! x 10)

(let* ([x 5]
       [y (+ x 1)])
  (+ x y))

;;; What does this evaluate to?
;;; Answer: 11
;;; Explanation (how does let* differ from let here?): use the previously defined local x


;;; 3c: Nested let with shadowing
(define a 1)

(let ([a 2]
      [b a])
  (let ([a 3])
    (+ a b)))

;;; What does this evaluate to?
;;; Answer: 4
;;; Explanation (what value does b get? what value does the inner a have?): b = 1, inner_a = 3


;;; 3d: Function scope and closure
(define z 100)

(define (make-f)
  (define z 1)
  (lambda (x) (+ x z)))

(define f (make-f))

(f 10)

;;; What does (f 10) evaluate to?
;;; Answer: 11
;;; Explanation (which z does the lambda see — the global or local one?): the local one


;;; ============================================================
;;; PROBLEM 4: Lambda and Closures
;;; ============================================================

;;; 4a: Write a function (make-greeter name) that returns a
;;; zero-argument function. Each time the returned function is
;;; called, it returns a personalized greeting.
;;;
;;; Examples:
;;;   (define jace-greeter (make-greeter "Jace"))
;;;   (jace-greeter)  ; => "Hey there, Jace!"

(define (make-greeter name)
  (lambda () (string-append "Hello there, " name "!")))

;;; Test cases (uncomment to test):
(define jace-greeter (make-greeter "Jace"))
(jace-greeter)  ; => "Hey there, Jace!"
(define clod-greeter (make-greeter "Clod"))
(clod-greeter)  ; => "Hey there, Clod!"



;;; 4b: Write a function (make-accumulator initial) that returns
;;; a function. The returned function takes a number and adds it
;;; to a running total, returning the new total.
;;; use set! for mutation
;;;
;;; Examples:
;;;   (define acc (make-accumulator 0))
;;;   (acc 5)    ; => 5
;;;   (acc 10)   ; => 15
;;;   (acc -3)   ; => 12

(define (make-accumulator initial)
  (let ((value initial))
    (lambda (x)
      (set! value (+ value x))
      value)))

;;; Test cases (uncomment to test):
(define acc (make-accumulator 0))
(acc 5)     ; => 5
(acc 10)    ; => 15
(acc -3)    ; => 12
(define acc2 (make-accumulator 100))
(acc2 1)    ; => 101


;;; 4c: Closure tracing — predict the output.

(define (make-box initial)
  (let ([value initial])
    (define (get) value)
    (define (set new-val) (set! value new-val))
    (lambda (msg)
      (cond
        [(eq? msg 'get) (get)]
        [(eq? msg 'set) set]))))

(define box1 (make-box 42))
(define box2 (make-box 99))

(box1 'get)
((box2 'set) 0)
(box2 'get)
(box1 'get)

;;; What are the four results in order?
;;; (box1 'get)       => 42
;;; ((box2 'set) 0)   => (what's the return? what's the effect?) no return, but value = 0
;;; (box2 'get)       => 0
;;; (box1 'get)       => 42
;;; Explanation (do box1 and box2 share their value variable?): no!


;;; ============================================================
;;; PROBLEM 5: Lambda as Arguments
;;; ============================================================

;;; 5a: Without using any helper definitions, write a single
;;; expression using map and a lambda that takes a list of
;;; numbers and returns a list of strings like "x = 5".
;;;
;;; Example:
;;;   '(1 2 3)  =>  '("x = 1" "x = 2" "x = 3")
;;;
;;; Hint: (number->string n) converts a number to a string.
;;;       (string-append s1 s2 ...) concatenates strings.

(map (lambda (x) (string-append "x = " (number->string x))) '(1 2 3))    ; => '("x = 1" "x = 2" "x = 3")


;;; 5b: Use filter with a lambda to keep only the lists
;;; with more than 2 elements from this list of lists.
;;;
(define lsts '((1) (1 2 3) () (4 5) (6 7 8 9)))
;;; Expected: '((1 2 3) (6 7 8 9))

(filter (lambda (x) (> (length x) 2)) lsts)


;;; 5c: Use foldl with a lambda to count how many strings
;;; in a list have length greater than 3.
;;;
(define strs '("hi" "hello" "hey" "goodbye" "ok"))
;;; Expected: 2  (only "hello" and "goodbye")
;;;
;;; Hint: foldl takes (lambda (element accumulator) ...) base list

(foldl (lambda (element accumulator) (if (> (string-length element) 3)
                                         (+ 1 accumulator)
                                         accumulator))
       0 strs)


;;; ============================================================
;;; PROBLEM 6: Currying — Fill in the Blanks
;;; ============================================================

;;; For each task, replace 'todo with a curry or curryr expression.
;;; Do NOT use lambda.

;;; 6a: Add 100 to every number
(map (curry + 100) '(1 2 3))        ; => '(101 102 103)

;;; 6b: Check if each number is positive
(map (curryr > 0) '(-2 0 3 -1 5))  ; => '(#f #f #t #f #t)
;;; Hint: (positive? x) exists, but try using (curry < 0) or (curryr > 0).
;;;       Think carefully about which one is correct!

;;; 6c: Remove all empty strings from a list
(filter (negate (curry string=? "")) '("hello" "" "world" "" "!"))   ; => '("hello" "world" "!")
;;; Hint: (non-empty-string? s) is not built in.
;;;       Think about (curry string=? "") — does that KEEP or REMOVE empties?
;;;       You might need (compose not ...) or (negate ...).

;;; 6d: Divide every number by 2
(map (curryr / 2) '(10 20 30 40))  ; => '(5 10 15 20)
;;; Hint: (/ a b) divides a by b. Which argument do you fix — left or right?

;;; 6e: Build a list of greeting functions
;;; Each function should prepend a greeting to a name.
(define greeters (map (curry string-append) '("Hello, " "Hi, " "Hey, ")))
;;; Hint: Each greeter should be a function that takes a name string.
((first greeters) "Alice")   ; => "Hello, Alice"
((second greeters) "Bob")    ; => "Hi, Bob"


;;; ============================================================
;;; PROBLEM 7: Putting It All Together
;;; ============================================================

;;; 7a: Write a tail-recursive function (map-tr f lst) that
;;; behaves like the built-in map. It should apply f to each
;;; element of lst and return a new list.
;;;
;;; Built-in Map Behavior:
;;; create a new list by applying function f to every element in lst
;;;
;;; Hint: You'll need an accumulator for the result list.
;;;       Watch out — what order do elements end up in?
;;;       You may need to reverse at the end.

(define (map-tr f lst)
  (define (go a acc)
    (if (null? a)
        acc
        (go (cdr a) (cons (f (car a)) acc))))
  (reverse (go lst '())))

;;; Test cases (uncomment to test):
(map-tr add1 '(1 2 3))            ; => '(2 3 4)
(map-tr (curry * 2) '(1 2 3 4))   ; => '(2 4 6 8)
(map-tr string-upcase '("hi" "there"))  ; => '("HI" "THERE")


;;; 7b: Write a tail-recursive function (filter-tr pred lst)
;;; that behaves like the built-in filter.
;;;
;;; Built-in Filter Behavior:
;;; create a new list containing only the elements for which "pred"
;;; returns #t

(define (filter-tr pred lst)
  (define (go a acc)
    (if (null? a)
        acc
        (if (pred (car a))
            (go (cdr a) (cons (car a) acc))
            (go (cdr a) acc))))
  (reverse (go lst '())))
        

;;; Test cases (uncomment to test):
(filter-tr even? '(1 2 3 4 5 6))          ; => '(2 4 6)
(filter-tr (curryr > 3) '(1 5 2 8 3))     ; => '(5 8)
(filter-tr string? '(1 "a" 2 "b"))        ; => '("a" "b")


;;; 7c: Using closures, write a function (make-pipeline . funcs)
;;; that takes any number of single-argument functions and returns
;;; a new function that applies them in left-to-right order.
;;;
;;; Examples:
;;;   (define transform (make-pipeline add1 (curry * 2) number->string))
;;;   (transform 5)   ; => "12"
;;;   ;; Because: 5 -> add1 -> 6 -> (* 2) -> 12 -> number->string -> "12"
;;;
;;; Hint: Think about foldl.

(define (make-pipeline . funcs)
  (lambda (x) (foldl (lambda (element accumulator) (element accumulator)) x funcs)))

;;; Test cases (uncomment to test):
 (define transform (make-pipeline add1 (curry * 2) number->string))
 (transform 5)   ; => "12"
 (transform 0)   ; => "2"
 (define identity (make-pipeline))
 (identity 42)   ; => 42


;;; ============================================================
;;; CHALLENGE: Closures Enclosing Closures
;;; ============================================================

;;; What does the following code produce? Trace through it
;;; carefully, paying attention to what each closure captures.

 (define (make-adders ns)
   (map (lambda (n) (lambda (x) (+ n x))) ns))

 (define adders (make-adders '(1 2 3)))

 (map (lambda (f) (f 10)) adders)

;;; Predicted result: '(11 12 13)
;;; Explanation (what does each closure in the list capture?):
;;; adders will be: '(func1 func2 func3) where:
;;;   func1 will add 1 to x
;;;   func2 will add 2 to x
;;;   func3 will add 3 to x
;;; so mapping the adders will give:
;;;   '(11 12 13)
