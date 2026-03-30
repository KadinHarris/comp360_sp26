# COMP 360 - Day 26 Practice: Tokenizer + Parser

## Goal

Build a complete **tokenizer** and **parser** for a tiny language called **Lettify**.
By the end of class, you will:

1. Write lexer rules that produce **typed tokens** (NUMBER, ID, etc.) and **bare lexemes** for keywords
2. Understand a **brag grammar** that consumes those tokens
3. Extend the grammar to handle **bracket expressions**
4. Watch your tokenizer and parser work together to produce a **parse tree**

## The Lettify Language

Lettify programs look like this:

```
let x = 5
let y = [x + 3]
let z = [y * 2]
```

- `let` is a **keyword**
- `x`, `y`, `z` are **identifiers** (variable names)
- `5`, `3`, `2` are **numbers**
- `=` is the **assignment** operator
- `+`, `-`, `*`, `/` are **arithmetic operators**
- `[` and `]` are **brackets** for grouping expressions

## Token Types

| Token Type | Matches | Examples |
|------------|---------|----------|
| *(bare lexeme)* | `let` | `let` |
| ID | letter followed by letters/digits | `x`, `myVar`, `count1` |
| NUMBER | one or more digits | `5`, `42`, `100` |
| ASSIGN | `=` | `=` |
| OP | `+`, `-`, `*`, `/` | `+` |
| LBRACKET | `[` | `[` |
| RBRACKET | `]` | `]` |

Keywords like `let` are returned as **bare lexemes** (untyped strings) rather
than typed tokens. The parser matches them by their literal value (`"let"`).

Whitespace is **skipped** (not returned as a token).

## Grammar

The parser uses this grammar (in `parser.rkt`):

```
program   : statement*
statement : "let" ID ASSIGN expr
expr      : term | BRACKET-RULE
term      : NUMBER | ID
```

Read this as:
- A **program** is zero or more statements
- A **statement** is: the literal `"let"`, then an ID, then ASSIGN, then an expression
- An **expression** is either a single term OR a bracketed expression `[expr OP expr]`
- A **term** is a NUMBER or an ID

## Instructions

### Part 1: Build the Tokenizer (~20 min)

Open `tokenizer.rkt`. You will see 7 TODO tasks inside the lexer.
Fill in each rule using the hints provided. After each rule, test your
tokenizer in the REPL:

```racket
(require "tokenizer.rkt")
(require brag/support)
(apply-tokenizer-maker make-tokenizer "let x = 5")
```

**Tip:** The order of rules matters! Keywords must come before identifiers
(because of the First Match principle). The `any-char` fallback at the
bottom catches anything your rules don't match yet.

### Part 2: Complete the Parser (~10 min)

Open `parser.rkt`. The grammar is almost complete but is missing support
for bracket expressions. Follow the TODO to add the bracket rule.

Test with:
```racket
(require "parser.rkt" "tokenizer.rkt" brag/support)
(parse-to-datum (apply-tokenizer-maker make-tokenizer "let x = 5"))
```

### Part 3: Run the Tests (~15 min)

Open `tests.rkt` and run it. Fix any issues until all tests pass.

### Challenge (~5 min)

Can you add a `print` keyword? What changes in the tokenizer?
What changes in the grammar?

## Quick Reference

### Lexer Patterns
| Pattern | Matches |
|---------|---------|
| `"abc"` | exact string `"abc"` |
| `(char-range "0" "9")` | one digit |
| `(char-set "+-*/")` | any one of those characters |
| `(union re1 re2)` | re1 OR re2 |
| `(concatenation re1 re2)` | re1 then re2 |
| `(repetition lo hi re)` | re between lo and hi times |
| `whitespace` | space, tab, or newline |

### Lexer Actions
| Action | Effect |
|--------|--------|
| `(token 'TYPE lexeme)` | return a typed token |
| `(next-token)` | skip this match |
| `lexeme` | return the matched string (untyped) |

### Lexer Principles
- **Maximal Munch**: always pick the longest match
- **First Match**: ties go to the first rule listed
