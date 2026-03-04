# Project 4: Rhogo -- A Turtle Graphics Language

**COMP 360: Programming Languages**

---

## Expected Effort

This project is moderate in difficulty. I expect you to spend between 5 and 10 hours. If you can't complete the project within 10 hours, let yourself stop working.

---

## AI Assistance Disclosure

**You must disclose use of AI on this assignment.** If you opt to use AI for this project, I will ask to see your conversation history.

---

## Grading and Submission

This project is **due the week of March 16**. You can bring me your code anytime that week during my office hours. Grading should take no more than 15 minutes.

Your grade will be based on how much of the project you completed, how much time you spent, and how well you understand your own code.

My solutions will become available on March 20.

---

## Background: Logo and Turtle Graphics

In 1967, Seymour Papert, Wally Feurzeig, and Cynthia Solomon developed a programming language called **Logo**. Papert, a mathematician who had studied under Jean Piaget, wanted a language where children could easily feel and imagine what their programs would do.

Logo's most famous feature is **turtle graphics**. Imagine a turtle sitting on a large sheet of paper, holding a pen (in its mouth or with its tail or coming out of its belly). You give it commands — *move forward 100 steps*, *turn right 90 degrees*, *lift the pen* — and it draws a picture as it moves.

Papert's 1980 book *Mindstorms: Children, Computers, and Powerful Ideas* pushed computational thinking into elementary, middle, and high schools, using Logo and turtle graphics.

We'll make a *Logo-like dialect*, our own lanuage based off Logo. Let's call our dialect **Rhogo**. Here is a Rhogo program that draws a square:

```
; square.turtle
#lang "project4.rkt"
PENDOWN
FORWARD 100
RIGHT 90
FORWARD 100
RIGHT 90
FORWARD 100
RIGHT 90
FORWARD 100
```

And one that draws a five-pointed star (notice the syntax `REPEAT`; can you infer the semantics?):

```
; star.turtle
#lang "project4.rkt"
PENDOWN
REPEAT 5
  FORWARD 120
  RIGHT 144
END
```

You will implement a Rhogo interpreter in Racket.

---

## Overview

Recall the `funstacker` example from class. Its core is a stack machine driven by `for/fold` or `foldl`:

```racket
(define (handle-args . args)
  (for/fold ([stack-acc empty])
            ([arg (in-list args)]
             #:unless (void? arg))
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result (arg (first stack-acc) (second stack-acc)))
       (cons op-result (drop stack-acc 2))])))
```

**See `funstacker/answers.rkt` for a `foldl` implementation of the above code!**

Numbers push onto the stack. Operators pop values, compute a result, and push it back. The accumulator is the stack itself.

Rhogo works the same way: instead of a number stack, the accumulator is the **turtle state**: position, heading, pen status, drawing color, and the image being built up.

The key difference is that each Rhogo line (e.g. `FORWARD 100`, `PENDOWN`) becomes a **list** — a small s-expression. `handle-turtle-cmds` folds over those lists, and `handle-cmd` dispatches on the first element of each list.

Summary:

| Funstacker | Rhogo |
|---|---|
| Each item is a **single token** (number or operator) | Each item is a **command list** like `'(FORWARD 100)` or `'(PENDOWN)` |
| An **operator** (`+`, `*`) pops two values, computes | A **command** (`FORWARD`, `RIGHT`) reads its argument(s) from the same list |
| Accumulator: a stack | Accumulator: a turtle |

Your `handle-turtle-cmds` will look nearly identical to `handle-args`.

---

## Getting Started

This project has a different structure from Projects 1–3. You will write two kinds of files:

1. **`project4.rkt`:** the language implementation. This will define Rhogo syntax and semantics.

2. **`.turtle` files:** programs written *in Rhogo*. You'll create these to test your implementation as you go. Every `.turtle` file should begin with `#lang "project4.rkt"`. 

In Windows, to save as `.turtle` rather than `.turtle.rkt`:
  1. **Save Definitions As ...**
  2. **Save as type** -> "Any"
  3. Save your file as `whatever.turtle`

To test a `.turtle` file in DrRacket:
1. Create a new file (e.g., `test.turtle`) in the same folder as `project4.rkt`
2. Make sure the first line is exactly: `#lang "project4.rkt"`
3. Write your Logo program below that line
4. Run it: your `project4.rkt` controls what happens

**Note:** You will need the `beautiful-racket` package if it is not already installed.

The starter `project4.rkt` includes `#lang br/quicklang` and the following provided helpers — you do not need to implement these:

- `CANVAS-WIDTH`, `CANVAS-HEIGHT`, `BLANK-CANVAS`: canvas size constants
- `next-x`, `next-y`: turtle movement math
- `draw-line`: draws a line segment on an image
- `list-set`: replaces an element in a list by index
- `tokenize`: breaks a line of text into Racket datums
- `turtle-module-begin` / `#%module-begin`: the macro that extracts your final image

### **Do not move on until you see the error:**

`project4.rkt:71:15: state-image: unbound identifier in: state-image`

This means everything is set up correctly and your `.turtle` file is finding your `project4` language reader.

---

## Part 1: Turtle State

The turtle state holds everything needed to interpret Logo commands. Represent it as a 6-element list:

```
(list x y angle pen-down? color image)
  ;    0  1   2      3       4     5
```

- `x`, `y` — turtle position (numbers)
- `angle` — heading in radians (`0` = rightward; `(- (/ pi 2))` = upward)
- `pen-down?` — boolean; `#t` means draw as the turtle moves
- `color` — a color string like `"black"` or `"red"`
- `image` — the accumulated `2htdp/image` being drawn on

### Problem 1.1: State Accessors

Write six accessor functions. Use `list-ref` or the `car`/`cadr`/... family.

```racket
(define test-s (list 10 20 0 #t "blue" BLANK-CANVAS))

; tests
(state-x test-s)     ; => 10
(state-y test-s)     ; => 20
(state-angle test-s) ; => 0
(state-pen? test-s)  ; => #t
(state-color test-s) ; => "blue"
(state-image test-s) ; => BLANK-CANVAS
```

### Problem 1.2: State Updaters

Write six updater functions. Each takes a state and a new value and returns a new state with that one field replaced. Use the provided `list-set` helper.

**Notice:** this is not mutation!

```racket
; --- Each updater changes only its field ---
(state-x     (set-x test-s 99))          ; => 99
(state-y     (set-y test-s 99))          ; => 99
(state-angle (set-angle test-s pi))      ; => pi
(state-pen?  (set-pen test-s #f))        ; => #f
(state-color (set-color test-s "green")) ; => "green"

; --- Updating one field must not disturb the others ---
; set-x: y, angle, pen, color should be unchanged
(state-y     (set-x test-s 99)) ; => 20     (unchanged)
(state-angle (set-x test-s 99)) ; => 0      (unchanged)
(state-color (set-x test-s 99)) ; => "blue" (unchanged)

; set-pen: x, y, color should be unchanged
(state-x     (set-pen test-s #f)) ; => 10     (unchanged)
(state-color (set-pen test-s #f)) ; => "blue" (unchanged)

; set-color: pen should be unchanged
(state-pen? (set-color test-s "green")) ; => #t (unchanged)

; --- Updating the same field twice: last write wins ---
(state-x (set-x (set-x test-s 99) 42)) ; => 42

; --- Changing the image changes the image ---
(state-image (set-image test-s (circle 30 "solid" "green")))
```

### Problem 1.3: initial-state

Write `initial-state`, the starting state for every Rhogo program: turtle centered on the canvas, pen up, color black, blank canvas.

```racket
; tests
(state-x initial-state)     ; => 250  (center of 500x500 canvas)
(state-y initial-state)     ; => 250
(state-angle initial-state) ; => (- (/ pi 2))  (pointing upward)
(state-pen? initial-state)  ; => #f
(state-color initial-state) ; => "black"
```

*Note:* In `2htdp/image`, y increases downward. An angle of `(- (/ pi 2))` points in the negative-y direction ("up") which is Logo's traditional starting direction.

### Problem 1.4: `tokenize`

I've provided a function called `tokenize`. It takes in a single line of text as a string and produces an s-expression consisting of the words (or "tokens") in that line.

Write 2-3 tests for `tokenize` to verify that it works correctly!

---

## Part 2: Reading the Program

When Racket encounters `#lang "project4.rkt"`, it calls your `read-syntax` function to parse the program into a module. Finish implementing it.

### Problem 2.1: read-syntax

The function receives the program as a list of strings (one per line). Your job:

1. Filter out blank lines and comment lines (lines whose first non-whitespace character is `;`)
2. Tokenize each remaining line using the provided `tokenize` helper
3. Wrap each line's token list in a `quote` and splice into the module datum

Each line becomes one **quoted list** passed as an argument to `handle-turtle-cmds`. For example, `FORWARD 100` becomes `'(FORWARD 100)` and `PENDOWN` becomes `'(PENDOWN)`.

Complete the two missing pieces in `read-syntax`:

```racket
(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define filtered   'todo) ; remove blank and comment lines
  (define src-datums 'todo) ; a list of quoted command-lists, one per filtered line
  (define module-datum
    `(module turtle-mod "project4.rkt"
       (handle-turtle-cmds ,@src-datums)))
  (datum->syntax #f module-datum))
```

*Hint:* Use `filter`, `string-trim`, `string=?`, and `string-prefix?`. Is the line empty? Does the line start with `";"`? Look up things you don't know! Try to figure them out yourself!

*Hint:* `(map tokenize filtered)` takes in a list of commands from the source file and gives you a list of token-lists. You need each one to arrive at `handle-cmd` as a `'`-prefixed list — e.g. `'(FORWARD 100)`. Use `map` with a lambda and a quasiquote: `` `',x ``. Look up things you don't know! Try to figure them out yourself!

*Note:* Each line of a Rhogo program must contain exactly one command (and its arguments, if any). `FORWARD 100` on one line is fine; `FORWARD 100 RIGHT 90` on one line is not.

*Test:* Temporarily add `(displayln src-datums)` and/or `(displayln module-datum)` to `read-syntax`, then run the following `.turtle` file:

```
#lang "project4.rkt"
; this is a comment

PENDOWN
FORWARD 100

RIGHT 90
```

If you are displaying `src-datums`, you should see:

```
('(PENDOWN) '(FORWARD 100) '(RIGHT 90))
```

If you are displaying `module-datum`, you should see:

```
(module turtle-mod "project4.rkt"
  (handle-turtle-cmds '(PENDOWN) '(FORWARD 100) '(RIGHT 90)))
```

The blank lines and comment were dropped: each remaining line became a quoted list.

### Problem 2.2: Understanding #%module-begin

The `turtle-module-begin` macro is provided for you:

```racket
(define-macro (turtle-module-begin EXPR)
  #'(#%module-begin
     (display (state-image EXPR))))
```

`EXPR` here is `(handle-turtle-cmds ...)`, the single expression produced by `read-syntax`. The macro calls `handle-turtle-cmds`, extracts the image from the final state using `state-image`, and displays it. DrRacket renders `2htdp/image` images inline in the output area.

**You do not need to modify this macro!**

**Question:** In the funstacker example, `#%module-begin` called `(first HANDLE-ARGS-EXPR)`. Why `first`? Why does this use `state-image`? The macro creates a module. When that module runs, what will happen?

---

## Part 3: Command Dispatch

### Problem 3.1: handle-cmd

Write `handle-cmd` that takes a state and a command list and returns the updated state. This is the heart of your language, a direct parallel to the `cond` inside `handle-args`.

Each command arrives as a list: `'(FORWARD 100)`, `'(RIGHT 90)`, `'(PENDOWN)`, etc. Dispatch on the first element; read arguments from the rest. This function should evluate to a new state based on the current state and command.

```racket
(define (handle-cmd state cmd)
  (define name (first cmd))
  (cond
    [(equal? name 'FORWARD) ...]   ; (second cmd) is the distance
    [(equal? name 'BACK) ...]
    [(equal? name 'RIGHT) ...]     ; (second cmd) is the degrees
    [(equal? name 'LEFT) ...]
    [(equal? name 'PENDOWN) ...]
    [(equal? name 'PENUP) ...]
    [else state]))                 ; unknown command: ignore
```

For **FORWARD**: Create a new turtle whose positiion is `(second cmd)` steps ahead of its current direction, and whose image has a new line drawn on it, if the pen is down. Use the provided `next-x`, `next-y`, and `draw-line` helpers.

For **BACK**: Create a new turtle whose positiion is `(second cmd)` steps in the *opposite* direction (negate the distance, or add `pi` to the angle temporarily), and whose image has a new line drawn on it, if the pen is down.

For **RIGHT**: Create a new turtle whose angle is changed by `(second cmd)` degrees. In screen coordinates (y-down), clockwise rotation *adds* to the angle. Convert degrees to radians with `(* deg (/ pi 180))`.

For **LEFT**: Like **RIGHT** but subtract from the old angle.

```racket
; Tests (run these against your implementation):
(state-pen? (handle-cmd initial-state '(PENDOWN))) ; => #t
(state-pen? (handle-cmd initial-state '(PENUP)))   ; => #f

; After PENDOWN then FORWARD 100, turtle should move up 100 pixels:
(define s1 (handle-cmd initial-state '(PENDOWN)))
(define s2 (handle-cmd s1 '(FORWARD 100)))
(state-x s2) ; => 250.0  (x unchanged when heading straight up)
(state-y s2) ; => 150.0  (moved up 100 pixels)

; RIGHT 90 should rotate the angle by pi/2:
(define s3 (handle-cmd initial-state '(RIGHT 90)))
(state-angle s3) ; => 0.0  (was -(pi/2), added pi/2, now 0 = pointing right)

; test the image changes:
(state-image s2) ; should have a line drawn on it!
```

### Problem 3.2: handle-turtle-cmds

Write `handle-turtle-cmds` that processes a whole Rhogo program. It takes any number of command lists as arguments and folds over them using `handle-cmd`, starting from `initial-state`. You can use `for/fold` or `foldl`.

```racket
(define (handle-turtle-cmds . cmds)
  ...)
(provide handle-turtle-cmds)
```

Compare to the funstacker pattern side-by-side:

```racket
; Funstacker:                          ; Your turtle language:
(for/fold ([stack-acc empty])          (for/fold ([state initial-state])
          ([arg (in-list args)])                  ([cmd (in-list cmds)])
  (cond ...))                            (handle-cmd state cmd))
```

*Test:* Once this is working, run your first `.turtle` file! Here is a square:

```
#lang "project4.rkt"
PENDOWN
FORWARD 100
RIGHT 90
FORWARD 100
RIGHT 90
FORWARD 100
RIGHT 90
FORWARD 100
```

And a triangle:

```
#lang "project4.rkt"
PENDOWN
FORWARD 120
RIGHT 120
FORWARD 120
RIGHT 120
FORWARD 120
```

---

## Part 4: Extensions

### Problem 4.1: COLOR

Add a `COLOR` command. When the program contains `COLOR red`, subsequent lines should be drawn in red. Color names in Logo are plain symbols (`red`, `blue`, `green`, `orange`, etc.) — not strings.

`COLOR red` arrives as `'(COLOR red)`, so `(second cmd)` is the color symbol. Convert it to a string with `symbol->string` and pass it to `set-color`.

```
#lang "project4.rkt"
COLOR red
PENDOWN
FORWARD 100
RIGHT 90
COLOR blue
FORWARD 100
RIGHT 90
COLOR green
FORWARD 100
RIGHT 90
COLOR orange
FORWARD 100
```

### Problem 4.2: SETPOS

Add a `SETPOS` command that teleports the turtle to an absolute position without drawing, regardless of pen state.

`SETPOS` requires *two* arguments: `SETPOS 100 200` moves the turtle to (100, 200). The command arrives as `'(SETPOS 100 200)`, so `(second cmd)` and `(third cmd)` are the x and y coordinates directly — no accumulation needed.

### Problem 4.3: REPEAT (Stretch Goal)

Add support for `REPEAT n ... END` blocks. This is the most challenging extension.

The difficulty: `for/fold` processes one command-list at a time with no lookahead. It can't naturally "group" a block of commands and repeat it.

**Strategy:** Pre-process the command list *before* the fold. Write a function `expand-repeats` that finds every `'(REPEAT n)` ... `'(END)` sequence and replaces it with `n` copies of the inner commands:

```racket
; Example:
(expand-repeats '((PENDOWN) (REPEAT 3) (FORWARD 50) (RIGHT 120) (END)))
; => '((PENDOWN) (FORWARD 50) (RIGHT 120) (FORWARD 50) (RIGHT 120) (FORWARD 50) (RIGHT 120))
```

Then call `expand-repeats` on your command list before the fold in `handle-turtle-cmds`.

*Hint:* Write this recursively. When you see `'(REPEAT n)` at the head of the list, grab the count with `(second (first cmds))`, collect commands until `'(END)`, replicate the block, and recurse on the remainder. The base case is an empty list.

*Added Challenge:* Make `expand-repeats` handle nested `REPEAT`s (a `REPEAT` inside a `REPEAT`). You'll need to track nesting depth when collecting the inner block.

---

## Part 5: Your Rhogo Program

Write a Rhogo program that produces an interesting image. It should use at least three different commands and produce something you'd be proud to show off. **This program should be completely "hand-crafted" — no LLM interference/assistance! You'll do that at the very end!
 
Some ideas:

- **Geometric patterns:** concentric squares, hexagonal grids, nested polygons
- **Stars:** a five-pointed star uses `RIGHT 144`; a six-pointed star uses two overlapping triangles
- **Spirograph-like curves:** use `REPEAT` with a small turn angle and many iterations
- **Abstract art:** don't overthink it — systematic repetition alone produces striking images

Here is a program that draws overlapping squares at increasing scales to get you inspired:

```
#lang "project4.rkt"
PENDOWN
REPEAT 3
  FORWARD 50
  RIGHT 90
END
FORWARD 50
RIGHT 10
REPEAT 3
  FORWARD 60
  RIGHT 90
END
FORWARD 60
RIGHT 10
REPEAT 3
  FORWARD 70
  RIGHT 90
END
FORWARD 70
RIGHT 10
REPEAT 3
  FORWARD 80
  RIGHT 90
END
FORWARD 80
```

Make something you're proud of and that you're able to explain!

**Additionally:** prompt an LLM of your choice to write a Rhogo program based on your own description. The goal here is not: "make me any turtle graphics image". The goal is: can an LLM DRAW what you DESCRIBE?

---

## Tips for Success

1. **Start with Part 2.** Your state accessors and updaters need to work before anything else can. Test them thoroughly before moving on.

2. **Test `handle-cmd` command by command.** Before running a `.turtle` file, call `handle-cmd` directly in DrRacket with `initial-state` and individual command lists like `'(PENDOWN)` and `'(FORWARD 100)`. Watch the state evolve.

3. **Trace a square on paper first.** Write out exactly what the state should look like after each command in the square example: x, y, angle, pen. Then verify your code matches.

4. **Screen coordinates go downward.** `FORWARD` while facing "up" *decreases* y. The initial angle `(- (/ pi 2))` makes this work. If your turtle moves the wrong direction, check your angle arithmetic.

5. **Degrees vs. radians.** `(second cmd)` gives you degrees (as the user wrote them). Your `handle-cmd` must convert to radians before updating the angle. A RIGHT 90 should change the angle by `(/ pi 2)`.

6. **Use `(displayln state)` inside `handle-cmd`.** Watching the state evolve is an easy way to catch errors in your math.

---

## Resources

- [2htdp/image documentation](https://docs.racket-lang.org/teachpack/2htdpimage.html)
- [Beautiful Racket / br/quicklang documentation](https://beautifulracket.com/) — the library powering `read-syntax` and `define-macro`
- [Logo programming language (Wikipedia)](https://en.wikipedia.org/wiki/Logo_(programming_language))
- [Turtle graphics (Wikipedia)](https://en.wikipedia.org/wiki/Turtle_graphics)
- *Mindstorms: Children, Computers, and Powerful Ideas* — Seymour Papert, 1980
