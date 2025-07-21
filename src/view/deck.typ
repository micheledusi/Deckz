#import "format.typ": *

#import cetz: draw

// Shows an array of cards as a hand, one next to the other.
#let render-hand(angle: 45deg, width: 10cm, format: "medium", ..cards) = {
	let cards-array = cards.pos()
	let angle-shift = angle / (cards-array.len() -1)
	let angle-start = -angle / 2
	let radius = (width) / (2 * calc.sin(angle / 2))
	cetz.canvas({
		draw.rotate(z: -angle-start)
		for i in range(cards-array.len()) {
			content((0, radius),
				rotate(
					angle-start + i * angle-shift,
					reflow: true,
					origin: center + horizon,
					render(format: format, cards-array.at(i))
				)
			)
			draw.rotate(z: -angle-shift)
		}
	})
}

#let render-deck(angle: 60deg, height: 1cm, format: "medium", top-card) = {
	let num-cards = int(height / 2.5pt)
	let shift-x = height * calc.cos(angle) / num-cards
	let shift-y = height * calc.sin(angle) / num-cards
	cetz.canvas({
		for i in range(num-cards) {
			content((shift-x * i, shift-y * i), render(format: format, top-card))
		}
	})
}