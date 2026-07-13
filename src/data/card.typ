// card.typ

#import "import.typ": *
#import "rank.typ": rank, ranks
#import "suit.typ": suit, suits

#let card = e.element.declare(
  "Card",

  prefix: elembic-namespace, 

  doc: "The data structure representing a card in Deckz, identified by a rank and a suit.",

	fields: (
    e.field("code", e.types.option(str),
      doc: "The code of the card, identifying its rank and suit. This is a required, optional field, meaning that it must be provided a value which can also be `none`, for the back of the cards.",
      required: true,
    ),
    e.field("rank", rank, 
      doc: "The rank of the card, e.g. Two, King, Ace, Nine, ... The rank must be specified as a custom element `rank`.",
      synthesized: true,
      default: none,
    ),
    e.field("suit", suit, 
      doc: "The suit of the card, e.g. Hearts, Diamonds, Clubs, Spades. The suit must be specified as a custom element `suit`.",
      synthesized: true,
      default: none,
    ),
		//e.field("size", e.types.)
	),

	construct: default-constructor => (..args) => {
    // TODO FIXME
		default-constructor(..args)
	},

  synthesize: it => {
    it.rank = none
    it.suit = none
    if it.code == none {
      return it
    }
    // We extract the rank and suit from the card code
    for r in ranks.values() {
      let r-code = e.fields(r).code
      // If the rank code does not correspond
      if not it.code.starts-with(r-code) {
        // We skip to the next rank code, even without checking the suits
        continue
      } else {
        // If the rank code matches
        // we check the suits
        for s in suits.values() {
          let s-code = e.fields(s).code
          if it.code == r-code + s-code {
            it.rank = r
            it.suit = s
            break
          }
        }
        if it.suit != none {
          break
        }
      }
    }
    it
  },

	display: it => {
		[#it.rank#it.suit]
	},
)