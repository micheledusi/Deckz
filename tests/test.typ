#import "../src/data/rank.typ": *
#import "../src/data/suit.typ": *

#set text(lang: "en")

#show: e.set_(suit, symbol: emoji.abacus)

#for suit in suits.values() {
	for rank in ranks.values() [
		#rank#suit -- 
	]
}