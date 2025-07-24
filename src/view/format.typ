#import "../model/convert.typ": * 
#import "canvas.typ": *
#import "placement.typ": *

// Dictionary of formats' parameters
// this is used to make code more modular and reusable
#let format-parameters = (
  default: (
    width: auto, // Width must be provided! 
    height: auto, // Height must be provided!
    inset: 2pt + 3%, 
    outset: 0pt,
    radius: 2pt + 5%,
    stroke: border-style,
    fill: bg-color,
  ),
  inline: (
    width: 1.5em, 
    height: 0.8em,
    inset: 0pt, 
    outset: 0.13em,
    radius: 0.5em,
    stroke: none,
  ),
  mini: (
    width: 1.5em, 
    height: 2.1em,
  ),
  small: (
    width: 2.5em, 
    height: 3.5em,
  ),
  medium: (
    width: 6.5em, 
    height: 9.1em,
  ),
  large: (
    width: 10em, 
    height: 14em,
  ),
  square: (
    width: 10em, 
    height: 10em,
  ),
)

#{
  // When the module is imported, this should be executed
  for (format, params) in format-parameters.pairs() {
    if format != "default" {
      // For every parameter
      for key in format-parameters.default.keys() {
        if key not in params {
          format-parameters.at(format).insert(key, format-parameters.default.at(key))
        }
      }
    }
  }
  // This guarantees that every format has all the parameters to be displayed.
  // TODO for future releases: load configs from file.
}

// Show a rectangle with the card style and a custom content
#let render-card-frame(format, body) = box(
  ..format-parameters.at(format),
  body
)

#let render-card-content(format, card-data) = {
  if format == "inline" {
    align(center)[#ranks.at(card-data.rank)#suits.at(card-data.suit)]
  } 
  else if format == "mini" {
    align(center,
      cetz.canvas(
        draw-stack-rank-and-suit(card-data)
      )
    )
  } 
  else if format == "small" {
    two-corners(
      box(width: 0.8em, align(center, ranks.at(card-data.rank)))
    )
    align(center + horizon)[
      #text(size: 1.4em, suits.at(card-data.suit))
    ]
  } 
  else if format == "medium" {
    two-corners(
      cetz.canvas(
        draw-stack-rank-and-suit(card-data)
      )
    )
    text(2em,
      align(center + horizon,
        draw-central-rank-canvas(card-data)
      )
    )
  } 
  else if format == "large" {
    four-corners(
      cetz.canvas(
        draw-stack-rank-and-suit(card-data)
      )
    )
    text(3em,
      align(center + horizon,
        draw-central-rank-canvas(card-data)
      )
    )
  }
  else if format == "square" {
    four-corners-diagonal(
      cetz.canvas(
        draw-stack-rank-and-suit(card-data)
      )
    )
    text(2.5em,
      align(center + horizon,
        draw-central-rank-canvas(card-data)
      )
    )
  } else {
    render-card-medium(card)
  }
}

#let render-card(format, card) = {
  let card-data = extract-card-data(card)
  if card-data.suit == none or card-data.rank == none {
    import "back.typ": render-back
    render-back(format: format)
  } else {
    render-card-frame(format,
      text(card-data.color,
        render-card-content(format, card-data)
      )
    )
  }
}

#let render-card-inline(card) = render-card("inline", card)

#let render-card-mini(card) = render-card("mini", card)

#let render-card-small(card) = render-card("small", card)

#let render-card-medium(card) = render-card("medium", card)

#let render-card-large(card) = render-card("large", card)

#let render-card-square(card) = render-card("square", card)


#import "@preview/suiji:0.4.0" as suiji // Random numbers library

// Render function to view cards in different formats.
// This function allows you to specify the format of the card to be rendered.
// Available formats include: inline, mini, small, medium, large, and square.
// 
// - 'card': The code of the card you want to represent.
// - 'format': The selected format (inline, mini, small, medium, large, and square). Default value is "medium".
// - 'noise': The amount of "randmness" in the placement and rotation of the card. Default value is "none" or "0", which corresponds to no variations. A value of 1 corresponds to a "standard" amount of noise, according to Deckz style. Higher values might produce crazy results, handle with care.
#let render(card, format: "medium", noise: none) = {
  if noise == none or noise <= 0 {
    // No Noise
    return render-card(format, card)
  } else {
    // Ok noise
    let seed = int(noise * 1e9) + 42
    let rng = suiji.gen-rng-f(seed)
    let (rng, (shift-x, shift-y, shift-rot)) = suiji.uniform-f(rng, low: -1/2, high: 1/2, size: 3)
    move(
      dx: shift-x * noise * 0.5em,
      dy: shift-y * noise * 0.5em,
      rotate(
        shift-rot * noise * 15deg,
        origin: center + horizon,
        { // Translated and rotated content
          render-card(format, card)
        }
      )
    )
  }
}