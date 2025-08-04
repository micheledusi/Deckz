#import "../../src/lib.typ" as deckz

#let hand = deckz.choose(deckz.deck52, n: 8, replacement: false, permutation: true)
#let shuffled-hand = deckz.shuffle(hand)

#deckz.hand( 
	format: "medium", 
	noise: 0.35, 
	..shuffled-hand
)

== Check hands

#table(
	columns: 3,
	[],
	[`has-X`],
	[`is-X`],
	[High card:], 
	[#deckz.has-high-card(hand)], 
	[#deckz.is-high-card(hand)],
	[Pair:],
	[#deckz.has-pair(hand)],
	[#deckz.is-pair(hand)],
	[Two pair:],
	[#deckz.has-two-pairs(hand)],
	[#deckz.is-two-pairs(hand)],
	[Three of a kind:],
	[#deckz.has-three-of-a-kind(hand)],
	[#deckz.is-three-of-a-kind(hand)],
	[Straight:],
	[#deckz.has-straight(hand)],
	[#deckz.is-straight(hand)],
	[Flush:],
	[#deckz.has-flush(hand)],
	[#deckz.is-flush(hand)],
	[Full house:],
	[#deckz.has-full-house(hand)],
	[#deckz.is-full-house(hand)],
	[Four of a kind:],
	[#deckz.has-four-of-a-kind(hand)],
	[#deckz.is-four-of-a-kind(hand)],
	[Straight flush:],
	[#deckz.has-straight-flush(hand)],
	[#deckz.is-straight-flush(hand)],
	[Five of a kind:],
	[#deckz.has-five-of-a-kind(hand)],
	[#deckz.is-five-of-a-kind(hand)],
)

== Extract hands

#let hand-2 = ("8S", "9S", "10S", "JS", "QS", "9H", "9D", "9C", "QD", "3D", "4D", "5D").sorted()

My hand: #hand-2.map(deckz.mini).join([#h(3pt)])

Which *pair* can I make?
#for combination in deckz.extract-pair(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *two pairs* can I make?
#for combination in deckz.extract-two-pairs(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *three-of-a-kind* can I make?
#for combination in deckz.extract-three-of-a-kind(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *straight* can I make?
#for combination in deckz.extract-straight(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *flush* can I make?
#for combination in deckz.extract-flush(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *full house* can I make?
#for combination in deckz.extract-full-house(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *four of a kind* can I make?
#for combination in deckz.extract-four-of-a-kind(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *straight flush* can I make?
#for combination in deckz.extract-straight-flush(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]

Which *five of a kind* can I make?
#for combination in deckz.extract-five-of-a-kind(hand-2) [
	+ #combination.map(deckz.inline).join([#h(3pt)])
]


== Sorting

#let heads = (
	deckz.sort(deckz.deck52),
	deckz.sort(deckz.deck52, by: "score"),
	deckz.sort(deckz.deck52, by: "order"),
	deckz.sort(deckz.deck52, by: deckz.score-comparator),
	deckz.sort(deckz.deck52, by: deckz.order-comparator),
)

#heads.map((head) => {
	deckz.hand(
		format: "mini",
		width: 12cm,
		angle: 0deg,
		..head.slice(0, 24)
	)
}).join()

#pagebreak()

= Split deck

#let (hands, market) = deckz.split(deckz.deck52, size: ((4, 2), 5), rest: false)

_Players' hands:_
#for hand in hands [
	+ #deckz.hand(
		format: "mini",
		width: 1cm,
		angle: 0deg,
		..hand
	)
]

_Central market:_
#deckz.hand(
	format: "mini",
	width: 4cm,
	angle: 0deg,
	..market
)
