#import "../src/data/rank.typ": ranks
#import "../src/data/suit.typ": suits
#import "../src/data/card.typ": card

#set text(lang: "en")

#for s in suits.values() {
	for r in ranks.values() [
		#card(r, s)
	]
}