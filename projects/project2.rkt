#lang racket
(require 2htdp/image)
(require lang/posn)

;;; Provided Helpers:

;; draw-polygon: list of points (pairs), mode ("solid" or "outline"), color -> image
;; Draws a polygon using a list of (cons x y) points
(define (draw-polygon image points mode color)
  (add-polygon image (map (lambda (p) (make-posn (car p) (cdr p))) points)
               mode
               color))

;; Turtle Helpers
;; Constructor (provided)
(define (make-turtle x y angle) (list x y angle))

;; Accessors
(define (turtle-x t) (car t))
(define (turtle-y t) (cadr t))
(define (turtle-angle t) (caddr t))

;; Movement
(define (turtle-forward t distance)
  (make-turtle (+ (turtle-x t) (* distance (cos (turtle-angle t))))
               (+ (turtle-y t) (* distance (sin (turtle-angle t))))
               (turtle-angle t)))

(define (turtle-turn t angle)
  (make-turtle (turtle-x t)
               (turtle-y t)
               (+ (turtle-angle t) angle)))

(define (turtle-point t)
  (cons (car t) (cadr t)))

;;; Part 1:

; midpoint

; tests


; point-at-fraction

; tests


; rotate-point

; tests


; draw-line

; tests


;;; Part 2: Fractals

; sierpinski

; test


; Koch curve

; test


; Koch snowflake

; test


;;; Part 3: L-systems w/ Turtle Graphics

; apply-rule

; test


; l-system-step

; test


; l-system-generate

; test


; interpret-l-system

; test


; L-system Examples

; Sierpinski


; Plant


; Dragon


;;; Part 5: Come up with your own fractal!

;; Fatou Set: I used AI to give me a few steps,
;; including function definitions (but no code) to
;; get this working. I am happy to show you my prompts
;; if you are curious.

(define (escape-count f z max-iter)
  (define (go z acc)
    (if (or (> (magnitude z) 2) (>= acc max-iter))
        acc
        (go (f z) (+ 1 acc))))
  (go z 0))

(define c -0.5125+0.5213i)
(define z 0.5+0.2i)
(escape-count (lambda (z) (+ (* z z) c)) z 10)

;; function checked for correctness with AI
;; (coordinate mapping is hard! AI caught an
;;  error regarding the flipped y-axis for
;;  graphics)
(define (pixel->complex px py
                        width height
                        x-min x-max
                        y-min y-max)
  ;; Map pixel (px, py) to complex number
  ;; px=0 -> x-min, px=width -> x-max (similarly for y)]
  (let ((x (+ (* (/ px width) (- x-max x-min)) x-min))
        (y (- y-max (* (/ py height) (- y-max y-min)))))
    (+ x (* y +i))
    ))
(pixel->complex 20 70 100 100 -1.5 1.5 -1.5 1.5)

;; returns a color, darkened based on how many iterations it takes to "escape"
;; or another color if the point never escapes
(define (iteration->color n max-iter)
  (define (darker color-list by) ; recycling darker from Project 1
    (make-color (floor (* (car by) (car color-list))) ; R
                (floor (* (car (cdr by)) (car (cdr color-list)))) ; G
                (floor (* (car (cdr (cdr by))) (car (cdr (cdr color-list))))))) ; B
  (if (= n max-iter)
      (make-color 0 255 0)
      (let ((scale (expt (/ n max-iter) 0.3)))
        (darker '(0 0 255) (list scale scale scale)))))

(define (draw-fatou f max-iter width height)
  ;; for every pixel in width x height
  ;; calculate its complex coordinate
  ;; then compute its escape-count
  ;; then create its color
  ;; then color the pixel accordingly
  (define (make-image curr-y)
    (if (= curr-y height)
        (make-row 0 curr-y)
        (above (make-row 0 curr-y) (make-image (+ 1 curr-y)))
        ))
  (define (make-row x y)
    (let* ((z (pixel->complex x y width height -1.5 1.5 -1.5 1.5))
           (count (escape-count f z max-iter))
           (color (iteration->color count max-iter)))
      (if (= x width)
          (rectangle 1 1 "solid" color)
          (beside (rectangle 1 1 "solid" color) (make-row (+ x 1) y)))))
  (make-image 0))

(define (draw-fatou-tr f max-iter width height)
    (define (make-row x y acc)
      (if (>= x width)
          acc
          (let* ((z (pixel->complex x y width height -1.5 1.5 -1.5 1.5))
                 (count (escape-count f z max-iter))
                 (color (iteration->color count max-iter)))
            (make-row (+ x 1) y (beside acc (rectangle 1 1 "solid" color))))))

    (define (make-image curr-y acc)
      (if (>= curr-y height)
          acc
          (make-image (+ 1 curr-y) (above acc (make-row 0 curr-y empty-image)))))

    (make-image 0 empty-image))

;; To produce different images, either:
;; - modify the lambda expression
;; - increase/decrease the max-iter (2nd argument)
;; - increase/decrease the resolution (last 2 arguments)
;(draw-fatou (lambda (z) (+ (* z z) c)) 50 400 400)
(draw-fatou-tr (lambda (z) (+ (* z z) c)) 70 800 800) 
