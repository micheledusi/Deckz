#import "../data/suit.typ": *
#import "../data/number.typ": *
#import "convert.typ": *

// Pre-prepared data structures

// Cards = a dictionary of all the cards in a deck.
// Structure: `cards.<suit>.<number>`
#let cards = (:)
#for (suit, suit-symbol) in suits {
  cards.insert(suit, (:))
  for (number, number-symbol) in numbers {
    cards.at(suit).insert(number, get-card-code(suit, number))
  }
}

// Deck list
// A list of codes for all the cards in a deck.
#let deck = ()
#for (suit, suit-symbol) in suits {
  for (number, number-symbol) in numbers {
    deck.push(get-card-code(suit, number))
  }
}