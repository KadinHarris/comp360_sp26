#lang racket
(require brag/support
         br-parser-tools/lex
         (prefix-in : br-parser-tools/lex-sre))

(provide make-tokenizer)

(define-lex-abbrev ws
  (:or #\space #\tab #\newline #\return))

(define-lex-abbrev letter
  (:or (:/ "a" "z") (:/ "A" "Z")))

(define-lex-abbrev digit
  (:/ "0" "9"))

(define-lex-abbrev id-char
  (:or letter digit #\- #\? #\_))

(define galaga-lexer
  (lexer
   [(:+ ws) (galaga-lexer input-port)]
   [(:seq #\; (:* (:~ #\newline))) (galaga-lexer input-port)]

   ["{" (token 'LBRACE "{")]
   ["}" (token 'RBRACE "}")]
   ["[" (token 'LBRACKET "[")]
   ["]" (token 'RBRACKET "]")]
   ["(" (token 'LPARENTHESIS "(")]
   [")" (token 'RPARENTHESIS ")")]

   ["="  (token 'OP "=")]
   [":"  (token 'OP ":")]
   ["->" (token 'OP "->")]

   ["game"       (token 'GAME "game")]
   ["play"       (token 'PLAY "play")]
   ["entity"     (token 'ENTITY "entity")]
   ["canvas"     (token 'CANVAS "canvas")]
   ["size"       (token 'SIZE "size")]
   ["speed"      (token 'SPEED "speed")]
   ["color"      (token 'COLOR "color")]
   ["picture"    (token 'PICTURE "picture")]
   ["velocity"   (token 'VELOCITY "velocity")]
   ["controls"   (token 'CONTROLS "controls")]
   ["bounds"     (token 'BOUNDS "bounds")]
   ["bounce-off" (token 'BOUNCE-OFF "bounce-off")]
   ["die-on"     (token 'DIE-ON "die-on")]
   ["score-on"   (token 'SCORE-ON "score-on")]
   ["game-over"  (token 'GAME-OVER "game-over")]
   ["cpu"        (token 'CPU "cpu")]

   ["bool"  (token 'BOOL "bool")]
   ["true"  (token 'BOOL "true")]
   ["false" (token 'BOOL "false")]

   [(:seq (:+ digit) "x" (:+ digit))
    (token 'DIMENSION lexeme)]

   [(:seq (:? "-") (:+ digit))
    (token 'INTEGER (string->number lexeme))]

   [(:seq letter (:* id-char))
    (token 'ID lexeme)]

   [(eof) eof]

   [any-char
    (error 'make-tokenizer (format "Unexpected character: ~a" lexeme))]))

(define (make-tokenizer port)
  (define (next-token)
    (galaga-lexer port))
  next-token)