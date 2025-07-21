#import "../src/lib.typ" as deckz

#set page(margin: 0.5in, fill: gray.lighten(60%))
#set table(stroke: 1pt + white, fill: white)
#set text(font: "Roboto Slab")

= A Handful or Cards

#lorem(120)

#align(center)[
	#deckz.deck(angle: 60deg, "AS")
	#deckz.hand(angle: 20deg, width: 8cm, "AC", "KC", "QC", "AD", "3H")
]

#lorem(120)
