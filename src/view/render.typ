// render.typ

#import "@preview/elembic:1.1.1" as e

#import "../data/format.typ": format-parameters
#import "place-content.typ": *



/// Shows a rectangle with the card style and a custom content
/// The rectangle is a `box` and takes the background and stroke of the card element.
/// 
/// -> content
#let render-card-frame(
	/// The card element
	card, 
	/// The content of the card
	body,
) = box(
	fill: card.fill,
	stroke: card.stroke,
  ..format-parameters.at(card.format),
  body
)


#let render-card-content(card) = {
	let rank-symbol = e.fields(card.rank).symbol
	let suit-symbol = e.fields(card.suit).symbol

  if card.format == "inline" {
    align(center)[#rank-symbol#suit-symbol]
  } 
  else if card.format == "mini" {
    align(center,
      cetz.canvas(
        draw-stack-rank-and-suit(suit-symbol, rank-symbol)
      )
    )
  } 
  else if card.format == "small" {
    two-corners(
      box(width: 0.8em, align(center, rank-symbol))
    )
    align(center + horizon)[
      #text(size: 1.4em, suit-symbol)
    ]
  } 
  else if card.format == "medium" {
    two-corners(
      cetz.canvas(
        draw-stack-rank-and-suit(suit-symbol, rank-symbol)
      )
    )
    text(2em,
      align(center + horizon,
        draw-central-rank-canvas(card)
      )
    )
  } 
  else if card.format == "large" {
    four-corners(
      cetz.canvas(
        draw-stack-rank-and-suit(suit-symbol, rank-symbol)
      )
    )
    text(3em,
      align(center + horizon,
        draw-central-rank-canvas(card)
      )
    )
  }
  else if card.format == "square" {
    four-corners-diagonal(
      cetz.canvas(
        draw-stack-rank-and-suit(suit-symbol, rank-symbol)
      )
    )
    text(2.5em,
      align(center + horizon,
        draw-central-rank-canvas(card)
      )
    )
  } else {
    panic("Cannot recognize the card format specified: " + card.format)
  }
}

#let render-card(card) = {
	let card-content-body = if card.code == none []
	else if card.code == "back" {
		block(
			width: 100%,
			height: 100%,
			radius: 4pt,
			fill: tiling(offset: (50%, 50%), image("../../res/decks/default/back.svg"))
		)
	}
	else {
		text(e.fields(card.suit).color,
			render-card-content(card)
		)
	}

	render-card-frame(card, card-content-body)
}