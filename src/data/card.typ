// card.typ

#import "import.typ": *
#import "rank.typ": rank, ranks
#import "suit.typ": suit, suits
#import "format.typ": format-parameters
#import "../view/render.typ": render-card

#let card = e.element.declare(
  "Card",

  prefix: elembic-namespace, 

  doc: "The data structure representing a card in Deckz, identified by a rank and a suit.",

	fields: (
    e.field("code", e.types.option(e.types.union(str, e.types.literal("back"))),
      doc: "The code of the card, identifying its rank (first) and suit (second). This is a required field, meaning that it must be provided when using this function.
      The value which can also be `none`, which produces an empty card, and the literal value \"back\", producing the back of the cards.",
      required: true,
    ),
    e.field("rank", rank, 
      doc: "The rank of the card, e.g. Two, King, Ace, Nine, ... The rank is represented as a custom element `rank`.",
      synthesized: true,
      default: none,
    ),
    e.field("suit", suit, 
      doc: "The suit of the card, e.g. Hearts, Diamonds, Clubs, Spades. The suit is represented as a custom element `suit`.",
      synthesized: true,
      default: none,
    ),
		e.field("format", 
      e.types.union(..format-parameters.keys().slice(1).map(it => e.types.literal(it))), // Note: we remove the first element "default" from the format list
      doc: "The format of the card, i.e. its size and composition. This parameter accepts values from a specific list: " + format-parameters.keys().slice(1).join(),
      required: false,
      named: true,
      default: "medium",
    ),
    e.field("width", length, // TODO check if necessary, might delete it
      doc: "The width of the card. This is derived from the card format.",
      synthesized: true,
      default: none,
    ),
    e.field("height", length, // TODO check if necessary, might delete it
      doc: "The height of the card. This is derived from the card format.",
      synthesized: true,
      default: none,
    ),
    e.field("fill", e.types.paint,
      doc: "The main background color of the card.",
      required: false,
      named: true,
      default: aqua.lighten(90%),
    ),
    e.field("stroke", stroke,
      doc: "The stroke style of the card.",
      required: false,
      named: true,
      default: gray.mix(aqua).darken(50%) + 1pt,
    ),
    e.field("back-tiling", str,
      doc: "The path to the image used to tile the back of the card.",
      required: false,
      named: true,
      default: "../../res/decks/default/back.svg" // TODO FIXME better implementation
    ),
	),

	construct: default-constructor => (..args) => {
    // TODO FIXME
		default-constructor(..args)
	},

  synthesize: it => {
    // Rank and suit
    it.rank = none
    it.suit = none
    // We exclude the cases "empty" and "back"
    if it.code != none and it.code != "back" {
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
    }

    // Dimensions: width and height
    it.width = format-parameters.at(it.format).width
    it.height = format-parameters.at(it.format).height

    it
  },

	display: it => {
    render-card(it)
	},
)