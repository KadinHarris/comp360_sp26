#lang brag

program: game-def play-def

game-def: /GAME ID /LBRACE game-item* /RBRACE
play-def: /PLAY ID

game-item: entity-def
         | canvas-def

entity-def: /ENTITY ID /LBRACE entity-prop* /RBRACE

canvas-def: /CANVAS DIMENSION

entity-prop: size-def | speed-def | color-def | picture-def | velocity-def  | controls-def | bounds-def
           | bounce-off-def | die-on-def | score-on-def  | game-over-def | cpu-def | custom-prop


size-def: /SIZE value
speed-def: /SPEED value
color-def: /COLOR value
picture-def: /PICTURE value
velocity-def: /VELOCITY value

controls-def: /CONTROLS control-list
bounds-def: /BOUNDS value
bounce-off-def: /BOUNCE-OFF value

die-on-def: /DIE-ON value
score-on-def: /SCORE-ON value
game-over-def: /GAME-OVER value
cpu-def: /CPU value
custom-prop: ID value | ID OP value

control-list: /LBRACKET @control-key* /RBRACKET

control-key: ID | BOOL | INTEGER

value: ID | INTEGER | DIMENSION | BOOL
     | /LBRACE @value* /RBRACE | /LBRACKET @value* /RBRACKET | /LPARENTHESIS @value* /RPARENTHESIS