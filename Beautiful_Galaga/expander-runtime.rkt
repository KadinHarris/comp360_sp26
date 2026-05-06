#lang racket
(require 2htdp/image 2htdp/universe)
(provide (all-defined-out))

(define current-canvas (make-parameter (cons 400 400)))

(define (register-canvas! w h)
  (current-canvas (cons w h)))

(define (play-game! name)
  (big-bang (initial-world)
    [to-draw render-world]
    [on-tick tick-world]
    [on-key  handle-key]
    [on-release handle-release]))

(define entity-table (make-hash))

(define (register-entity! name)
  (hash-set! entity-table name (make-hash))
  name)

(define (set-entity-prop! name prop val)
  (hash-set! (hash-ref entity-table name) prop val))

(define (entity-prop name prop [default #f])
  (hash-ref (hash-ref entity-table name) prop default))

(define (all-entities) (hash-keys entity-table))

(define (render-entity name world scene)
  (define size  (entity-prop name 'size 10))
  (define color (entity-prop name 'color "black"))
  (define pic   (entity-prop name 'picture 'circle))
  (define state (hash-ref world name))
  (define shape
    (case pic
      [(circle) (circle size "solid" color)]
      [(square) (square (* 2 size) "solid" color)]
      [else     (circle size "solid" color)]))
  (place-image shape (hash-ref state 'x) (hash-ref state 'y) scene))

(define (render-world world)
  (define w (car (current-canvas)))
  (define h (cdr (current-canvas)))
  (for/fold ([scene (empty-scene w h)])
            ([name (in-list (all-entities))])
    (render-entity name world scene)))

(define (->color-string x)
  (cond [(string? x) x]
        [(symbol? x) (symbol->string x)]
        [else (format "~a" x)]))

(define (->picture-symbol x)
  (cond [(symbol? x) x]
        [(string? x) (string->symbol x)]
        [else (string->symbol (format "~a" x))]))

(define (initial-world)
  (define cx (quotient (car (current-canvas)) 2))
  (define cy (quotient (cdr (current-canvas)) 2))
  (for/hash ([name (in-list (all-entities))])
    (define v   (entity-prop name 'velocity (list 0 0)))
    (define pos (entity-prop name 'position (list cx cy)))
    (values name (hash 'x (car pos) 'y (cadr pos)
                       'vx (car v) 'vy (cadr v)
                       'dir #f))))

(define (tick-entity name state world)
  (define x  (hash-ref state 'x))
  (define y  (hash-ref state 'y))
  (define vx (hash-ref state 'vx))
  (define vy (hash-ref state 'vy))
  (define dir   (hash-ref state 'dir #f))
  (define speed (entity-prop name 'speed 5))
  (define size  (entity-prop name 'size 10))
  (define bounce? (entity-prop name 'bounce-off #f))
  (define w (car (current-canvas)))
  (define h (cdr (current-canvas)))
  (define-values (dx dy)
    (case dir
      [(left)  (values (- speed) 0)]
      [(right) (values speed 0)]
      [(up)    (values 0 (- speed))]
      [(down)  (values 0 speed)]
      [else    (values 0 0)]))
  (define nx (+ x vx dx))
  (define ny (+ y vy dy))
  (cond
  [bounce?
   (define wall-flip-x? (or (< nx size) (> nx (- w size))))
   (define wall-flip-y? (or (< ny size) (> ny (- h size))))
   (define collision-axis
     (for/or ([(other-name other-state) (in-hash world)]
              #:unless (eq? other-name name))
       (overlap-axis name nx ny other-name other-state)))
   (define new-vx (if (or wall-flip-x? (eq? collision-axis 'x)) (- vx) vx))
   (define new-vy (if (or wall-flip-y? (eq? collision-axis 'y)) (- vy) vy))
   (define final-x (clamp (+ x new-vx dx) size (- w size)))
   (define final-y (clamp (+ y new-vy dy) size (- h size)))
   (hash 'x final-x 'y final-y
         'vx new-vx 'vy new-vy 'dir dir)]
  [else
   (define final-x (clamp nx size (- w size)))
   (define final-y (clamp ny size (- h size)))
   (hash 'x final-x 'y final-y 'vx vx 'vy vy 'dir dir)]))

(define (overlap-axis name1 nx1 ny1 name2 state2)
  (define s1 (entity-prop name1 'size 10))
  (define s2 (entity-prop name2 'size 10))
  (define dx (abs (- nx1 (hash-ref state2 'x))))
  (define dy (abs (- ny1 (hash-ref state2 'y))))
  (define overlap-x (- (+ s1 s2) dx))
  (define overlap-y (- (+ s1 s2) dy))
  (cond
    [(or (<= overlap-x 0) (<= overlap-y 0)) #f]   ; not overlapping
    [(< overlap-x overlap-y) 'x]                   ; mostly side-on
    [else 'y]))                                    ; mostly top/bottom

(define (clamp v lo hi)
  (max lo (min v hi)))

(define (tick-world world)
  (for/hash ([(name state) (in-hash world)])
    (values name (tick-entity name state world))))

(define (handle-key world key)
  (for/hash ([(name state) (in-hash world)])
    (define bindings (entity-prop name 'controls #f))
    (define dir (and bindings (lookup-binding bindings key)))
    (values name (if dir (hash-set state 'dir dir) state))))

(define (handle-release world key)
  (for/hash ([(name state) (in-hash world)])
    (define bindings (entity-prop name 'controls #f))
    (define dir (and bindings (lookup-binding bindings key)))
    ;; only clear if the released key is the one currently driving us
    (values name
            (if (and dir (eq? dir (hash-ref state 'dir)))
                (hash-set state 'dir #f)
                state))))

(define (lookup-binding bindings key)
  ;; bindings is '(key1 dir1 key2 dir2 ...) — find key in odd positions
  (let loop ([b bindings])
    (cond
      [(null? b) #f]
      [(null? (cdr b)) #f]
      [(equal? (symbol->string (car b)) key) (cadr b)]
      [else (loop (cddr b))])))

(define (apply-direction state dir speed)
  (case dir
    [(left)  (hash-set state 'x (- (hash-ref state 'x) speed))]
    [(right) (hash-set state 'x (+ (hash-ref state 'x) speed))]
    [(up)    (hash-set state 'y (- (hash-ref state 'y) speed))]
    [(down)  (hash-set state 'y (+ (hash-ref state 'y) speed))]
    [else    state]))

(define (entities-overlap? name1 state1 name2 state2)
  (define s1 (entity-prop name1 'size 10))
  (define s2 (entity-prop name2 'size 10))
  (define dx (abs (- (hash-ref state1 'x) (hash-ref state2 'x))))
  (define dy (abs (- (hash-ref state1 'y) (hash-ref state2 'y))))
  (and (< dx (+ s1 s2)) (< dy (+ s1 s2))))

(define (run-game-rkt)
  (dynamic-require "game.rkt" #f))