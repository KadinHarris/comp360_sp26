#lang reader "main.rkt"
game beautiful-galaga {
                       canvas background

                       entity player {
                                     size 10x10
                                     controls[A D]
                                     speed 10
                                      }
                       }

play beautiful-galaga