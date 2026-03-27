#lang brag

;;; Lettify Grammar
;;;
;;; This grammar defines the structure of Lettify programs.
;;; It consumes TYPED TOKENS produced by the tokenizer.
;;;
;;; Token types used: ID, NUMBER, ASSIGN, OP, LBRACKET, RBRACKET
;;; Literal strings matched: "let"
;;;
;;; A program like:    let x = [y + 5]
;;; Is tokenized as:   "let" ID ASSIGN LBRACKET ID OP NUMBER RBRACKET
;;;
;;; Each UPPERCASE name matches a token type.
;;; Each lowercase name is a grammar rule (non-terminal).
;;;
;;; Your task:
;;; Extend the expr rule to include bracketed expressions like:
;;;   let x = [y + 5]
;;;   let x = [z + 1] * [a + b]


program : statement*
statement : "let" ID ASSIGN expr
expr : term ; fix this!
term : NUMBER | ID


;; HINTS
;; An expression is either:
;;   - a single term (number or variable)       e.g. 5, x
;;   - a bracketed expression [expr op expr]    e.g. [x + 3]