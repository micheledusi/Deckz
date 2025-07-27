// structs.typ
/// This file contains some utility structs, already filled with data from the package.

#import "../data/suit.typ": *
#import "../data/rank.typ": *
#import "convert.typ": *


/// This is a dictionary of all the cards in a deck.
/// It is structured as `cards.<suit>.<rank>`, where `<suit>` is one of the keys from the `suits` dictionary, and `<rank>` is one of the keys from the `ranks` dictionary.
/// The value associated with each rank-suit pair is the card code, which is a string in the format "<rank><suit>", where `<rank>` is the rank symbol and `<suit>` is the first letter of the suit key in uppercase.
/// 
/// ```side-by-side
/// #deckz.cards52.heart.ace // Returns "AH"
/// #deckz.cards52.spade.king // Returns "KS"
/// #deckz.cards52.diamond.ten // Returns "10D"
/// #deckz.cards52.club.three // Returns "3C"
/// ```
/// 
/// -> dict
#let cards52 = (:)
#for (suit, suit-symbol) in suits {
  cards52.insert(suit, (:))
  for (rank, rank-symbol) in ranks {
    cards52.at(suit).insert(rank, get-card-code(suit, rank))
  }
}

/// A list of all the cards in a standard deck of 52 playing cards.
/// It is a _flat_ list of *card codes*, where each code is a string in the format `<rank><suit>`, where `<rank>` is the rank symbol and `<suit>` is the first letter of the suit key in uppercase.
/// It is created programmatically from the `suits` and `ranks` dictionaries.
/// 
/// ```side-by-side
/// #table(
///   columns: 13, 
///   align: center,
///   stroke: none,
///  ..deckz.deck52,
/// )
/// ```
/// 
/// -> array
#let deck52 = ()
#for (suit, suit-symbol) in suits {
  for (rank, rank-symbol) in ranks {
    deck52.push(get-card-code(suit, rank))
  }
}