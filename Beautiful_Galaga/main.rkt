#lang br/quicklang
(require "first-lexer.rkt" "parser.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port beutiful-game-lex)))
  (define module-datum
    `(module bf-mod "expander.rkt"
       ,parse-tree))
  (datum->syntax #f module-datum))

(module+ reader
  (provide read-syntax))
