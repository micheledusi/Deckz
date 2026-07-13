// card.typ

#import "import.typ": *
#import "rank.typ": rank
#import "suit.typ": suit

#let card = e.element.declare(
  "Card",

  prefix: elembic-namespace, 

  doc: "The data structure representing a card in Deckz, identified by a rank and a suit.",

	fields: (
    e.field("rank", rank, 
      doc: "The rank of the card, e.g. Two, King, Ace, Nine, ... The rank must be specified as a custom element `rank`.",
      required: true,
    ),
    e.field("suit", suit, 
      doc: "The suit of the card, e.g. Hearts, Diamonds, Clubs, Spades. The suit must be specified as a custom element `suit`.",
      required: true,
    ),
		//e.field("size", e.types.)
	),

	construct: default-constructor => (..args) => {
		default-constructor(..args)
	},

	display: it => {
		[#it.rank#it.suit]
	},
)