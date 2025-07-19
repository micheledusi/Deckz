#import "../src/lib.typ": *

#set page(margin: 0.5in, fill: gray.lighten(60%))
#set table(stroke: 1pt + white, fill: white)
#set text(font: "Arvo")

= Comparison Table

== #text(blue)[`inline`]
A minimal format where the rank and suit are displayed directly within the flow of text -- perfect for quick references.
#table(align: center, columns: (1fr,) * 4, 
	show-card-inline("AS"),
	show-card-inline("5H"),
	show-card-inline("10C"),
	show-card-inline("QD")
)

== #text(blue)[`mini`] 
The smallest visual format: a compact rectangle showing the rank at the top and the suit at the bottom.
#table(align: center, columns: (1fr,) * 4, 
	show-card-mini("AS"),
	show-card-mini("5H"),
	show-card-mini("10C"),
	show-card-mini("QD")
)

== #text(blue)[`small`]
A slightly larger card with rank indicators on opposite corners and a central suit symbol -- ideal for tight layouts with better readability.
#table(align: center, columns: (1fr,) * 4, 
	show-card-small("AS"),
	show-card-small("5H"),
	show-card-small("10C"),
	show-card-small("QD")
)

== #text(blue)[`medium`]
A fully structured card layout featuring proper suit placement and figures. Rank and suit appear in two opposite corners, offering a realistic visual.
#table(align: center, columns: (1fr,) * 4, 
	show-card-medium("AS"),
	show-card-medium("5H"),
	show-card-medium("10C"),
	show-card-medium("QD")
)

== #text(blue)[`large`]
The most detailed format, with corner summaries on all four corners and an expanded layout -- great for presentations or printable decks.
#table(align: center, columns: (1fr,) * 4, 
	show-card-large("AS"),
	show-card-large("5H"),
	show-card-large("10C"),
	show-card-large("QD")
)

== #text(blue)[`square`]
A balanced 1:1 card format with rank and suit shown in all four corners and a central figure -- designed for symmetry and visual clarity.
#table(align: center, columns: (1fr,) * 4, 
	show-card-square("AS"),
	show-card-square("5H"),
	show-card-square("10C"),
	show-card-square("KD")
)
