#lang racket
;;; COMP 360 - Day 26 Practice
;;; MiniLet Tests
;;;
;;; Run this file to test your tokenizer and parser.
;;; Tests are organized by part — work through them in order.

(require brag/support 
         "tokenizer-solution.rkt"
         "parser-solution.rkt")

;;; Helper: tokenize a string and return the list of tokens
(define (tokenize str)
  (apply-tokenizer-maker make-tokenizer str))

;;; Helper: format a single token as TYPE(value)
(define (format-token t)
  (if (token-struct? t)
      (format "~a(~a)" (token-struct-type t) (token-struct-val t))
      (format "~s" t)))

;;; Helper: format a token list as a readable string
(define (show-tokens str)
  (string-append "  Produced: " (string-join (map format-token (tokenize str)) "  ")))

;;; Helper: extract just the token types from a token list
(define (token-types str)
  (map (λ (t) (if (token-struct? t) (token-struct-type t) t))
       (tokenize str)))

;;; Helper: pretty-print a parse tree with indentation
(define (pp-tree datum [indent 0])
  (define pad (make-string (* indent 2) #\space))
  (cond
    [(and (list? datum) (not (null? datum)))
     (define tag (car datum))
     (define children (cdr datum))
     ;; If all children are strings (leaf node), print on one line
     (if (andmap string? children)
         (format "~a(~a ~a)" pad tag (string-join children " "))
         (string-append
          (format "~a(~a" pad tag)
          (apply string-append
                 (for/list ([child children])
                   (string-append "\n" (pp-tree child (+ indent 1)))))
          ")"))]
    [else (format "~a~s" pad datum)]))

;;; Helper: parse a string and return the pretty-printed parse tree
(define (parse-string str)
  (string-append "  Produced:\n" (pp-tree (parse-to-datum (tokenize str)) 2)))


;;; ============================================================
;;; Part 1: Tokenizer Tests
;;; ============================================================

(displayln "=== Part 1: Tokenizer Tests ===\n")

;; Test 1.1: Keywords
(displayln "Test 1.1 — Keyword token:")
(displayln (show-tokens "let"))
(displayln "  Expected: \"let\" (bare lexeme, no token type)\n")

;; Test 1.2: Numbers
(displayln "Test 1.2 — Number token:")
(displayln (show-tokens "42"))
(displayln "  Expected: NUMBER(42)\n")

;; Test 1.3: Identifiers
(displayln "Test 1.3 — Identifier token:")
(displayln (show-tokens "myVar1"))
(displayln "  Expected: ID(myVar1)\n")

;; Test 1.4: Keyword vs Identifier
(displayln "Test 1.4 — \"let\" is bare lexeme, \"letter\" is ID:")
(displayln (show-tokens "let"))
(displayln "  Expected: \"let\" (bare lexeme)")
(displayln (show-tokens "letter"))
(displayln "  Expected: ID(letter)\n")

;; Test 1.5: Operators and assignment
(displayln "Test 1.5 — Operators and assignment:")
(displayln (show-tokens "+ - * / ="))
(displayln "  Expected: OP(+)  OP(-)  OP(*)  OP(/)  ASSIGN(=)\n")

;; Test 1.6: Brackets
(displayln "Test 1.6 — Brackets:")
(displayln (show-tokens "[ ]"))
(displayln "  Expected: LBRACKET([)  RBRACKET(])\n")

;; Test 1.7: Full statement
(displayln "Test 1.7 — Full statement: \"let x = 5\"")
(displayln (show-tokens "let x = 5"))
(displayln "  Expected: \"let\"  ID(x)  ASSIGN(=)  NUMBER(5)\n")

;; Test 1.8: Statement with brackets
(displayln "Test 1.8 — Bracket expression: \"let y = [x + 3]\"")
(displayln (show-tokens "let y = [x + 3]"))
(displayln "  Expected: \"let\"  ID(y)  ASSIGN(=)  LBRACKET([)  ID(x)  OP(+)  NUMBER(3)  RBRACKET(])\n")


;;; ============================================================
;;; Part 2: Parser Tests
;;; ============================================================

(displayln "=== Part 2: Parser Tests ===\n")

;; Test 2.1: Simple assignment
(displayln "Test 2.1 — Parse \"let x = 5\":")
(displayln (parse-string "let x = 5"))
(displayln "  Expected:\n    (program\n      (statement\n        \"let\"\n        \"x\"\n        \"=\"\n        (expr\n          (term 5))))\n")

;; Test 2.2: Variable reference
(displayln "Test 2.2 — Parse \"let y = x\":")
(displayln (parse-string "let y = x"))
(displayln "  Expected:\n    (program\n      (statement\n        \"let\"\n        \"y\"\n        \"=\"\n        (expr\n          (term x))))\n")

;; Test 2.3: Bracket expression (requires parser TODO!)
;; Uncomment after completing the parser TODO:
;
; (displayln "Test 2.3 — Parse \"let y = [x + 3]\":")
; (displayln (parse-string "let y = [x + 3]"))
; (displayln "  Expected:\n    (program\n      (statement\n        \"let\"\n        \"y\"\n        \"=\"\n        (expr\n          \"[\"\n          (expr\n            (term x))\n          \"+\"\n          (expr\n            (term 3))\n          \"]\")))\n")


;;; ============================================================
;;; Part 3: Integration Tests
;;; ============================================================

(displayln "=== Part 3: Integration Tests ===\n")

;; Test 3.1: Multi-line program
(displayln "Test 3.1 — Multi-line program:")
(displayln (parse-string "let x = 5 let y = x"))
(displayln "  Expected:\n    (program\n      (statement\n        \"let\"\n        \"x\"\n        \"=\"\n        (expr\n          (term 5)))\n      (statement\n        \"let\"\n        \"y\"\n        \"=\"\n        (expr\n          (term x))))\n")

;; Test 3.2: Nested brackets (requires parser TODO!)
(displayln "Test 3.2 — Nested brackets: \"let z = [[a + b] * c]\"")
(displayln (parse-string "let z = [[a + b] * c]"))
(displayln "  Expected:\n    (program\n      (statement\n        \"let\"\n        \"z\"\n        \"=\"\n        (expr\n          \"[\"\n          (expr\n            \"[\"\n            (expr\n              (term a))\n            \"+\"\n            (expr\n              (term b))\n            \"]\")\n          \"*\"\n          (expr\n            (term c))\n          \"]\")))\n")

;; Test 3.3: Full program (requires parser TODO!)
(displayln "Test 3.3 — Full program:")
(displayln (parse-string "let x = 10 let y = [x + 3] let z = [y * 2]"))
(displayln "  Expected:\n    (program\n      (statement\n        \"let\"\n        \"x\"\n        \"=\"\n        (expr\n          (term 10)))\n      (statement\n        \"let\"\n        \"y\"\n        \"=\"\n        (expr\n          \"[\"\n          (expr\n            (term x))\n          \"+\"\n          (expr\n            (term 3))\n          \"]\"))\n      (statement\n        \"let\"\n        \"z\"\n        \"=\"\n        (expr\n          \"[\"\n          (expr\n            (term y))\n          \"*\"\n          (expr\n            (term 2))\n          \"]\")))\n")


(displayln "=== Done! ===")
