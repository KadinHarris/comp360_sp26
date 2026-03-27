#lang racket
;;; COMP 360 - Day 26 Practice
;;; Lettify Tokenizer
;;;
;;; Your job: fill in the 7 rules in the lexer below.
;;; Each rule matches a pattern and produces a TYPED TOKEN
;;; that the parser will consume.
;;;
;;; This file runs without error as-is — the any-char rule
;;; at the bottom acts as a fallback. As you add rules above it,
;;; they will take priority (First Match principle).
;;;
;;;
;;; Quick Reference -- Lexer Patterns:
;;;
;;;   "abc"                   exact string match
;;;   (char-range "0" "9")    any character from 0 to 9
;;;   (char-set "+-*/")       any single character in the string
;;;   (union re ...)          matches if ANY sub-pattern matches
;;;   (concatenation re ...)  matches each sub-pattern in sequence
;;;   (repetition lo hi re)   matches re between lo and hi times
;;;   whitespace              space, tab, or newline
;;;
;;; Quick Reference -- Actions:
;;;
;;;   (token 'TYPE lexeme)    return a typed token
;;;   (next-token)            skip this match
;;;

;;; Match the following tokens:
;;;  1. Keywords: match "let" and return the bare lexeme (no token type)
;;;  2. Numbers: match 1+ digits and return a NUMBER token
;;;  3. Identifiers: match 1 letter followed by 0+ letters/digits, return an ID token
;;;  4. Operators: match +-*/ and return an OP token
;;;  5. Assignment: match = and return an ASSIGN token
;;;  6. Left Brackets: match [ and return an LBRACKET token
;;;  7. Right Brackets: match ] and return an RBRACKET token

(require brag/support)
(provide make-tokenizer)

(define (make-tokenizer port)
  (define (next-token)
    (define lettify-lexer
      (lexer
       ; your trigger / action-item pairs go here!
       [(union (char-set "ab") (char-set "cd")) lexeme]
       ; provided:
       [whitespace (next-token)] ; skip whitespace
       [any-char (next-token)]   ; ignore unrecognized characters
       [(eof) eof]))             ; end of file

    (lettify-lexer port))
  next-token)


;;; ============================================================
;;; REPL Testing (uncomment to test as you go)
;;; ============================================================

;;; After completing TODO 1:
; (apply-tokenizer-maker make-tokenizer "let")
; should show the bare string "let" (no token type)

;;; After completing TODOs 1-3:
; (apply-tokenizer-maker make-tokenizer "let x")
; should show "let", ID "x"

;;; After completing TODOs 1-5:
; (apply-tokenizer-maker make-tokenizer "let x = 5")
; should show "let", ID, ASSIGN, NUMBER

;;; After completing all TODOs:
; (apply-tokenizer-maker make-tokenizer "let y = [x + 3]")
; should show "let", ID, ASSIGN, LBRACKET, ID, OP, NUMBER, RBRACKET
