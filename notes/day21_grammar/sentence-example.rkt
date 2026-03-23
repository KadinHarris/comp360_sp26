#lang brag
; let's make a grammar that parses "English" "sentences"
; "sentences" are defined as: a subject followed by a verb followed by an optional object
sentence : subject verb [object]
subject  : "Jace" | "CS" | "Racket"
verb     : "loves" | "hates"
object   : subject