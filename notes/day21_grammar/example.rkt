#lang brag
; let's make a grammar that produces assignment statements:
; General Form:
;    var = val o val
;    where: var is a valid variable name
;           val is either a variable or a number
;           o is a valid operation
assignment : var [" "] "=" [" "] val [" "] func [" "] val