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
(define SPEED 5)
(define BLANK-CANVAS (rectangle WIDTH HEIGHT "solid" "white"))

(define projectiles (list))
(define enemies (list))

;                    x   y lives  speed image
(define state (list 250 250 3       10   BLANK-CANVAS  projectiles enemies))
;               idx  0   1  2       3         4             5         6


; Getters for state
(define (state-x state)
  (car state))

(define (state-y state)
  (car (cdr state)))

(define (state-lives state)
  (car (cdr (cdr state))))

(define (state-speed state)
  (car (cdr (cdr (cdr state)))))

(define (state-image state)
  (car (cdr (cdr (cdr (cdr state))))))

; returns the list of projectiles
(define (state-projectiles state)
  (car (cdr (cdr (cdr (cdr (cdr state)))))))

(define (state-projectile state)
  (car (state-projectiles state)))

; Setters for state
(define (set-x s val)
  (list-set s 0 val))

(define (set-y s val)
  (list-set s 1 val))

(define (set-lives s val)
  (list-set s 2 val))

(define (set-speed s val)
  (list-set s 3 val))

(define (set-image s val)
  (list-set s 4 val))




; Takes in the state of the game and moves the player position left by 10
(define (move-left s)
  (cond [(equal? (state-x s) 0) s] ; return same state
        [else (set-x s (- (state-x s) (state-speed s)))])) ; return state with x - speed

; Takes in the state of the game and moves the player position right by 10
(define (move-right s)
  (cond [(equal? (state-x s) WIDTH) s] ; return same pos
        [else (set-x s (+ (state-x s) (state-speed s)))])) ; return pons with x + speed

(define (move-up s)
  (cond [(equal? (state-y s) 0) s]
        [else (set-y s (- (state-y s) (state-speed s)))]))

(define (move-down s)
  (cond [(equal? (state-y s) HEIGHT) s]
        [else (set-y s (+ (state-y s) (state-speed s)))]))

; Places a projectile at the player position
(define (shoot s)
  (list-set s 5 (cons (cons (state-x s) (state-y s)) (state-projectiles s))))
  

;(define (update s)
 ;(display s))


; Create an image of a dot at the given position
(define (render state)
       (place-image
        (circle 5 "solid" "red")
                                (state-x state) (state-y state)
                                (place-image (circle 5 "solid" "blue")
                                             200 10
                                             (place-image (circle 2 "solid" "green")
                                                          200 200
                                                          (empty-scene WIDTH HEIGHT)))))
  

; CONTROLS
(define (change w a-key)
  (cond
    [(key=? a-key "left")  (move-left w)]
    [(key=? a-key "right") (move-right w)]
;    [(= (string-length a-key) 1) w] ; order-free checking
    [(key=? a-key "up")    (move-up w)]
    [(key=? a-key "down")  (move-down w)]
    [(key=? a-key " ") (shoot w)]
    [else w]))


; RUN GAME
(big-bang state
  ;[on-tick update] ;change enemy data automatically
  [on-key change] ; change user data based on input
  [to-draw render])