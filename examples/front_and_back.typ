#import "/src/lib.typ" as deckz

= What's behind a card?
Here are some renderings of cards' back.

#deckz.back(format: "square")
#h(1fr)
#deckz.back(format: "large")
#h(1fr)
#deckz.back(format: "medium")
#h(1fr)
#deckz.back(format: "small")
#h(1fr)
#deckz.back(format: "mini")
#h(1fr)
#deckz.back(format: "inline")

#v(2em)

#align(center)[
	#deckz.hand("3C", "4C", "5C", "back", "7C")

	#deckz.deck("back", noise: 1.5) #deckz.render("AC") #deckz.render("8C")
]