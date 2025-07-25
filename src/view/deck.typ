#import "format.typ": *

#import cetz: draw

// Displays a sequence of cards in a horizontal hand layout.
// Optionally applies a slight rotation to each card, creating an arched effect.
//
// Parameters:
// - 'cards': Array of card elements to display.
// - 'angle': The angle between the first and last card, i.e. the angle covered by the arc.
// - 'width': The distance between the first and last card, i.e. the width of the hand representation.
// - 'noise': The amount of "randmness" in the placement and rotation of the card. Default value is "none" or "0", which corresponds to no variations. A value of 1 corresponds to a "standard" amount of noise, according to Deckz style. Higher values might produce crazy results, handle with care.
// - 'format': The cards rendering format. 
#let render-hand(angle: 30deg, width: 10cm, noise: none, format: "medium", ..cards) = {
	let cards-array = cards.pos()
	let (angle-start, angle-shift, radius, shift-x) = (0deg, 0deg, 0pt, 0pt)
	if angle == 0deg {
		shift-x = width / (cards-array.len() - 1)
	} else {
		angle-start = -angle / 2
		angle-shift = angle / (cards-array.len() - 1)
		radius = width / (2 * calc.sin(angle / 2))
	}
	// Handling randomness
	let variabilities = ()
  if noise != none and noise > 0 {
    let seed = int(noise * 1e9) + 42
    let rng = suiji.gen-rng-f(seed)
		(_, variabilities) = suiji.uniform-f(rng, low: 0, high: 1e-6, size: cards-array.len())
	}
	// Drawing canvas
	cetz.canvas({
		draw.rotate(z: -angle-start)
		for i in range(cards-array.len()) {
			// Compute noise for the current card visualization
			let card-noise = if noise == none or noise <= 0 {
				none
			} else {
				noise + variabilities.at(i, default: none)
			}
			// Draw content
			content((shift-x * i, radius),
				rotate(
					angle-start + i * angle-shift,
					reflow: true,
					origin: center + horizon,
					render(format: format, noise: card-noise, cards-array.at(i))
				)
			)
			draw.rotate(z: -angle-shift)
		}
	})
}


// Renders a stack of cards, as if they were placed one ontop of each other.
// Calculates the number of cards based on the given height, and spaces them evenly along the specified angle using trigonometric functions. Each card is rendered with a positional shift to create a fanned deck appearance.
// 
// Parameters:
// - 'top-card': The top card in the deck, with standard code representation.
// - 'angle': The angle (in degrees) at which the deck is fanned out. Default is 60deg.
// - 'height': The total height of the deck stack. Default is 1cm.
// - 'noise': The amount of "randmness" in the placement and rotation of the card. Default value is "none" or "0", which corresponds to no variations. A value of 1 corresponds to a "standard" amount of noise, according to Deckz style. Higher values might produce crazy results, handle with care.
// - 'format': The format or style to use for rendering each card. Default is "medium".
#let render-deck(angle: 60deg, height: 1cm, noise: none, format: "medium", top-card) = {
	let num-cards = calc.max(int(height / 2.5pt), 1)
	let shift-x = height * calc.cos(angle) / num-cards
	let shift-y = height * calc.sin(angle) / num-cards
	// Handling randomness
	let variabilities = ()
  if noise != none and noise > 0 {
    let seed = int(noise * 1e9) + 42
    let rng = suiji.gen-rng-f(seed)
		(_, variabilities) = suiji.uniform-f(rng, low: 0, high: 1e-6, size: num-cards)
	}
	cetz.canvas({
		for i in range(num-cards) {
			let card-noise = if noise == none or noise <= 0 {
				none
			} else {
				noise + variabilities.at(i, default: none)
			}
			content((shift-x * i, shift-y * i), render(format: format, noise: card-noise, top-card))
		}
	})
}

// Renders a heap of cards, randomly placed in the given area.
// 
// Parameters:
// - 'cards': the cards to display, with standard code representation. 
// 		The last cards are represented on top of the previous one, as the rendering follows the given order. 
// - 'width': the horizontal dimension of the area in which cards are placed.
// - 'height': the vertical dimension of the area in which cards are placed.
// - 'exceed': if true, allows cards to exceed the frame with the given dimensions. When the parameter is false, instead, cards placement considers a margin of half the card length on all four sides. This way, it is guaranteed that cards are placed within the specified frame size.
// - 'format': The format or style to use for rendering each card. Default is "medium".
// 
// *Note*: the final result might exceed the borders of the given area, because
// the contraint is applied to the cards' centers, not to their corners. 
#let render-heap(format: "medium", width: 10cm, height: 10cm, exceed: false, ..cards) = context {
	let num-cards = cards.pos().len()
	let card-w = format-parameters.at(format).width.to-absolute()
	let card-h = format-parameters.at(format).height.to-absolute()
	// Random values
	let rng = suiji.gen-rng-f(42)
	let (rng, rand-x) = suiji.uniform-f(rng, size: num-cards) 	// [0, 1)
	let (rng, rand-y) = suiji.uniform-f(rng, size: num-cards) 	// [0, 1)
	let (rng, shift-rot) = suiji.uniform-f(rng, low: 0, high: 360, size: num-cards) // [0°, 360°)
	cetz.canvas({
		for i in range(num-cards) {
			// Compute random angle
			let angle = shift-rot.at(i) * 1deg
			// If cannot exceed, compute the bounding box
			let (x, y) = (0, 0)
			if not exceed {
				let sin_angle = calc.abs(calc.sin(angle))
				let cos_angle = calc.abs(calc.cos(angle))
				let span-x = card-w * cos_angle + card-h * sin_angle
				let span-y = card-w * sin_angle + card-h * cos_angle
				x = rand-x.at(i) * (width - span-x) + (span-x / 2)
				y = rand-y.at(i) * (height - span-y) + (span-y / 2)
			} else {
				x = rand-x.at(i) * width
				y = rand-y.at(i) * height
			}
			// Render content
			content((x, y), 
				rotate(angle, origin: center + horizon, reflow: true)[
					//#box(width: card-w, height: card-h, stroke: 1pt)
					#render-card(format, cards.pos().at(i))
				]
			)
		}
	})
}