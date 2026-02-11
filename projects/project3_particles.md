# Project 3: Particle Systems

**COMP 360: Programming Languages**

---

## Expected Effort

This project is moderately challenging. I expect you to spend between 5 and 10 hours. If you can't complete the project within 10 hours, you should let yourself stop working.

Your effort now will pay off in the future.

---

## AI Assistance Disclosure

**You must disclose use of AI on this assignment.** If you opt to use AI for this project, I will ask to see your conversation history.

---

## Grading and Submission

This project is **due the week of Feb 23**. You can bring me your code anytime that week during my office hours. Grading should take no more than 10 minutes.

Your grade will be based on how much of the project you completed, how much time you spent, and how well you understand your own code.

My solutions will become available on Feb 27.

---

## Overview

In this project, you'll build a particle system simulator. Particle systems are used extensively in games and visual effects: explosions, fire, rain, snow, sparks, etc.

More importantly for us, particle systems are perfect for exploring **closures** and **tail recursion**:

- **Closures** let us create "particle factories" and "force generators" that encapsulate their configuration
- **Tail recursion** is essential for efficiently processing hundreds of particles per frame

By the end, you'll have a working particle simulator and a deeper understanding of functional programming.

---

## Getting Started

Open `project3.rkt`. You'll see:

```racket
#lang racket
(require 2htdp/image)
(require 2htdp/universe)  ; for animation
```

The `2htdp/universe` library provides `animate` and `big-bang` for creating animations. We'll use these to bring our particles to life.

A **particle** in our system will be represented as a list:
```racket
(list x y vx vy life)
```
Where:
- `x, y` — position
- `vx, vy` — velocity
- `life` — remaining lifetime (decreases each frame, particle "dies" at 0)

---

## Part 1: Particle Basics

### Problem 1.1: Particle Accessors

Write accessor functions for particles. These will make your code much more readable. Use `car`, `cadr`, `caddr`, etc.

```racket
(define test-particle (list 100 200 3 -5 60))

(particle-x test-particle)     ; => 100
(particle-y test-particle)     ; => 200
(particle-vx test-particle)    ; => 3
(particle-vy test-particle)    ; => -5
(particle-life test-particle)  ; => 60
```

### Problem 1.2: make-particle

Write a function `make-particle` that takes x, y, vx, vy, and life, and returns a particle.

```racket
(make-particle 50 100 2 -3 30)  ; => (list 50 100 2 -3 30)
```

### Problem 1.3: update-particle

Write a function `update-particle` that takes a particle and returns a new particle with:
- Position updated by velocity (`x' = x + vx`, `y' = y + vy`)
- Life decreased by 1

```racket
(update-particle (list 100 200 3 -5 60))  ; => (list 103 195 3 -5 59)
(update-particle (list 0 0 1 1 10))       ; => (list 1 1 1 1 9)
```

### Problem 1.4: particle-alive?

Write a predicate `particle-alive?` that returns `#t` if a particle's life is greater than 0.

```racket
(particle-alive? (list 0 0 0 0 5))   ; => #t
(particle-alive? (list 0 0 0 0 0))   ; => #f
(particle-alive? (list 0 0 0 0 -1))  ; => #f
```

### Problem 1.5: draw-particle

Write a function `draw-particle` that takes a particle and a background image, and draws a small circle at the particle's position. The circle's opacity should fade as life decreases (use the life value to determine alpha, the opacity).

```racket
(define bg (rectangle 400 400 "solid" "gray"))
(draw-particle (list 200 200 0 0 60) bg)  ; draws a bright particle
(draw-particle (list 200 200 0 0 10) bg)  ; draws a faded particle
```

*Hint:* Use `place-image` and create a circle with `(make-color 0 0 0 alpha)` where alpha is based on life. You probably want to scale and clamp the particle's `life` to the 0-255 range. You can arbirtarily decide what `life` value counts as "full opacity" (I chose `30` as "max opacity").

---

## Part 2: Closures — Factories and Forces

Now we'll use **closures** to create configurable particle spawners and force generators.

### What is a Closure?

A closure is a function that "remembers" values from the environment where it was created:

```racket
(define (make-adder n)
  (lambda (x) (+ x n)))  ; this lambda "closes over" n

(define add5 (make-adder 5))
(define add10 (make-adder 10))

(add5 3)   ; => 8  (remembers n=5)
(add10 3)  ; => 13 (remembers n=10)
```

### Problem 2.1: make-spawner

Write a function `make-spawner` that takes configuration parameters and returns a **function** that creates particles. The returned function should take no arguments and produce a new particle each time it's called.

```racket
(define (make-spawner x y v-min v-max life)
  ;; Returns a function that creates particles at (x, y)
  ;; with random x and y velocities between speed-min and speed-max
  ;; and the given lifetime
  ...)
```

The spawned particles should have:
- Position at `(x, y)`
- Random velocity components between `v-min` and `v-max`
- The specified `life`

```racket
(define fountain (make-spawner 200 300 1 5 60))
(fountain)  ; => a particle at (200, 300) with random velocity, life=60
(fountain)  ; => another particle (different random velocity)

(define explosion (make-spawner 100 100 5 15 30))
(explosion)  ; => fast-moving particle, shorter life
```

*Hint:* Use `(random min max)` to get a random number between `min` and `max`.

*Hint:* You can use a `lambda` with no arguments.

*Think about it:* What values does the returned lambda "close over"? This is a closure because the lambda captures `x`, `y`, `speed-min`, `speed-max`, and `life`.

### Problem 2.2: make-gravity

Write a function `make-gravity` that takes a strength value and returns a **force function**. A force function takes a particle and returns a new particle with modified velocity.

```racket
(define (make-gravity strength)
  ;; Returns a function that applies downward force to a particle
  ...)
```

```racket
(define earth-gravity (make-gravity 0.5))
(define moon-gravity (make-gravity 0.08))

(define p (list 100 100 0 0 60))
(earth-gravity p)  ; => (list 100 100 0 0.5 60)  ; vy increased, positive y is "down"
(moon-gravity p)   ; => (list 100 100 0 0.08 60) ; less increase
```

### Problem 2.3: make-wind

Write `make-wind` that takes horizontal and vertical wind strength and returns a force function.

```racket
(define gentle-breeze (make-wind 0.1 0))
(define updraft (make-wind 0 -0.3))

(define p1 (list 100 100 0 0 60))
(gentle-breeze p1)  ; => (list 100 100 0.1 0 60)
(updraft p1)        ; => (list 100 100 0 -0.3 60)
```

### Problem 2.4: make-friction

Write `make-friction` that takes a friction coefficient (0 to 1) and returns a force function that reduces velocity.

```racket
(define air-resistance (make-friction 0.98))
(define heavy-friction (make-friction 0.8))

(define p2 (list 100 100 10 10 60))
(air-resistance p2)   ; => (list 100 100 9.8 9.8 60)
(heavy-friction p2)   ; => (list 100 100 8 8 60)
```

### Problem 2.5: make-attractor

Write `make-attractor` that takes a position (ax, ay) and a strength, and returns a force function that pulls particles toward that point. For example, if the particle is to the left of the attractor, increase its `vx`, and decrease it if it's to the right, or leave it unchanged if they are equal.

```racket
(define (make-attractor ax ay strength)
  ;; Returns a function that accelerates particles toward (ax, ay)
  ...)
```

```racket
(define black-hole (make-attractor 200 200 0.1))

(define p3 (list 100 200 0 0 60))  ; to the left of attractor
(black-hole p3)  ; => particle with positive vx (pulled right)

(define p4 (list 200 100 0 0 60))  ; above attractor
(black-hole p4)  ; => particle with positive vy (pulled down)
```

*Additional Challenge:* Instead of directly modifying the vx and vy with the strength, calculate the direction from particle to attractor, normalize it (look this up), scale it, and add to velocity.

### Problem 2.6: compose-forces

Write a function that takes multiple force functions and returns a single force function that applies all of them.

```racket
(define (compose-forces . forces) ; ". args" means: take a variable number of arguments as a list called "forces"
  ;; Returns a function that applies all forces in sequence
  ...)
```

*Hint:* Use `foldr` or `foldl` to apply each force in sequence.

```racket
(define physics (compose-forces
                  (make-gravity 0.5)
                  (make-wind 0.1 0)
                  (make-friction 0.99)))

(define p (list 100 100 10 0 60))
(physics p)  ; applies gravity, then wind, then friction
```

---

## Part 3: Tail Recursion — Processing Particles

With potentially hundreds of particles, we need efficient list processing. All functions in this section **must be tail-recursive**.

### Why Tail Recursion Matters

Non-tail-recursive functions build up stack frames:
```racket
;; NOT tail-recursive — stack grows with list length
(define (sum lst)
  (if (null? lst) 0
      (+ (car lst) (sum (cdr lst)))))
```

Tail-recursive functions reuse the same stack frame:
```racket
;; Tail-recursive — constant stack space
(define (sum-tr lst)
  (define (helper lst acc) ; acc is an ACCumulator
    (if (null? lst) acc
        (helper (cdr lst) (+ (car lst) acc))))
  (helper lst 0))
```

For 1000 particles, the non-tail-recursive version needs 1000 stack frames. The tail-recursive version needs 1.

### Problem 3.1: update-all-particles (tail-recursive)

Write a **tail-recursive** function that takes a list of particles and returns a new list with all particles updated (using `update-particle`).

```racket
(define particles (list (list 0 0 1 1 10) (list 5 5 -1 2 20)))
(update-all-particles particles)
; => (list (list 1 1 1 1 9) (list 4 7 -1 2 19))
```

**Your function MUST be tail-recursive.** Use a helper with an accumulator.

*Note:* Your result may be in reverse order compared to the input. That's okay! (Why does this happen with tail recursion?)

### Problem 3.2: apply-force-to-all (tail-recursive)

Write a **tail-recursive** function that takes a force function and a list of particles, applying the force to each.

```racket
(define gravity (make-gravity 1))
(define particles (list (list 0 0 0 0 10) (list 5 5 0 0 20)))
(apply-force-to-all gravity particles)
; => particles with gravity applied to each
```

### Problem 3.3: filter-alive (tail-recursive)

Write a **tail-recursive** function that removes dead particles (life <= 0) from a list.

```racket
(define particles (list
  (list 0 0 0 0 5)   ; alive
  (list 1 1 0 0 0)   ; dead
  (list 2 2 0 0 -1)  ; dead
  (list 3 3 0 0 10))); alive
(filter-alive particles)
; => (list (list 0 0 0 0 5) (list 3 3 0 0 10))  ; or reversed
```

### Problem 3.4: draw-all-particles (tail-recursive)

Write a **tail-recursive** function that draws all particles onto a background.

```racket
(define bg (rectangle 400 400 "solid" "black"))
(draw-all-particles particles bg)
; => image with all particles drawn
```

*Hint:* The accumulator here is the image being built up.

---

## Part 4: The Simulation

Now let's put it all together!

### Problem 4.1: simulation-step

Write a function `simulation-step` that takes a simulation state and returns the next state. A simulation state is a list of particles.

Your function should:
1. Apply forces to all particles
2. Update all particles (move them)
3. Remove dead particles

```racket
(define (simulation-step particles forces)
  ;; forces is a combined force function (from compose-forces)
  ...)
```

### Problem 4.2: simulation-step-with-spawning

Extend your simulation to spawn new particles. The function takes an additional spawner function and a spawn-rate (how many particles to spawn per frame).

```racket
(define (simulation-step-with-spawning particles forces spawner spawn-rate)
  ...)
```

*Hint:* Create a helper to spawn `n` particles and cons them onto the particle list.

### Problem 4.3: run-simulation

Create a working animation using `big-bang` from `2htdp/universe`.

```racket
(define WIDTH 400)
(define HEIGHT 400)

(define my-spawner (make-spawner 200 350 2 8 60))
(define my-forces (compose-forces (make-gravity 0.3) (make-friction 0.99)))

(define (tick-handler particles)
  (simulation-step-with-spawning particles my-forces my-spawner 3))

(define (draw-handler particles)
  (draw-all-particles particles (rectangle WIDTH HEIGHT "solid" "black")))

(big-bang '()  ; initial state: no particles
  [on-tick tick-handler]
  [to-draw draw-handler])
```

Get a fountain working! Particles should spawn at the bottom, shoot upward, arc due to gravity, and fade out.

---

## Part 5: Your Particle Creation

Create your own particle scene! I expect you to implement at least one new *closure factory* (that is, `make-x`) and at least one new tail recursion function (that is, `do-y`, tail-recursively).

New Closure Ideas:
 - Repulsion from a point
 - Bounding boxes that particles bounce off (requires collision checking)
 - Sinusoidal force fields
 - Particles with their own gravity

New Tail Recursion ideas:
 -

Some ideas:

- **Fireworks:** Click to launch a rocket that explodes into many particles
- **Fire:** Particles that rise, fade from yellow to red, and shrink
- **Rain/Snow:** Particles that fall and accumulate or splash
- **Swarm:** Particles attracted to the mouse cursor
- **Galaxy:** Particles orbiting a central attractor
- **Magic spell:** Combine multiple emitters and forces for a cool effect

Your creation should demonstrate:
- **Closures:** Custom spawners and/or forces with meaningful configuration
- **Tail recursion:** Efficient processing (your simulation should handle 500+ particles smoothly)
- **Creativity:** Something visually interesting!

Use `big-bang` with `on-mouse` or `on-key` handlers if you want interactivity:

```racket
(big-bang initial-state
  [on-tick tick-handler]
  [to-draw draw-handler]
  [on-mouse mouse-handler]  ; (lambda (state x y event) ...)
  [on-key key-handler])     ; (lambda (state key) ...)
```

---

## Tips for Success

1. **Test each function independently.** Don't try to run the full simulation until your pieces work.

2. **Start with fewer particles.** Debug with 5-10 particles before scaling up.

3. **Print intermediate values.** Use `printf` to see what's happening if particles aren't behaving correctly.

4. **Check your tail recursion.** If the simulation slows down dramatically with more particles, you may have a non-tail-recursive function.

5. **Understand your closures.** Be able to explain what values each closure captures and why.

---

## Looking Ahead

The patterns you've learned here—functions that return functions, processing lists efficiently, managing state through function parameters—are foundational for building **interpreters**.

In Project 4, you'll build a domain-specific language. The closures you've written (spawners, forces) are essentially tiny interpreters: they take a configuration and return something that "executes" that configuration later. Keep this connection in mind!

---

## Resources

- [2htdp/universe documentation](https://docs.racket-lang.org/teachpack/2htdpuniverse.html) — for animation
- [2htdp/image documentation](https://docs.racket-lang.org/teachpack/2htdpimage.html) — for drawing
- [Particle system basics](https://en.wikipedia.org/wiki/Particle_system) — background reading
