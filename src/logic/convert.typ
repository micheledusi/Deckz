// convert.typ
// Utility functions for converting card codes to data and vice versa.

#import "../data/suit.typ": *
#import "../data/rank.typ": *
#import "../data/style.typ": *

/// Get the card code for a given suit and rank.
/// 
/// The suit is given as a key from the `suits` dictionary, and the rank as a key from the `ranks` dictionary.
/// 
/// The resulting code is a string in the format "<rank><suit>", where `<rank>` is the rank symbol and `<suit>` is the first letter of the suit key in uppercase.
/// 
/// For example, if the suit is "heart" and the rank is "A", the resulting code will be "AH".
/// ```side-by-side
/// #deckz.get-card-code("heart", "ace") // Returns "AH"
/// #deckz.get-card-code("spade", "king") // Returns "KS"
/// #deckz.get-card-code("diamond", "ten") // Returns "10D"
/// #deckz.get-card-code("club", "three") // Returns "3C"
/// ```
/// 
/// -> string
#let get-card-code(suit-key, rank-key) = {
  ranks.at(rank-key).code + suits.at(suit-key).code
}


/// This function takes the code for a card and returns the corresponding data about its suit, color, and rank.
/// For example, if the input is "AH", the output will be a dictionary containing the suit `"heart"`, color `"red"`, rank `"ace"`, and other related properties from the `suits` and `ranks` dictionaries.
/// 
/// -> dictionary
#let extract-card-data(card-code) = {
  let card-data = (:)
  if card-code == ranks.joker.code {
    card-code += suits.club.code
  }
  for (suit-key, suit-data) in suits.pairs() {
    if upper(card-code.at(-1)) == suit-data.code {
      card-data.suit = suit-key
      for (k, v) in suit-data.pairs() {
        card-data.insert("suit-" + k, v)
      }
      break
    }
  }
  for (rank-key, rank-data) in ranks.pairs() {
    if type(card-code) == str and card-code.starts-with(rank-data.code) {
      card-data.rank = rank-key
      for (k, v) in rank-data.pairs() {
        card-data.insert("rank-" + k, v)
      }
      break
    }
  }
  if not "suit" in card-data {
    card-data.suit = none
  }
  if not "rank" in card-data {
    card-data.rank = none
  }
  if card-data.rank == "joker" {
    card-data.rank-symbol = sym.star.filled
    card-data.suit-symbol = "\u{2003}"
  }
  return card-data
}

/// This function converts the mixed input cards to a uniform array of card specifiers in dictionary form.
/// The input can be a mix of strings (card codes) and dictionaries (card specifiers). 
/// The output is an array of dictionaries, where each dictionary has at least an "id" property (the card code).
/// Other properties that can be included are:
/// - `outjogged`: a boolean or float value indicating whether the card should be displayed with a vertical shift (outjogged). Default is #false | #`none`.
/// - (more properties can be added in the future as needed)
/// 
/// If an input cannot be parsed as a valid card specifier, it will be skipped.
/// 
/// -> array(dictionary)
#let convert-card-inputs-to-dict-specifiers(card-inputs) = {
  // Initialize an empty array to hold the card specifiers
  let card-specifiers = ()
  // Setup the default properties for the card specifier
  let specifier-defaults = (
    outjogged: none,
  )

  for card in card-inputs {
    let specifier = specifier-defaults

    if type(card) == str {
      // If the input is a string, we add it as the "id" property in the specifier
      specifier += (id: card,)
    }
    else if type(card) == dictionary {
      // If the input is a dictionary, we check if it has an "id" property and add it to the specifier
      if not "id" in card {
        continue
      }
      specifier += card
    }
    else {
      // If the input is neither a string nor a dictionary, skip it
      continue
    }
    card-specifiers.push(specifier)
  }
  return card-specifiers
}


#import "@preview/digestify:0.1.0": sha256 // Hashing library, used to create a seed from the cards

/// Generate a seed based on the card values.
/// -> int
#let get-seed-from-cards(
  /// An array of cards to generate a seed from.
  /// -> array
  cards,
) = {
  // Generate a seed based on the card values
  return int(array(sha256(bytes(cards.join()))).sum())
}
