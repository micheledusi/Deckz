#import "../src/lib.typ" as deckz

//#set text(font: "Roboto Slab")

#let (w, h) = (10cm, 10cm)
#box(width: w, height: h, 
	fill: olive, 
	stroke: olive.darken(50%) + 2pt,
)[
	#deckz.heap(format: "small", width: w, height: h, ..deckz.deck52)
]