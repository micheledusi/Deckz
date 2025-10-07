// rank.typ

#import "import.typ": *
#import "style.typ": title-case

#import "@preview/linguify:0.4.2": *

#let lang-data = toml("lang.toml")

#let rank = e.element.declare(
  "Rank",

  prefix: elembic-namespace,

  doc: "The data structure representing a rank in Deckz.",

  // The fields that this element contains.
  // Accessible later through `e.fields(my-rank-var).field-name`.
  fields: (
    e.field("id", str, 
      doc: "The identifier of the rank, used for internal references.",
      required: true,
    ),
    e.field("code", e.types.smart(str), 
      doc: "The code used to identify the rank when used in the card abbreviations. If not provided, it defaults to the first character of the ID, uppercased.",
      required: false,
      named: true, 
      default: auto,
    ),
    e.field("name", e.types.smart(e.types.union(str, content)), 
      doc: "The name of the rank, e.g. 'Ace', 'Two', 'Three', etc. If not provided, it looks for a linguified version in the language database, and if not found, it defaults to the rank id, capitalized.", 
      required: false,
      named: true, 
      default: auto,
    ),
    e.field("symbol", e.types.smart(e.types.union(str, symbol, content)), 
      doc: "The rank icon, i.e. the string or symbol that's used to represent this rank in the game cards. The symbol is optional; if not provided, the package will search for a correspondence in the language database, and if not found, it will default to the rank code.", 
      required: false,
      named: true,
      default: auto,
    ),
    // This might be deleted, depending on whether we are able to sort ranks without it. If we are able to retrieve the order from the rank list position, then this field is not needed.
    e.field("order", e.types.smart(int), 
      doc: "A number indicating in which order the rank should be placed, with respect to the other ranks in the deck.",
      required: false,
      named: true, 
      default: auto,
    ),
    e.field("score", e.types.smart(int), 
      doc: "A number indicating the score value of this rank, when used in scoring functions. If not provided, it defaults to the order value.",
      required: false,
      named: true, 
      default: auto,
    ),
  ),

  construct: default-constructor => (..args) => {
    // ID argument
    let arg-id = lower(args.pos().at(0))

    // Name argument
    let arg-name = args.named().at("name", default: auto)
    if arg-name == auto {
      arg-name = linguify(
        arg-id + "-name", 
        from: lang-data, 
        default: str(title-case(arg-id)),
      )
    }

    // Code argument
    let arg-code = args.named().at("code", default: auto)
    if arg-code == auto {
      arg-code = upper(arg-id.slice(0, 1))
    }

    // Symbol argument
    let arg-symbol = args.named().at("symbol", default: auto)
    if arg-symbol == auto {
      arg-symbol = linguify(
        arg-id + "-symbol", 
        from: lang-data, 
        default: arg-code,
      )
    }

    // Order argument
    let arg-order = args.named().at("order", default: auto)
    if arg-order == auto {
      panic("The 'order' field is required for rank elements. Automatic assignment is not supported yet.")
    }

    // Score argument
    let arg-score = args.named().at("score", default: auto)
    if arg-score == auto {
      arg-score = arg-order
    }

    default-constructor(
      arg-id,
      ..args.pos().slice(1),
      name: arg-name, 
      code: arg-code, 
      symbol: arg-symbol,
      order: arg-order,
      score: arg-score,
      ..args.named(),
    )
  },

  display: it => [#it.symbol],
)

/// A mapping of all *rank symbols* utilized in DECKZ.
/// 
/// This dictionary is primarily intended for internal use within higher-level functions, but can also be accessed directly, for example, to iterate over the ranks.
/// 
/// ```side-by-side
/// #table(
///   columns: 5 * (1fr, ),
///   ..deckz.ranks.keys()
/// )
/// ```
/// 
/// -> dictionary
#let ranks = (
  ace: rank(
    "Ace",
    order: 1,
    score: 14,
  ),
  two: rank(
    "Two",
    code: "2",
    order: 2,
    score: 2,
  ),
  three: rank(
    "Three",
    code: "3",
    order: 3,
    score: 3,
  ),
  four: rank(
    "Four",
    code: "4",
    order: 4,
    score: 4,
  ),
  five: rank(
    "Five",
    code: "5",
    order: 5,
    score: 5,
  ),
  six: rank(
    "Six",
    code: "6",
    order: 6,
    score: 6,
  ),
  seven: rank(
    "Seven",
    code: "7",
    order: 7,
    score: 7,
  ),
  eight: rank(
    "Eight",
    code: "8",
    order: 8,
    score: 8,
  ),
  nine: rank(
    "Nine",
    code: "9",
    order: 9,
    score: 9,
  ),
  ten: rank(
    "Ten",
    code: "10",
    order: 10,
    score: 10,
  ),
  jack: rank(
    "Jack",
    order: 11,
    score: 11,
  ),
  queen: rank(
    "Queen",
    order: 12,
    score: 12,
  ),
  king: rank(
    "King",
    order: 13,
    score: 13,
  ),
)
