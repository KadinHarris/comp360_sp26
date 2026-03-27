#lang brag

program : statement*
statement : "let" ID ASSIGN expr
expr : term | LBRACKET expr OP expr RBRACKET
; or : term | LBRACKET expr RBRACKET | expr OP expr ; more flexible!
term : NUMBER | ID
