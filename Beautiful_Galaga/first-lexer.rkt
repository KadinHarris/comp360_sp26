#lang br/quicklang
(require brag/support
         br-parser-tools/lex
         br-parser-tools/lex-sre)

;;;abbreviations

(define-lex-abbrev letter (:or (:/ "a" "z") (:/ "A" "Z")))
(define-lex-abbrev digit (:/ "0" "9"))

(define keywords
  '("game" "play" "entity" "canvas"
    "controls" "bounds" "size" "speed"
    "color" "picture" "velocity"
    "bounce-off" "die-on" "score-on" "game-over"
    "cpu" "bool"))

(define beautiful-game-lex
  (lexer
   ; skip whitespace
   [whitespace (token lexeme #:skip? #t)]

   [(:seq (:+ digit) "x" (:+ digit)) (token 'DIMENSION lexeme)]

   [(:seq (:? #\-) (:+ digit)) (token 'INTEGER (string->number lexeme))]

   ; handles keywords and id's
   [(:seq letter (:* (:or letter digit #\- #\?)))
     (if (member lexeme keywords)
         (token (string->symbol lexeme) lexeme)
         (token 'ID lexeme))]

   ["=" (token 'OP lexeme)]
   ["{" (token 'LBRACE lexeme)]
   ["}" (token 'RBRACE lexeme)]
   ["[" (token 'LBRACKET lexeme)]
   ["]" (token 'RBRACKET lexeme)]
   ["(" (token 'LPARENTHESIS lexeme)]
   [")" (token 'RPARENTHESIS lexeme)]
   )
  )

(provide beautiful-game-lex)



;(define (lex-string str)
;  (define port (open-input-string str))
;  (port-count-lines! port)
;  (let loop ()
;    (define tok (beautiful-game-lex port))
;    (cond
;      [(eof-object? tok) (void)]
;      [else
;       (displayln tok)
;       (loop)])))

;(lex-string "game beautiful-galaga {
;  entity player {
;    size 20x20
;    player? bool
;  }
;}
;play beautiful-galaga")
