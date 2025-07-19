#import "../model/convert.typ": * 
#import "canvas.typ": *
#import "placement.typ": *


//// Show card elements

// Show the stack of number + suit symbols
#let show-number-and-suit-stack(card-data) = {
  align(center + horizon,
    stack(
      dir: ttb,
      spacing: 0.2em,
      numbers.at(card-data.number),
      suits.at(card-data.suit),
    )
  )
}



//// Show cards

#let show-card-inline(card, equal-size: true) = {
  let card-data = extract-card-data(card) 
  box(
      fill: bg-color,
      inset: 0pt, outset: 0.13em,
      radius: 40%,
      width: if equal-size {1.5em} else {auto},
      text(card-data.color, align(center)[#numbers.at(card-data.number)#suits.at(card-data.suit)])
  )
}

#let show-card-mini(card) = {
  let card-data = extract-card-data(card) 
  box(
      width: 1.5em,
      height: 2.1em, 
      inset: 8%,
      stroke: border-style,
      radius: 10%,
      fill: bg-color,
  )[
      #text(card-data.color, show-number-and-suit-stack(card-data))
  ]
}

#let show-card-small(card) = {
  let card-data = extract-card-data(card) 
  box(
      width: 2.5em,
      height: 3.5em, 
      inset: 8%,
      stroke: border-style,
      radius: 10%,
      fill: bg-color,
  )[
    #text(card-data.color)[
      #two-corners(
        box(width: 0.8em, align(center, numbers.at(card-data.number)))
      )
      #align(center + horizon)[
        #text(size: 1.4em, suits.at(card-data.suit))
      ]
    ]
  ]
}

#let show-card-medium(card) = {
  let card-data = extract-card-data(card) 
  box(
      width: 6.5em,
      height: 9.1em, 
      inset: 6%,
      stroke: border-style,
      radius: 10%,
      fill: bg-color,
  )[
    #text(card-data.color)[
      #two-corners(
        show-number-and-suit-stack(card-data)
      )
      #text(2em,
        align(center + horizon,
          draw-central-number-canvas(card-data)
        )
      )
    ]
  ]
}

#let show-card-large(card) = {
  let card-data = extract-card-data(card) 
  box(
    width: 10em,
    height: 14em, 
    inset: 5%,
    stroke: border-style,
    radius: 10%,
    fill: bg-color,
  )[
    #text(card-data.color)[
      #four-corners(
        show-number-and-suit-stack(card-data)
      )
      #text(3em,
        align(center + horizon,
          draw-central-number-canvas(card-data)
        )
      )
    ]
  ]
}

// Square card layout
#let show-card-square(card) = {
  let card-data = extract-card-data(card) 
  box(
    width: 10em,
    height: 10em, 
    inset: 4%,
    stroke: border-style,
    radius: 8%,
    fill: bg-color,
  )[
    #text(card-data.color)[
      #four-corners-diagonal(
        show-number-and-suit-stack(card-data)
      )
      #text(2.5em,
        align(center + horizon,
          draw-central-number-canvas(card-data)
        )
      )
    ]
  ]
}