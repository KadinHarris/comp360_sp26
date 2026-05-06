#lang racket
(require 2htdp/image)
(require 2htdp/universe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BASIC UTIL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (list-set lst i v)
  (if (= i 0)
      (cons v (cdr lst))
      (cons (car lst) (list-set (cdr lst) (- i 1) v))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS / INITIAL STATE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define WIDTH 400)
(define HEIGHT 400)

(define PLAYER-SPEED 5)
(define projectile-speed 5)
(define enemy-speed 2)

(define BLANK-CANVAS (rectangle WIDTH HEIGHT "solid" "white"))

(define projectiles (list))
(define enemies (list (cons 200 10)))

(define SPAWN-X (/ WIDTH 2))
(define SPAWN-Y (- HEIGHT 10))

;; STATE LAYOUT
;; idx:     0    1    2      3        4             5         6
;;        [ x ,  y , lives , speed , projectiles , enemies , score ]

(define state
  (list SPAWN-X
        SPAWN-Y
        3
        PLAYER-SPEED
        projectiles
        enemies
        0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ACCESSORS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (player-x state) (car state))
(define (player-y state) (car (cdr state)))
(define (player-lives state) (car (cdr (cdr state))))
(define (player-speed state) (car (cdr (cdr (cdr state)))))

(define (state-projectiles state)
  (car (cdr (cdr (cdr (cdr state))))))

(define (state-projectile state)
  (car (state-projectiles state)))

(define (state-projectile-x projectile)
  (car projectile))

(define (state-projectile-y projectile)
  (car (cdr projectile)))

(define (state-enemies state)
  (car (cdr (cdr (cdr (cdr (cdr state)))))))

(define (state-score state)
  (car (cdr (cdr (cdr (cdr (cdr (cdr state))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SETTERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (set-player-x s val) (list-set s 0 val))
(define (set-player-y s val) (list-set s 1 val))
(define (set-lives s val) (list-set s 2 val))
(define (set-player-speed s val) (list-set s 3 val))
(define (set-projectiles s val) (list-set s 4 val))
(define (set-enemies s val) (list-set s 5 val))
(define (set-score s val) (list-set s 6 val))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MOVEMENT / CONTROLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (move-left s)
  (if (equal? (player-x s) 0)
      s
      (set-player-x s (- (player-x s) (player-speed s)))))

(define (move-right s)
  (if (equal? (player-x s) WIDTH)
      s
      (set-player-x s (+ (player-x s) (player-speed s)))))

(define (move-up s)
  (if (equal? (player-y s) 0)
      s
      (set-player-y s (- (player-y s) (player-speed s)))))

(define (move-down s)
  (if (equal? (player-y s) HEIGHT)
      s
      (set-player-y s (+ (player-y s) (player-speed s)))))

(define (shoot s)
  (list-set s 4
            (cons (cons (player-x s) (player-y s))
                  (state-projectiles s))))

(define (spawn-enemy s x y)
  (list-set s 5
            (cons (cons x y)
                  (state-enemies s))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COLLISION / BOUNDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (on-screen? pos)
  (not (or (> (cdr pos) HEIGHT)
           (< (cdr pos) 0))))

(define (collides? p e)
  (and (< (abs (- (car p) (car e))) 10)
       (< (abs (- (cdr p) (cdr e))) 5)))

(define (enemy-hit? enemy projectiles)
  (cond [(empty? projectiles) #f]
        [(collides? (car projectiles) enemy) #t]
        [else (enemy-hit? enemy (cdr projectiles))]))

(define (filter-enemies enemies projectiles)
  (filter (lambda (e) (not (enemy-hit? e projectiles))) enemies))

(define (filter-projectiles projectiles enemies)
  (filter (lambda (p) (not (enemy-hit? p enemies))) projectiles))

(define (player-hit? p-pos enemies)
  (cond [(empty? enemies) #f]
        [(collides? p-pos (car enemies)) #t]
        [else (player-hit? p-pos (cdr enemies))]))

(define (remove-player-hit-enemies enemies player-pos)
  (filter (lambda (e) (not (collides? player-pos e))) enemies))

(define (enemy-reached-bottom? enemies)
  (ormap (lambda (e) (>= (cdr e) HEIGHT)) enemies))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MOVEMENT UPDATES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (move-projectile projectile speed)
  (cons (car projectile)
        (- (cdr projectile) speed)))

(define (move-enemy enemy speed)
  (cons (car enemy)
        (+ (cdr enemy) speed)))

(define (update-proj projs)
  (filter on-screen?
          (map (lambda (p)
                 (move-projectile p projectile-speed))
               projs)))

(define (update-enemies enemies proj)
  (filter on-screen?
          (map (lambda (e)
                 (move-enemy e enemy-speed))
               enemies)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GAME OVER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (game-over? s)
  (or (<= (player-lives s) 0)
      (enemy-reached-bottom? (state-enemies s))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UPDATE LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (update s)

  (if (game-over? s)
      s
      (let* ([proj (update-proj (state-projectiles s))]
             [moved-enemies (update-enemies (state-enemies s) proj)]

             [after-projectile
              (filter-enemies moved-enemies proj)]

             [filtered-proj
              (filter-projectiles proj moved-enemies)]

             [projectile-kills
              (- (length moved-enemies)
                 (length after-projectile))]

             [filtered-enemies
              (filter on-screen? after-projectile)]

             [new-score
              (+ (state-score s) projectile-kills)]

             [player-pos (cons (player-x s) (player-y s))]

             [hit? (player-hit? player-pos filtered-enemies)]

             [new-lives
              (if hit?
                  (max 0 (sub1 (player-lives s)))
                  (player-lives s))]

             [enemies-after-player
              (remove-player-hit-enemies filtered-enemies player-pos)]

             [new-x (if hit? SPAWN-X (player-x s))]
             [new-y (if hit? SPAWN-Y (player-y s))]

             [new-state
              (list new-x
                    new-y
                    new-lives
                    (player-speed s)
                    filtered-proj
                    enemies-after-player
                    new-score)])

        (if (empty? enemies-after-player)
            (spawn-enemy new-state
                         (+ 5 (random (- WIDTH 5)))
                         (random (quotient HEIGHT 3)))
            new-state))))

(provide update)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RENDERING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (draw-player state image)
  (place-image (circle 5 "solid" "red")
               (player-x state)
               (player-y state)
               image))

(define (draw-projectiles projectiles image)
  (define (helper ps acc)
    (cond [(empty? ps) acc]
          [else
           (helper (cdr ps)
                   (place-image (circle 3 "solid" "green")
                                (car (car ps))
                                (cdr (car ps))
                                acc))]))
  (helper projectiles image))

(define (draw-enemies enemies image)
  (define (helper es acc)
    (cond [(empty? es) acc]
          [else
           (helper (cdr es)
                   (place-image (circle 5 "solid" "blue")
                                (car (car es))
                                (cdr (car es))
                                acc))]))
  (helper enemies image))

(define (render state)

  (define base-scene
    (draw-player state
                 (draw-projectiles (state-projectiles state)
                                   (draw-enemies (state-enemies state)
                                                 (empty-scene WIDTH HEIGHT)))))

  (if (game-over? state)
      (place-image
       (text (string-append "GAME OVER  Score: "
                            (number->string (state-score state)))
             30
             "red")
       (/ WIDTH 2)
       (/ HEIGHT 2)
       (empty-scene WIDTH HEIGHT))

      (place-image
       (text (string-append "Score: "
                            (number->string (state-score state)))
             18
             "black")
       60
       20
       (place-image
        (text (string-append "Lives: "
                             (number->string (player-lives state)))
              18
              "black")
        (- WIDTH 50)
        20
        base-scene))))

(provide render)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INPUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (change w a-key)
  (if (<= (player-lives w) 0)
      w
      (cond
        [(key=? a-key "left") (move-left w)]
        [(key=? a-key "right") (move-right w)]
        ;[(key=? a-key "up") (move-up w)]
        ;[(key=? a-key "down") (move-down w)]
        [(key=? a-key " ") (shoot w)]
        [else w])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define play
  (big-bang state
    [on-tick update]
    [on-key change]
    [to-draw render]))

(provide play)

(play)