// place-content.typ

#import "@preview/elembic:1.1.1" as e

//// Placement functions for rendering a given content in specific positions.

// Places a content in the four corners of the parent container.
// Content is quadrupled and shown with axial simmetry.
#let two-corners(body) = {
  place(top + left, body)
  place(bottom + right, rotate(180deg, reflow: true, body))
}

// Places a content in the four corners of the parent container.
// Content is quadrupled and shown with axial simmetry.
#let four-corners(body) = {
  place(top + left, body)
  place(top + right, body)
  place(bottom + left, rotate(180deg, reflow: true, body))
  place(bottom + right, rotate(180deg, reflow: true, body))
}

// Places a content in the four corners of the parent container.
// Content is quadrupled and rotated with bottom direction pointing to the center.
// Each element is rotated accordingly to the 45deg diagonal.
#let four-corners-diagonal(body) = {
  place(top + left, rotate(-45deg, reflow: true, body))
  place(top + right, rotate(45deg, reflow: true, body))
  place(bottom + left, rotate(-135deg, reflow: true, body))
  place(bottom + right, rotate(135deg, reflow: true, body))
}

// Canvas placement

#import "@preview/cetz:0.4.1"
#import cetz.draw: content, move-to

// Draw a figure rank (J, Q, K) in a CeTZ canvas
// in double copy, with a central symmetry.
// 
// _*Note*: this has to be drawn in a canvas._
#let draw-symmetric-figure-canvas(rank, symbol) = {
	// Suit
	content((-1em, 0.75em), symbol)
	content((1em, -0.75em), angle: 180deg, symbol)
	// Figure rank
	content((0.1em, 0.68em), angle: 0deg, text(size: 1.7em, rank))
	content((-0.1em, -0.68em), angle: 180deg, text(size: 1.7em, rank))
}

// Show the stack of rank + suit symbols.
// Used for corners in larger formats, or for content in "mini" format.
// 
// _*Note*: this has to be drawn in a canvas._
#let draw-stack-rank-and-suit(suit-symbol, rank-symbol, dx: 0pt, dy: 0pt, angle: 0deg) = {
	move-to((dx, dy))
	content((rel: (0pt, -1em)), angle: angle, suit-symbol)
	content((rel: (0pt, +1em)), angle: angle, rank-symbol)
}

// Show the stack of rank + suit symbols
#let draw-central-rank-canvas(card) = {
  let rank-id = e.fields(card.rank).id
	let symbol = e.fields(card.suit).symbol
	cetz.canvas({
  // Switch by rank
		
		// ACE
		if rank-id == "ace" {
			content((0,0), 
				if (card-data.suit == "spade") {
					text(size: 2em, symbol)
				} else {
					symbol
				}
			)

		// TWO
		} else if rank-id == "two" {
			content((0, 1.5em), symbol)
			content((0, -1.5em), angle: 180deg, symbol)

		// THREE
		} else if rank-id == "three" {
			content((0, 1.5em), symbol)
			content((0, 0), symbol)
			content((0, -1.5em), angle: 180deg, symbol)
		
		// FOUR
		} else if rank-id == "four" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)

		// FIVE
		} else if rank-id == "five" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((0, 0), symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)

		// SIX
		} else if rank-id == "six" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((-0.5em, 0), symbol)
			content((0.5em, 0), symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)

		// SEVEN
		} else if rank-id == "seven" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((0, 0.75em), symbol)
			content((-0.5em, 0), symbol)
			content((0.5em, 0), symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)

		// EIGHT
		} else if rank-id == "eight" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((-0.5em, 0.5em), symbol)
			content((0.5em, 0.5em), symbol)
			content((-0.5em, -0.5em), angle: 180deg, symbol)
			content((0.5em, -0.5em), angle: 180deg, symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)

		// NINE
		} else if rank-id == "nine" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((-0.5em, 0.55em), symbol)
			content((0.5em, 0.55em), symbol)
			content((0, 0), symbol)
			content((-0.5em, -0.55em), angle: 180deg, symbol)
			content((0.5em, -0.55em), angle: 180deg, symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)

		// TEN
		} else if rank-id == "ten" {
			content((-0.5em, 1.5em), symbol)
			content((0.5em, 1.5em), symbol)
			content((0em, 1em), symbol)
			content((-0.5em, 0.5em), symbol)
			content((0.5em, 0.5em), symbol)
			content((-0.5em, -1.5em), angle: 180deg, symbol)
			content((0.5em, -1.5em), angle: 180deg, symbol)
			content((0em, -1em), angle: 180deg, symbol)
			content((-0.5em, -0.5em), angle: 180deg, symbol)
			content((0.5em, -0.5em), angle: 180deg, symbol)

		// JACK
		} else if rank-id == "jack" {
			draw-symmetric-figure-canvas(emoji.person.sassy, symbol)

		// QUEEN
		} else if rank-id == "queen" {
			draw-symmetric-figure-canvas(emoji.woman.crown, symbol)

		// KING
		} else if rank-id == "king" {
			draw-symmetric-figure-canvas(emoji.man.crown, symbol)

		// otherwise
		} else {
			content((0,0), [$emptyset$])
		}
	
	})
}