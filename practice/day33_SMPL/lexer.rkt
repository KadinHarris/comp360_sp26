#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))
(define-lex-abbrev letters (:+ (char-set "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_")))

(define smpl-lexer
  (lexer-srcloc
   ["\n" (token 'NEWLINE lexeme)]
   [whitespace (token lexeme #:skip? #t)]
   [(from/stop-before "#" "\n") (token 'COMMENT lexeme #:skip? #t)]
   ["print" (token lexeme lexeme)]
   ["=" (token lexeme lexeme)]
   [";" (token lexeme lexeme)]
   ["(" (token lexeme lexeme)]
   [")" (token lexeme lexeme)]
   [(:or "+" "-") (token 'ADDOP lexeme)]
   [(:or "*" "/") (token 'MULOP lexeme)]
   [digits (token 'INTEGER (string->number lexeme))]
   [(:or (:seq (:? digits) "." digits)
         (:seq digits "."))
    (token 'DECIMAL (string->number lexeme))]
   [(:or (from/to "\"" "\"") (from/to "'" "'"))
    (token 'STRING
           (substring lexeme
                      1 (sub1 (string-length lexeme))))]
   [(:seq letters (:* (:or letters digits)))
    (token 'ID lexeme)]))

(provide smpl-lexer)
