#lang brag

program: game-def play-def

game-def: GAME ID LBRACE game-item* RBRACE
play-def: PLAY ID

game-item: entity-def | canvas-def | controls-def | bounds-def | prop

entity-def: ENTITY ID LBRACE prop* RBRACE

canvas-def: CANVAS value
controls-def: CONTROLS value
bounds-def: BOUNDS value

prop: SIZE value | SPEED value | COLOR value | PICTURE value | VELOCITY value | BOUNCE-OFF value | DIE-ON value
     | SCORE-ON value | GAME-OVER value | CPU value
     | ID value | ID OP value

value: ID | INTEGER | DIMENSION
     | BOOL ;treating bool as a value so `player? bool` from lexer works for now
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