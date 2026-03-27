#lang racket

(require brag/support)
(provide make-tokenizer)

;(define id-pattern
;  (let ((first-letter (union (char-range "a" "z") (char-range "A" "Z")))
;        (rest-letters-numbers (repetition 1 +inf.0 (union (char-range "a" "z")
;                                                          (char-range "A" "Z")
;                                                          (char-range "0" "9")))))
;    (concatenation first-letter rest-letters)))


(define (make-tokenizer port)
  (define (next-token)
    (define lettify-lexer
      (lexer
       ["let" lexeme]
       [(repetition 1 +inf.0 (char-range "0" "9")) (token 'NUMBER lexeme)]
       [(concatenation (union (char-range "a" "z") (char-range "A" "Z"))
                       (repetition 0 +inf.0 (union (char-range "a" "z")
                                                   (char-range "A" "Z")
                                                   (char-range "0" "9"))))
        (token 'ID lexeme)]
       [(char-set "+*-/") (token 'OP lexeme)]
       ["=" (token 'ASSIGN lexeme)]
       ["[" (token 'LBRACKET lexeme)]
       ["]" (token 'RBRACKET lexeme)]
       
       ; provided:
       [whitespace (next-token)] ; skip whitespace
       [any-char (next-token)]   ; ignore unrecognized characters
       [(eof) eof]))             ; end of file

    (lettify-lexer port))
  next-token)

