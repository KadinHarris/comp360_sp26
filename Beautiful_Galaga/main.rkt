#lang br/quicklang
(require "first-lexer.rkt" "parser.rkt" brag/support)

(define (make-tokenizer ip [path #f]) ; has an optional second argument, path
  (port-count-lines! ip)
  (lexer-file-path path) ; let's us tell the lexer where the source is, for source locations!
  (define (next-token) (beautiful-game-lex ip))
  next-token)

(provide make-tokenizer)


(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum
    `(module bf-mod "expander.rkt"
       ,parse-tree))
  (datum->syntax #f module-datum))


(provide read-syntax)
