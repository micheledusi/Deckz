#import "card.typ": *

// Shows an array of cards as a hand, one next to the other.
#let show-hand(mode: "mini", angle: 90deg, ..cards) = {
	let cards-array = cards.pos()
	let angle-shift = angle / (cards-array.len() -1)
	let angle-start = -angle / 2
	let cards-views = cards-array.enumerate().map(pair => {
		let i = pair.at(0)
		let card = pair.at(1)
		move(
			dy: 0em, 
			rotate(
				angle-start + i * angle-shift,
				origin: center + bottom,
				reflow: false,
				box(stroke: 0pt, [#show-card-small(card)#v(10em)]),
			)
		)
		}
	)
	stack(
		dir: ltr,
		spacing: -2em,
		..cards-views
	)
}