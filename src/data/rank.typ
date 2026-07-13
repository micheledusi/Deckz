// rank.typ

#import "import.typ": *

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
    e.field("order", int, 
      doc: "A number indicating in which order the rank should be placed, with respect to the other ranks in the deck. This is automatically initialized by the library, according to the order in which ranks are defined, starting from 1 for the first rank of the list.",
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

    // Order argument
    let arg-order = args.pos().at(1)

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
    } else {
      arg-code = str(arg-code)
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

    // Score argument
    let arg-score = args.named().at("score", default: auto)
    if arg-score == auto {
      arg-score = arg-order
    }

    default-constructor(
      arg-id,
      arg-order,
      ..args.pos().slice(2),
      name: arg-name, 
      code: arg-code, 
      symbol: arg-symbol,
      score: arg-score,
      ..args.named(),
    )
  },

  display: it => [#it.symbol],
)

/// A function composing a ranks dictionary, usable specifically with Deckz.
/// The input could be either a raw-data dictionary (for example, read from an external file) or the ID of a predetermined deck style.
/// 
/// -> dictionary
#let build-ranks-dict(
  /// The input data for the ranks to be built.
  /// It could be either an ID (a string) or a dictionary of raw data.
  /// 
  /// -> str | dictionary
  data: auto,
) = {
  if data == auto {
    data = "default"
  }
  // If the input data is a string, we assume it's one of the predetermined styles. Therefore, we look for the corresponding file.
  if type(data) == str {
    data = yaml(decks-dir + data + "/ranks.yaml")
  }
  // Finally, we check if the data is a dictionary
  if type(data) == dictionary {
    // Maps the ranks in the file with the rank constructor
    return data.pairs().enumerate(start: 1).map(((i, (k, v))) => {
      // For each entry (order, (key, values))
      // a new `rank` is "built" with the rank constructor
      (k, rank(k, i, ..v))
    }).to-dict()
  } else {
    error("Something in the ranks definition cannot be interpreted as a dictionary. Please, verify if the file containes a dictionary, and NOT an array or other data structures. The type currently read is: " + type(data))
  }
}

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
#let ranks = build-ranks-dict()
