#lang racket
(require 2htdp/image)
(require 2htdp/universe)

;; Replace element at index i in list lst with value v
(define (list-set lst i v)
  (if (= i 0)
      (cons v (cdr lst))
      (cons (car lst) (list-set (cdr lst) (- i 1) v))))

(define WIDTH 400)
(define HEIGHT 400)
(define -DELTA (- 10))
(define DELTA 10)
(struct posn (x y))

;          idx       0   1  2
;(define state (list 250 250 3))



; Getters for state
(define (state-x state)
  (car state))

(define (state-y state)
  (car (cdr state)))

(define (state-lives state)
  (cdr (cdr state)))

;Setters for state
;(define (set-posn state x y)
 ; (list-set state 0 (posn (x y))))


; Posn -> Image
; Create an image of a dot at the given position
(define (render state)
  (place-image (circle 5 "solid" "red")
               (posn-x state) (posn-y state)
               (empty-scene WIDTH HEIGHT)))

; Takes in the state of the game and moves the player position left by 10
(define (move-left s)
  (cond [(equal? (posn-x s) 0) (posn (posn-x s) (posn-y s))] ; return same posn
        [else (posn (- (posn-x  s) 10) (posn-y s))])) ; return posn with x - 10

; Takes in the state of the game and moves the player position right by 10
(define (move-right s)
  (cond [(equal? (posn-x s) WIDTH) (posn (posn-x s) (posn-y s))] ; return same posn
        [else (posn (+ (posn-x s) 10) (posn-y s))])) ; return pons with x + 10
  
;(define (show-lives s)
;  (state-lives s))

(define (change w a-key)
  (cond
    [(key=? a-key "left")  (move-left w)]
    [(key=? a-key "right") (move-right w)]
;    [(= (string-length a-key) 1) w] ; order-free checking
    ;[(key=? a-key "up")    (state-lives w -DELTA)]
;    [(key=? a-key "down")  (world-go w +DELTA)]
    [else w]))


(big-bang (posn 250 250)
;  [on-tick update] change enemy data automatically
  [on-key change] ; change user data based on input
  [to-draw render])