#lang reader "main.rkt"

game beautiful-galaga {
  canvas 800x600

  entity player {
    size 10x10
    speed 10
    controls [A D]
  }

  entity enemy {
    size 8x8
    speed 5
    cpu true
  }
}

play beautiful-galaga
