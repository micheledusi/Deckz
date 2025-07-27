// rank.typ

/// A mapping of all rank symbols utilized in DECKZ.
/// Primarily intended for internal use within higher-level functions, but can also be accessed directly, for example, to iterate over the ranks.
/// 
/// ```side-by-side
/// #for (rank, symbol) in deckz.ranks.pairs() [
///   - #rank: #symbol
/// ]
/// ```
#let ranks = (
  "ace": "A",
  "two": "2",
  "three": "3", 
  "four": "4",
  "five": "5", 
  "six": "6", 
  "seven": "7", 
  "eight": "8", 
  "nine": "9", 
  "ten": "10", 
  "jack": "J", 
  "queen": "Q", 
  "king": "K",
)