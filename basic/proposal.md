Team Members: Trevor Williams, Kadin Harris, Peter Kennedy
Language Name and Description: Beautiful Galaga
Our language targets the domain of making a Galaga-like 2d game. Other tools are too general and complex to easily make a Galaga-like. 
Example Programs:
#lang br

game beutiful-galaga {
 canvas background

 entity player {
                size 20x20
                picture p
                controls [A D space]
                bounds left right
                }

 entity bug {
             size 20x20
             picture bp
             controls cpu
             }

 entity rocket {
                size 2x5
                speed s
                bounds top bottom
                player? bool
                }
 die-on [player-pos = enemy-rocket-pos]
 score-on [enemy-pos = player-rocket-pos]
 game-over [player-live = 0]
}
play beautiful-galaga

game beutifal-pong {
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

play beutifal-pong

AI-Policy: AI-Assisted without heavily relying on it. Pure attempt for first try and AI only if we run into a wall. 
Language Goals: Maybe a general use 2d game language that is easy to use in order to make a variable version of Galaga.
