#lang br/quicklang
(require 2htdp/image)

;;; HELPERS
(define pi 3.141592653589793) ; not provided in br/quicklang
;; Canvas constants
(define CANVAS-WIDTH 500)
(define CANVAS-HEIGHT 500)
(define BLANK-CANVAS (rectangle CANVAS-WIDTH CANVAS-HEIGHT "solid" "white"))
;; Turtle movement math
(define (next-x x angle dist) (+ x (* dist (cos angle))))
(define (next-y y angle dist) (+ y (* dist (sin angle))))
;; Draw a line between two points on an image
(define (draw-line x1 y1 x2 y2 color image)
  (add-line image x1 y1 x2 y2 color))
;; Replace element at index i in list lst with value v
(define (list-set lst i v)
  (if (= i 0)
      (cons v (cdr lst))
      (cons (car lst) (list-set (cdr lst) (- i 1) v))))
;; Read all Racket-readable tokens from a single line of text
(define (tokenize line)
  (let loop ([port (open-input-string line)] [acc '()])
    (define tok (read port))
    (if (eof-object? tok)
        (reverse acc)
        (loop port (cons tok acc)))))


;;; Part 1: Turtle State
;;;
;;; State = (list x y angle pen-down? color image)
;;;           idx: 0  1   2      3       4     5 

; 1.1: state accessors
; state-x, state-y, state-angle, state-pen?, state-color, state-image

; tests


; 1.2: state updaters
; set-x, set-y, set-angle, set-pen, set-color, set-image

; tests


; 1.3: initial-state
; turtle at canvas center, pointing up (angle = -(pi/2)), pen up, color "black"

; tests

;;; Part 2: Reading the Program

;; THE READER
;; read-syntax is called by Racket when a file beginning with #lang "project4.rkt" is opened.
;; Complete the two missing definitions below.
(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define filtered 'todo )   ; filter out blank lines and lines starting with ";"
  (displayln filtered)
  (define src-datums 'todo ) ; tokenize each filtered line, then flatten into one list
  (define module-datum
    `(module turtle-mod "project4.rkt"
       (handle-turtle-cmds ,@src-datums)))
  (datum->syntax #f module-datum))
(provide quote read-syntax)


;; THE EXPANDER
;; module-begin: calls handle-turtle-cmds, extracts the final image, displays it
(define-macro (turtle-module-begin EXPR)
  #'(#%module-begin
     (display (state-image EXPR))))
(provide (rename-out [turtle-module-begin #%module-begin]))


;;; Part 3: Command Dispatch

; 3.1: handle-cmd
; Dispatch on: number, FORWARD, BACK, RIGHT, LEFT, PENDOWN, PENUP
; Return the updated state for each case.

; tests


; 3.2: handle-turtle-cmds
; Use for/fold to process all tokens left to right, starting from initial-state.
; (This is the direct parallel to handle-args in the funstacker example.)

(define (handle-turtle-cmds . cmds) 'todo )
(provide handle-turtle-cmds)

; tests (write a .turtle file and run it!)


;;; Part 4: Extensions

; 4.1: COLOR
; Add a COLOR command. Decide how to handle color-name symbols in handle-cmd.

; 4.2: BACK and SETPOS

; 4.3: REPEAT (stretch goal)
; expand-repeats: list of tokens -> list of tokens with REPEAT...END blocks expanded

; (define (expand-repeats tokens) ...)


;;; Part 5: Your Logo Program
;;; Write your program in a separate .turtle file.

