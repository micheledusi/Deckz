#import "../model/convert.typ": * 
#import "canvas.typ": *
#import "placement.typ": *

// Show the stack of rank + suit symbols
#let render-rank-and-suit-stack(card-data) = {
  align(center + horizon,
    stack(
      dir: ttb,
      spacing: 0.2em,
      ranks.at(card-data.rank),
      suits.at(card-data.suit),
    )
  )
}

//// Show cards

#let render-card-inline(card, equal-size: true) = {
  let card-data = extract-card-data(card) 
  box(
      fill: bg-color,
      inset: 0pt, outset: 0.13em,
      radius: 40%,
      width: if equal-size {1.5em} else {auto},
      text(card-data.color, align(center)[#ranks.at(card-data.rank)#suits.at(card-data.suit)])
  )
}

#let render-card-mini(card) = {
  let card-data = extract-card-data(card) 
  box(
      width: 1.5em,
      height: 2.1em, 
      inset: 8%,
      stroke: border-style,
      radius: 10%,
      fill: bg-color,
  )[
      #text(card-data.color, render-rank-and-suit-stack(card-data))
  ]
}

#let render-card-small(card) = {
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
        box(width: 0.8em, align(center, ranks.at(card-data.rank)))
      )
      #align(center + horizon)[
        #text(size: 1.4em, suits.at(card-data.suit))
      ]
    ]
  ]
}

#let render-card-medium(card) = {
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
        render-rank-and-suit-stack(card-data)
      )
      #text(2em,
        align(center + horizon,
          draw-central-rank-canvas(card-data)
        )
      )
    ]
  ]
}

#let render-card-large(card) = {
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
        render-rank-and-suit-stack(card-data)
      )
      #text(3em,
        align(center + horizon,
          draw-central-rank-canvas(card-data)
        )
      )
    ]
  ]
}

// Square card layout
#let render-card-square(card) = {
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
        render-rank-and-suit-stack(card-data)
      )
      #text(2.5em,
        align(center + horizon,
          draw-central-rank-canvas(card-data)
        )
      )
    ]
  ]
}

// Render function to view cards in different formats.
// This function allows you to specify the format of the card to be rendered.
// Available formats include: inline, mini, small, medium, large, and square.
#let render(card, format: "small") = {
  if format == "inline" {
    render-card-inline(card)
  } else if format == "mini" {
    render-card-mini(card)
  } else if format == "small" {
    render-card-small(card)
  } else if format == "medium" {
    render-card-medium(card)
  } else if format == "large" {
    render-card-large(card)
  } else if format == "square" {
    render-card-square(card)
  } else {
    render-card-small(card)
  }
}
