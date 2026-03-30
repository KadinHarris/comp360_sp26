#lang br/quicklang
(require "parser.rkt") ; we're going to use the parser

(define (read-syntax path port) ; classic read-syntax function
  ; instead of src-datums, we create a parse tree by parsing tokens
  (define parse-tree (parse path (make-tokenizer port))) ; the parse function CONSUMES a token-source
  (define module-datum `(module bf-mod "expander.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)

(require brag/support) ; supplies lexer and other helpers
(define (make-tokenizer port)
  (define (next-token)
    (define bf-lexer
      (lexer
       [(char-set "><-.,+[]") lexeme] ; a lexeme in our language is any of the command characters
       [any-char (next-token)])) ; otherwise, skip the character: is this naive approach sufficient in general?
    (bf-lexer port))  
  next-token)
