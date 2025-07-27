// suit.typ

/// A mapping of all suit symbols utilized in DECKZ.
/// Primarily intended for internal use within higher-level functions,
/// but can also be accessed directly, for example, to iterate over the four suits.
/// 
/// ```side-by-side
/// #for (suit, symbol) in deckz.suits.pairs() [
///   - #suit: #symbol 
/// ]
/// ```
#let suits = (
  "heart": emoji.suit.heart,
  "spade": emoji.suit.spade,
  "diamond": emoji.suit.diamond,
  "club": emoji.suit.club,
)
