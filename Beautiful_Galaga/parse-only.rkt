#lang racket

(require "first-lexer.rkt"
         "parser.rkt")

(define input
  #<<END
game beautiful-galaga {
  canvas 800x600

  entity player {
    size 10x10
    speed 10
    controls [A D]
  }

  entity enemy {
    size 8x8
    speed 5
    cpu true
  }
}

play beautiful-galaga
END
)

(define port (open-input-string input))

(define (next-token)
  (beautiful-game-lex port))

(define parse-tree
  (parse "parse-only-test" next-token))

(displayln (syntax->datum parse-tree))