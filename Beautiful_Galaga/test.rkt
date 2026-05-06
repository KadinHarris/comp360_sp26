#lang reader "main.rkt"
game test {
  canvas 400x400
  entity ball {
    size 20
    color red
    velocity (3 2)
    bounce-off true
  }
  entity player {
    size 15
    color blue
    speed 5
    controls [left left right right up up down down]
  }
}
play galaga