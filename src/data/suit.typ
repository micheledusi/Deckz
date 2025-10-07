// suit.typ

#import "import.typ": *

#let suit = e.element.declare(
  "Suit",

  prefix: elembic-namespace, 

  doc: "The data structure representing a suit in Deckz.",

  // The fields that this element contains.
  // Accessible later through `e.fields(my-suit-var).field-name`.
  fields: (
    e.field("name", str, 
      doc: "The name of the suit.", 
      required: true,
    ),
    e.field("code", e.types.smart(str), 
      doc: "The code used to identify the suit when used in the card abbreviations.",
      required: false,
      named: true, 
      default: auto,
    ),
    e.field("symbol", e.types.union(str, symbol), 
      doc: "The suit icon, i.e. the string or symbol that's used to represent this suit in the game cards.", 
      required: true,
      named: true,
    ),
    e.field("fill", e.types.paint, 
      doc: "The suit main color.",
      required: false,
      named: true,
      default: black,
    ),
    // This might be deleted, depending on whether we are able to sort suits without it.
    e.field("order", e.types.smart(int), 
      doc: "A number indicating in which order the suit should be placed, with respect to the other suits in the deck.",
      required: false,
      named: true, 
      default: auto,
    ),
  ),  

  construct: default-constructor => (..args) => {
    let it = if args.named().at("code", default: auto) == auto {
      let code-arg = upper(args.pos().at(0).slice(0, 1))
      default-constructor(..args, code: code-arg)
    } else {
      default-constructor(..args)
    }
    it
  },

  // Default show rule: how this element displays itself.
  display: it => {
    box[
      #text(it.symbol, fill: it.fill)
    ]
  },
)

/// A mapping of all *suit symbols* utilized in DECKZ.
/// 
/// Primarily intended for internal use within higher-level functions,
/// but can also be accessed directly, for example, to iterate over the four suits.
/// 
/// ```side-by-side
/// #stack(
///   dir: ltr,
///   spacing: 1em,
///   ..deckz.suits.values().map(suit-data => {
///     text(suit-data.color)[#suit-data.symbol]
///   })
/// )
/// ```
/// 
/// -> dictionary
#let suits = (
  heart: suit(
    "heart",
    symbol: emoji.suit.heart,
    fill: red,
    order: 1,
  ),
  diamond: suit(
    "diamond",
    symbol: emoji.suit.diamond,
    fill: red,
    order: 2,
  ),
  club: suit(
    "club",
    symbol: emoji.suit.club,
    order: 3,
  ),
  spade: suit(
    "spade",
    symbol: emoji.suit.spade,
    order: 4,
  ),
)