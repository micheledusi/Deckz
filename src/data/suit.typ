// suit.typ

#import "import.typ": *

#let suit = e.element.declare(
  "Suit",

  prefix: elembic-namespace, 

  doc: "The data structure representing a suit in Deckz.",

  // The fields that this element contains.
  // Accessible later through `e.fields(my-suit-var).field-name`.
  fields: (
    e.field("id", str, 
      doc: "The identifier of the suit, used for internal references.",
      required: true,
    ),
    e.field("order", int, 
      doc: "A number indicating in which order the suit should be placed, with respect to the other suits in the deck. This is automatically initialized by the library, according to the order in which suits are defined, starting from 1 for the first suit of the list.",
      required: true,
    ),
    e.field("code", e.types.smart(str), 
      doc: "The code used to identify the suit when used in the card abbreviations. If not provided, it defaults to the first character of the ID, uppercased.",
      required: false,
      named: true, 
      default: auto,
    ),
    e.field("name", e.types.smart(e.types.union(str, content)), 
      doc: "The name of the suit, e.g. 'Hearts', 'Diamonds', 'Clubs', or 'Spades'. If not provided, it looks for a linguified version in the language database, and if not found, it defaults to the rank id, capitalized. The name is preferred to be a plural noun.", 
      required: false,
      named: true, 
      default: auto,
    ),
    e.field("symbol", e.types.union(str, symbol), 
      doc: "The suit icon, i.e. the string or symbol that's used to represent this suit in the game cards.", 
      required: true,
      named: true,
    ),
    e.field("color", e.types.smart(e.types.paint), 
      doc: "The suit main color.",
      required: false,
      named: true,
      default: black,
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

    default-constructor(
      arg-id,
      arg-order,
      ..args.pos().slice(2),
      name: arg-name, 
      code: arg-code, 
      symbol: arg-symbol,
      ..args.named(),
    )
  },

  // Default show rule: how this element displays itself.
  display: it => {
    box[
      #text(it.symbol, fill: it.color)
    ]
  },
)

/// A function composing a suits dictionary, usable specifically with Deckz.
/// The input could be either a raw-data dictionary (for example, read from an external file) or the ID of a predetermined deck style.
/// 
/// -> dictionary
#let build-suits-dict(
  /// The input data for the suits to be built.
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
    data = yaml(decks-dir + data + "/suits.yaml")
  }
  // Finally, we check if the data is a dictionary
  if type(data) == dictionary {
    // We map the suits in the file with the suit constructor
    return data.pairs().enumerate(start: 1).map(((i, (k, v))) => {
      // For each entry (order, (key, values))
      // We handle the color field here, before passing it to elembic. This is needed because I want the color field to be exclusively `color`, not a Typst string. 
      let c = v.at("color", default: auto)
      if type(c) == str {
        if c.match(regex-hex-color) != none {
          // If the string is a color HEX specification
          c = rgb(c)
        } else if c.match(regex-gradient) != none {
          // If the string is a Typst gradient
          c = eval(c)
        } else {
          // BAD. This is evaluating arbitrary code. I did this because I want to parse colors from file.
          // TODO FIXME
          panic("Something in the color definition is wrong. The string " + c + " cannot be interpreted as a color. Please use only HEX colors or gradients. This will be fixed soon, hopefully.")
        }
      }
      v.at("color") = c
      // A new `suit` is "built" with the suit constructor
      (k, suit(k, i, ..v))
    }).to-dict()
  } else {
    error("Something in the suits definition cannot be interpreted as a dictionary. Please, verify if the file containes a dictionary, and NOT an array or other data structures. The type currently read is: " + type(data))
  }
}

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
#let suits = build-suits-dict()