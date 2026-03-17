# Final Project: Build Your Own Domain-Specific Language

**COMP 360 Programming Languages | Spring 2026**

---

## Overview

For the rest of this course, you and your team will design and implement a **domain-specific language (DSL)** using Racket and the [Beautiful Racket](https://beautifulracket.com/) ecosystem (`br`, `brag`).

---

## Teams

- **Size:** 2–3 students per team
- **Formation:** You will choose your own team. Team formation is due with the Project Proposal.
- **Team Changes:** There will be two opportunities to change teams, announced in class.
- **Team Leader:** For each checkpoint, your team will choose a different team leader. That person is responsible for driving language development and assigning fair grades to the team members for that checkpoint.

---

## AI Policy

Each team declares an **AI policy** in their Project Proposal and sticks to it for the entire project. There are two options:

| Policy | What it means |
|---|---|
| **AI-Assisted** | You may use AI tools (GitHub Copilot, Claude, ChatGPT, etc.) to help write and debug code or plan/guide development. All AI use must be disclosed in checkpoint write-ups. **Expectations will be adjusted accordingly!** |
| **AI-Free** | You commit to highly restricted use of AI (ex, only for debugging) or no AI use at all. |

---

## Schedule

| Week of | Deadline |
|---|---|
| Mar 23 | **Project Proposal** |
| Mar 30 | **Checkpoint 1** |
| Apr 6 | **Checkpoint 2**   |
| Apr 13 | **Checkpoint 3** |
| Apr 20 | **Checkpoint 4**  |

**Checkpoints:** your team will schedule a time during the week to present your progress and your next steps; checkpoint write-ups should very short (less than 1 page is fine) summaries of progress-so-far and next steps; push changes to your git repo **24 hours** before your scheduled meeting time.

**Final Presentations, Fri May 8 1 pm:** your team will demo your language during the final exam block

---

## Deliverables

### Project Proposal

Due during the week of Mar 23. Create a markdown file called `proposal.md` describing:

1. **Team members:** names and declared AI policy
2. **Language Name and Description:** What domain does it target? What problem does it solve? Why is a DSL the right tool?
3. **Example Programs:** At least 2–3 short example programs written *in your language* (even if it doesn't run yet), with descriptions of what each program does and what output it produces
4. **AI policy:** Clearly state your team's AI policy and a justification. Be very specific: how are you allowed/disallowed to use AI
5. **Checkpoint 1 Commitments:** See requirements below
6. **Language Goals:** An ambitious/hopeful description of your languages capabilities by the final presentation date, including language features, capabilities, and syntax features.

---

### Checkpoint 1: Core Infrastructure

**Minimum requirements (must have):**
- `lexer.rkt`: a tokenizer which turns raw input into valid tokens (or errors out)
- `parser.rkt`: a grammar / parser (written with `brag`, doesn't have to handle all syntax yet)
- `main.rkt`: a reader which uses your tokenizer and parser to create a module datum (turns raw text into a syntax tree)
- `expander.rkt`: an expander which turns your module datum into a syntax object (can be a stub which only handles one or two syntax structures)
- At least one **end-to-end example** that runs (can be very simple)

**Expected (should have):**
- A concrete list of syntax constructs and language features your language will support
- A short written plan for what you will build in Checkpoint 2

**Writeup:** A short (less than 1 page is fine) summary of what you've done and what you plan to do next

**Presentation format:** 10-minute live demo + Q&A. Show your example running. Explain your grammar.

---

### Checkpoint 2: First Working Features

- Core features of your language are implemented and working
- At least 2–3 meaningful example programs run correctly (should clearly demonstrate the potential of your language)
- Design decisions you made in your grammar and expander

**Writeup:** A short (less than 1 page is fine) summary of what you've done and what you plan to do next

**Presentation format:** 10-minute live demo + Q&A. Show your example running. Explain your grammar.

---

### Checkpoint 3: Extended Features

- The majority of your intended feature set is implemented
- At least 2-3 new meaningful example programs run correctly (should clearly demonstrate most of the capabilities of your language)
- Error handling: your language gives some reasonable error messages for ill-formed programs

**Writeup:** A short (less than 1 page is fine) summary of what you've done and what you plan to do next

**Presentation format:** 10-minute live demo + Q&A. Show your example running. Explain your grammar.

---

### Checkpoint 4: Polish & Completeness

- All intended features are implemented (or scope changes are documented and justified)
- Your language is self-consistent and documented
- A `README` explains how to install, run, and write programs in your language
- Prepared for final demo

**Writeup:** A short (less than 1 page is fine) summary of what you've done and what you plan to do next

**Presentation format:** 10-minute live demo + Q&A. Show your example running. Explain your grammar.

---

### Final Presentation: during the final exam

A **15-minute live demo** to the class. Your presentation should include:

1. **Motivation:** Why this domain? What makes your language useful or interesting?
2. **Language Tour:** Walk through the key syntax and semantics; show your parser and be prepared to show interesting features of your tokenizer and/or expander
3. **Live Demos:** Run at least 3 programs that showcase different features
4. **Reflection:** What was hard? What would you do differently? What did you learn about language design?
5. **Q&A:** Be prepared to answer questions about implementation choices

---

## Grading

Checkpoints are graded on **progress and communication**, not perfection. The team leader will assign grades to the team members for checkpoints.

Grading for the final project is to be determined.

---

## Language Stubs

Below are some ideas to spark your imagination. You are not required to choose one of these: you may propose your own language idea. If you do choose one of these, make it your own: the name, syntax, and feature set are up to you.

---

### Fractal

**Domain:** Generative geometry and visual art

A language for describing and rendering fractals. Programs describe the rules and parameters of a fractal system; the language handles the rendering. Could support:

- **L-systems:** rewriting rules that describe organic, branching shapes (plants, trees, coastlines)
- **Iterated Function Systems (IFS):** transformations that generate self-similar shapes (Sierpinski triangle, Barnsley fern)
- Color palettes, iteration depth, canvas size

```
l-system fern {
  iterations 8
  axiom F
  rule F -> FF+[+F-F-F]-[-F+F+F]
  angle 25
  color green
}
show fern
```

*Why it's a good DSL:* The domain is well-defined and declarative. The language can be simple while producing complex and interesting output.

---

### Waveform

**Domain:** Synthetic music and sound design

A language for composing music by describing waveforms, envelopes, and sequences. Programs describe sounds in terms of oscillators, effects, and timing; the language synthesizes audio output (e.g., a `.wav` file or live playback via `rsound`).

```
instrument bass {
  wave sine
  frequency 110
  envelope (attack 0.01) (decay 0.1) (sustain 0.7) (release 0.3)
}

play forever: melody [C4 E4 G4 C5] tempo 120 instrument bass
```

*Why it's a good DSL:* Sound synthesis is naturally declarative. The language gives you control over time, frequency, and timbre without needing to write sample-by-sample code.

---

### Graphs

**Domain:** Graph theory or data visualization

This stub has two directions. Pick one (or propose a hybrid):

**Option A — Graph algorithms:** A language for describing graphs and running algorithms on them. Define nodes, edges, weights, and then call named algorithms (BFS, DFS, Dijkstra, minimum spanning tree, etc.). Output could be a visualization or a printed result.

```
graph city-map {
  nodes [A B C D E]
  edges [(A B 4) (A C 2) (B D 5) (C D 1) (D E 3)]
}

run dijkstra from A to E on city-map
```

**Option B — Curve plotting:** A language for plotting mathematical functions and datasets on 2D (or 3D) axes, with control over range, color, labels, etc.

```
let f(x) = x^2 + 2x + 3
let g(x) = sin(x)
plot f(x) {
    domain [-5, 5]
    color blue
    label at (2, 2) "f"
    emphasize minimum, maximum, roots
}
plot g(x) {
    domain [0, pi]
    color green
}
show plot
```

*Why it's a good DSL:* Graph problems have a natural declarative structure. Algorithms become first-class named operations.

---

### Algebra

**Domain:** Symbolic mathematics

A language for writing and manipulating algebraic expressions. Could support:
- Simplification of expressions (`2x + 3x => 5x`)
- Solving equations for a variable
- Substitution and evaluation
- Pretty-printing in standard math notation

```
let f = 3x^2 + 2x - 5
simplify f
solve f = 0 for x
evaluate f at x = 2
```

*Why it's a good DSL:* The domain is well-understood, transformation rules are explicit, and the results are verifiable. This one lends itself to interesting expander work.

---

### Particles

**Domain:** Physics simulation

A language for setting up and running particle simulations. Programs describe a universe: masses, initial positions and velocities, forces between objects. The language runs the simulation and visualizes it (e.g., using `2htdp/image` or `racket/draw`).

```
universe solar-system {
  body sun    { mass 1e30  position (0 0)       velocity (0 0) }
  body earth  { mass 5.9e24 position (1.5e11 0) velocity (0 29780) }
  body moon   { mass 7.3e22 position (1.5e11 3.8e8) velocity (1022 29780) }
}

simulate solar-system for 365 days step 3600
```

*Why it's a good DSL:* The simulation loop is handled by the language runtime; the programmer only describes initial conditions and rules. Scope carefully: start with 2D Newtonian gravity before adding more physics, like collisions.

---

### Game Jammer

**Domain:** Simple 2D games

A language for describing small, complete arcade-style games. The language handles the game loop, input, collision, and rendering; the programmer describes entities, behaviors, and rules.

```
game pong {
  canvas 800x600

  entity paddle {
    size 10x80
    color white
    controls [W S]
    bounds top bottom
  }

  entity ball {
    size 10x10
    velocity (3 3)
    bounce-off [paddle wall]
  }

  score-on [left-wall right-wall]
}

play pong
```

*Why it's a good DSL:* Games have a highly repetitive structure (game loop, entities, rules) that a DSL can hide. *Caveat:* Scope aggressively -- define a narrow class of games (ex, pong-likes or shoot-em-ups) and do it well rather than trying to support everything.

---

### Dungeon

**Domain:** Text adventure games

A language for authoring interactive fiction and text adventures. Programs describe rooms, objects, NPCs, and rules; the language interprets player commands and manages state.

```
dungeon haunted-manor {
  room foyer {
    description "A dusty entrance hall. A chandelier flickers overhead."
    exits [north: hallway, east: study]
    item key { description "An ornate brass key." }
  }

  room study {
    description "Walls lined with old books."
    requires key
    on-enter { print "The door unlocks with a satisfying click." }
  }
}

world overworld {
    starting-location haunted-manor
    locations [haunted-manor]
}

play overworld
```

*Why it's a good DSL:* Narrative structure maps naturally to a declarative language. This is a classic DSL problem with well-understood semantics: great for a team that wants to focus on expressive language design over rendering/graphics.

---

### Super-Turtle

**Domain:** Educational graphics (Logo-inspired)

A language in the spirit of Logo: move a turtle around a canvas to draw pictures. But go beyond Logo: add variables, loops, functions, recursion, color, and higher-level constructs like stamps or filled shapes.

```
def snowflake [size depth] {
  if depth = 0 {
    forward size
  } else {
    snowflake [size / 3, depth - 1]
    left 60
    snowflake [size / 3, depth - 1]
    right 120
    snowflake [size / 3, depth - 1]
    left 60
    snowflake [size / 3, depth - 1]
  }
}

color blue
snowflake [200 4]
```

*Why it's a good DSL:* Turtle graphics is a well-understood, visually rewarding domain. There's a natural progression from simple movement commands to a full expressive language. Good choice for a team that wants a clear baseline with room to grow.

---

## Tips for a Strong Proposal

- **Pick a domain you actually care about.** Enthusiasm matters!
- **Start narrow.** Look up (and avoid!!) "scope creep". Do a few things well rather than many things poorly!
- **Think about your example programs first.** If you can't write 3 interesting programs in your language before you've built it, the language design needs work.
- **The expander is where the interesting work happens.** The grammar defines what is syntactically valid; the expander defines what it *means*. Think about this early.
- **You are not building a general-purpose language.** Pick a *domain* and stick to it!
