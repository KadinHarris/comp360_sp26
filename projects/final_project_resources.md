## Final Project Checklist:
* `main.rkt`: contains a `read-syntax` function, which uses your parser to produce a parse tree
* Language installed as a project, so your files can simply say: `#lang my-dsl`
* `tokenizer.rkt`: file which recognizes and returns discrete tokens for your language, may use additional helper files/modules
* `parser.rkt`: file which defines a grammar for your language
* `expander.rkt`: file which translates parsed s-expressions (the parse tree) into actual Racket code, may use additional helper files/modules
* Racket code: functions which do everything your language needs!
* Example programs: at least 2 which demonstrate the flexibilty / functionality of your language
* Syntax Coloring: follow the examples in the book!
* Error Handling: follow the examples in the book!


## Guides:
* Steps to Create a Language:
  * https://beautifulracket.com/appendix/master-recipe.html#the-boot-module
* Installing Your Language as a Package:
  * https://beautifulracket.com/appendix/master-recipe.html#setting-up-a-language-project
* Syntax Patterns for Racket Macros:
  * https://beautifulracket.com/explainer/syntax-patterns.html


## Must-Have Features:
* Syntax Coloring:
  * https://beautifulracket.com/jsonic-2/syntax-coloring.html
  * https://beautifulracket.com/basic-2/the-syntax-colorer.html
* Error Handling:
  * https://beautifulracket.com/basic-2/better-line-errors.html

## Additional Topics
* Variables:
  * https://beautifulracket.com/basic-2/variables-and-input.html
* Indentation:
  * https://beautifulracket.com/jsonic-2/indenting.html
* Adding Buttons to DrRacket:
  * https://beautifulracket.com/jsonic-2/toolbar-buttons.html
* Unit Tests:
  * https://beautifulracket.com/jsonic-2/unit-tests.html


