#lang brag

program: game-def play-def

game-def: game ID LBRACE game-item* RBRACE
play-def: play ID

game-item: entity-def | canvas-def | controls-def | bounds-def | prop

entity-def: entity ID LBRACE prop* RBRACE

canvas-def: canvas value
controls-def: controls value
bounds-def: bounds value

prop: size value | speed value | color value | picture value | velocity value | bounce-off value | die-on value
     | score-on value | game-over value | cpu value
     | ID value | ID OP value

value: ID | INTEGER | DIMENSION
     | bool ;treating bool as a value so `player? bool` from lexer works for now
     | LBRACE value* RBRACE | LBRACKET value* RBRACKET | LPARENTHESIS value* RPARENTHESIS



;reference \/

;(define (lex-string str)
 ; (define port (open-input-string str))
  ;(port-count-lines! port)
  ;(let loop ()
   ; (define tok (beautiful-game-lex port))
    ;(unless (eof-object? (srcloc-token-token tok))
     ; (displayln (srcloc-token-token tok))
      ;(loop))))

;(lex-string "game beautiful-galaga {
 ; entity player {
  ;  size 20x20
   ; player? bool
  ;}
;}
;play beautiful-galaga")