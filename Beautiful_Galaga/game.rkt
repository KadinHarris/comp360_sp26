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
(define projectile-speed 5)
(define enemy-speed 2)

(define projectiles (list))
(define enemies (list (cons 200 10)))

;                    x   y lives  speed 
(define state (list 250 250 3       10  projectiles enemies))
;               idx  0   1  2       3         4        5         


; PLAYER ACCESSORS
(define (player-x state)
  (car state))

(define (player-y state)
  (car (cdr state)))

(define (player-lives state)
  (car (cdr (cdr state))))

(define (player-speed state)
  (car (cdr (cdr (cdr state)))))

; PROJECTILE ACCESSORS
(define (state-projectiles state)
  (car (cdr (cdr (cdr (cdr state))))))

(define (state-projectile state)
         (car (state-projectiles state)))

(define (state-projectile-x projectile)
  (car projectile))

(define (state-projectile-y projectile)
  (car (cdr projectile)))


; ENEMY ACCESSORS
(define (state-enemies state)
  (car (cdr (cdr (cdr (cdr (cdr state)))))))

; PLAYER SETTERS 
(define (set-player-x s val)
  (list-set s 0 val))

(define (set-player-y s val)
  (list-set s 1 val))

(define (set-lives s val)
  (list-set s 2 val))

(define (set-player-speed s val)
  (list-set s 3 val))

; PROJECTILE SETTERS
(define (set-projectiles s val)
  (list-set s 4 val))

; ENEMY SETTERS
(define (set-enemies s val)
  (list-set s 5 val))

;
;
; CONTROLS
; Takes in the state of the game and moves the player position left by 10
(define (move-left s)
  (cond [(equal? (player-x s) 0) s] ; return same state
        [else (set-player-x s (- (player-x s) (player-speed s)))])) ; return state with x - speed

; Takes in the state of the game and moves the player position right by 10
(define (move-right s)
  (cond [(equal? (player-x s) WIDTH) s] ; return same pos
        [else (set-player-x s (+ (player-x s) (player-speed s)))])) ; return pons with x + speed

(define (move-up s)
  (cond [(equal? (player-y s) 0) s]
        [else (set-player-y s (- (player-y s) (player-speed s)))]))

(define (move-down s)
  (cond [(equal? (player-y s) HEIGHT) s]
        [else (set-player-y s (+ (player-y s) (player-speed s)))]))

; Places a projectile at the player position
(define (shoot s)
  (list-set s 4 (cons (cons (player-x s) (player-y s)) (state-projectiles s)))) ; cons a new position to the projectiles list

(define (spawn-enemy s x y)
  (list-set s 5 (cons (cons x y) (state-enemies s))))


; DRAWING 
; Takes in the current state and an image to draw onto
(define (draw-player state image)
  (place-image (circle 5 "solid" "red")
               (player-x state) (player-y state)
               image))

; Recursively travels the list of projectiles in state and accumulates an image based on projectile positions
(define (draw-projectiles projectiles image)
  (define (helper projectiles acc)
    (cond [(empty? projectiles) acc]
          [else (helper (cdr projectiles) (place-image (circle 3 "solid" "green")
                                                       (car (car projectiles)) (cdr (car projectiles))
                                                       acc))]))
  (helper projectiles image))

; Recursively travels the list of enemies in state and accumulates an image based on projectile positions
(define (draw-enemies enemies image)
  (define (helper enemies acc)
    (cond [(empty? enemies) acc]
          [else (helper (cdr enemies) (place-image (circle 5 "solid" "blue")
                                                       (car (car enemies)) (cdr (car enemies))
                                                       acc))]))
  (helper enemies image))

; moves one projectile's y up by 5
(define (move-projectile projectile projectile-speed)
  (cons (car projectile) (- (cdr projectile) projectile-speed)))

; moves an enemy's y down by 5
(define (move-enemy enemy enemy-speed)
  (cons (car enemy) (+ (cdr enemy) enemy-speed)))
  

(define (update s)
 (let* ([s1 (set-projectiles s (map (lambda (item) (move-projectile item projectile-speed)) (state-projectiles s)))]
        [s2 (set-enemies s1 (map (lambda (item) (move-enemy item enemy-speed)) (state-enemies s)))])
   s2))


; Create an image of a dot at the given position
(define (render state)
  ; access the player position from state, draw it
  ; access the projectiles list from state, draw them all (recursively?)
  ; (draw-player (draw-projectiles (draw-enemies background)))
       (draw-player state (draw-projectiles (state-projectiles state)
                                             (draw-enemies (state-enemies state) (empty-scene WIDTH HEIGHT)))))
  

; CONTROLS
(define (change w a-key)
  (cond
    [(key=? a-key "left")  (move-left w)]
    [(key=? a-key "right") (move-right w)]
;    [(= (string-length a-key) 1) w] ; order-free checking
    [(key=? a-key "up")    (move-up w)]
    [(key=? a-key "down")  (move-down w)]
    [(key=? a-key " ") (shoot w)]
    [(key=? a-key "s") (spawn-enemy w 200 30)]
    [else w]))


; RUN GAME
(big-bang state
  [on-tick update] ;change enemy data automatically
  [on-key change] ; change user data based on input
  [to-draw render])