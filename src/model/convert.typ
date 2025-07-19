#import "../data/suit.typ": *
#import "../data/number.typ": *
#import "../data/style.typ": *

// Utility conversion functions

// Get the card string code, given the suit and number
#let get-card-code(suit-key, number-key) = {
  numbers.at(number-key) + upper(suit-key.at(0))
}


// Takes the code for a card and returns the corresponding data about its suit, color, and number.
#let extract-card-data(card-code) = {
  let my-suit = none
  for (curr-suit, _) in suits {
    if lower(card-code.at(-1)) == curr-suit.at(0) {
      my-suit = curr-suit
    }
  }
  let my-number = none
  for (curr-number, number-symbol) in numbers {
    if upper(card-code.slice(0, -1)) == number-symbol {
      my-number = curr-number
    }
  }
  return (
    suit: my-suit,
    color: suits-colors.at(my-suit),
    number: my-number,
  )
}