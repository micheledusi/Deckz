// src/model/score.typ
/// This file defines the functions to handle the scoring of hands of cards.

#import "convert.typ": *
#import "../data/rank.typ": *
#import "../data/suit.typ": *


// --- Utility functions for scoring

/// Get the count of each rank in the given cards.
/// This function returns a dictionary where the keys are the ranks and the values are the counts of how many times each rank appears in the provided cards.
/// 
/// -> dictionary
#let get-rank-count(
  /// The cards to check for rank counts. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
  /// If true, the function will add a zero count for ranks that do not appear in the cards. Default: false
  add-zero: false,
  /// If true, the function will also count cards that are not valid according to the `extract-card-data` function.
  /// This is useful for debugging or when you want to include all cards regardless of their validity
  /// Default: false
  /// -> bool
  allow-invalid: false,
) = {
  let rank-counts = if add-zero {
    // Initialize a dictionary with all ranks set to zero
    ranks.keys().map((rank) => (rank, 0)).to-dict()
  } else {
    (:) // Initialize an empty dictionary to count occurrences of each rank
  }
  for card in cards {
    let card-data = extract-card-data(card)
    let new-count = rank-counts.at(card-data.rank, default: 0) + 1
    rank-counts.insert(card-data.rank, new-count)
  }
  if none in rank-counts.keys() {
    if not allow-invalid {
      panic("Invalid card rank found in `get-rank-count` function: " + cards.join(", "))
      return none
    }
  }
  return rank-counts
}

/// For each rank, check if it is present in the given cards.
/// This function returns a dictionary where the keys are the ranks and the values are booleans indicating whether that rank is present in the provided cards.
/// This is more efficient than counting the ranks with the function @cmd:deckz:get-rank-count, as it only checks for presence and does not count occurrences.
/// 
/// -> dictionary
#let get-rank-presence(
  /// The cards to check for rank presence. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
  /// If true, the function will also count cards that are not valid according to the `extract-card-data` function. This will add one entry with the key `none` to the result if there are invalid cards.
  /// If false, the function will panic if it finds an invalid card, returning none.
  /// Default: false
  /// -> bool
  allow-invalid: false,
) = {
  let rank-presence = ranks.keys().map((rank) => (rank, false)).to-dict() // Initialize a dictionary with all ranks set to false
  if allow-invalid {
    rank-presence.insert(none, false) // Add an entry for invalid cards
  }
  // Check each card for its rank
  let remaining-ranks = rank-presence.len()
  for card in cards {
    let card-data = extract-card-data(card)
    if card-data.rank == none and not allow-invalid {
      panic("Invalid card rank found in `get-rank-presence` function: " + card)
      return none
    }
    if not rank-presence.at(card-data.rank, default: false) {
      rank-presence.insert(card-data.rank, true) // Set the rank to true if it is present
      remaining-ranks -= 1 // Decrease the count of remaining ranks
      if remaining-ranks == 0 {
        break // If all ranks are found, exit the loop early
      }
    }
  }
  return rank-presence
}

/// Get the count of each suit in the given cards.
/// This function returns a dictionary where the keys are the suits and the values are the counts of how many times each suit appears in the provided cards.
///
/// -> dictionary
#let get-suit-count(
  /// The cards to check for suit counts. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
  /// If true, the function will add a zero count for suits that do not appear in the cards. Default: false
  add-zero: false,
  /// If true, the function will also count cards that are not valid according to the `extract-card-data` function.
  /// This is useful for debugging or when you want to include all cards regardless of their validity
  /// Default: false
  /// -> bool
  allow-invalid: false,
) = {
  let suit-counts = if add-zero {
    // Initialize a dictionary with all suits set to zero
    suits.keys().map((suit) => (suit, 0)).to-dict()
  } else {
    (:) // Initialize an empty dictionary to count occurrences of each suit
  }
  for card in cards {
    let card-data = extract-card-data(card)
    let new-count = suit-counts.at(card-data.suit, default: 0) + 1
    suit-counts.insert(card-data.suit, new-count)
  }
  if none in suit-counts.keys() {
    if not allow-invalid {
      panic("Invalid card suit found in `get-suit-count` function: " + cards.join(", "))
      return none
    }
  }
  return suit-counts
}

/// For each suit, check if it is present in the given cards.
/// This function returns a dictionary where the keys are the suits and the values are booleans indicating whether that suit is present in the provided cards.
/// This is more efficient than counting the suits with the function @cmd:deckz:get-suit-count, as it only checks for presence and does not count occurrences.
///
/// -> dictionary
#let get-suit-presence(
  /// The cards to check for suit presence. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
  /// If true, the function will also count cards that are not valid (i.e. whose rank symbol does not correspond to any of the known ranks). This will add one entry with the key `none` to the result if there are invalid cards.
  /// If false, the function will panic if it finds an invalid card, returning none.
  /// Default: false
  /// -> bool
  allow-invalid: false,
) = {
  let suit-presence = suits.keys().map((suit) => (suit, false)).to-dict() // Initialize a dictionary with all suits set to false
  if allow-invalid {
    suit-presence.insert(none, false) // Add an entry for invalid cards
  }
  // Check each card for its suit
  let remaining-suits = suit-presence.len()
  for card in cards {
    let card-data = extract-card-data(card)
    if card-data.suit == none and not allow-invalid {
      panic("Invalid card suit found in `get-suit-presence` function: " + card)
      return none
    }
    if not suit-presence.at(card-data.suit, default: false) {
      suit-presence.insert(card-data.suit, true) // Set the suit to true if it is present
      remaining-suits -= 1 // Decrease the count of remaining suits
      if remaining-suits == 0 {
        break // If all suits are found, exit the loop early
      }
    }
  }
  return suit-presence
}


// --- Functions to assess a hand of cards

/// Check if the given cards contain n-of-a-kind.
/// n-of-a-kind is defined as having at least `n` cards of the same rank
/// 
/// -> bool
#let has-n-of-a-kind(
  /// The cards to check for n-of-a-kind. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of cards that must have the same rank to count as n-of-a-kind.
  /// Default: 2
  /// -> int
  n: 2,
) = {
  return {
    cards.len() >= n
  } and {
    get-rank-count(cards).values().any((count) => count >= n)
  }
}

/// Check if the given cards correspond to a "n-of-a-kind", i.e. if they are `n` cards of the same rank.
/// This is a stricter version of the `has-n-of-a-kind` function, as it checks that all cards correspond to the requested hand.
/// 
/// -> bool
#let is-n-of-a-kind(
  /// The cards to check for n-of-a-kind. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of cards that must have the same rank to count as n-of-a-kind.
  /// Default: 2
  /// -> int
  n: 2,
) = {
  return {
    cards.len() == n
  } and {
    let first-rank = extract-card-data(cards.at(0)).rank
    cards.all((card) => extract-card-data(card).rank == first-rank)
  }
}

/// Check if the given cards contain a high card.
/// A high card is defined as having at least one card with a valid rank, regardless of which rank it is.
///
/// -> bool
#let has-high-card(
  /// The cards to check for high card. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return cards.len() > 0 and cards.any((card) => extract-card-data(card).rank != none)
}

/// Check if the given cards correspond to a high card.
/// A high card is defined as a single card with a valid rank.
/// 
/// -> bool
#let is-high-card(
  /// The cards to check for high card. This can be a list or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return cards.len() == 1 and extract-card-data(cards.at(0)).rank != none
}

/// Check if the given cards contain a pair.
/// A pair is defined as two cards of the same rank.
/// 
/// -> bool
#let has-pair(
  /// The cards to check for a pair. This can be an array or any iterable collection of card codes.
  /// -> array
  cards
) = {
  return has-n-of-a-kind(cards, n: 2)
}

/// Check if the given cards correspond to a pair, i.e. if they are two cards of the same rank.
/// 
/// -> bool
#let is-pair(
  /// The cards to check for a pair. This can be an array or any iterable collection of card codes.
  /// -> array
  cards
) = {
  return is-n-of-a-kind(cards, n: 2)
}

/// Check if the given cards contain two pairs.
/// Two pairs are defined as two distinct pairs of cards, each of the same rank.
/// 
/// -> bool
#let has-two-pairs(
  /// The cards to check for two pairs. This can be an array or any iterable collection of card codes.
  /// -> array
  cards
) = {
  return get-rank-count(cards).values().filter((count) => count >= 2).len() >= 2
}

/// Check if the given cards correspond to two pairs, i.e. if they are four cards with two distinct pairs of the same rank.
/// This is done by checking that there are four cards in total, and that there are two distinct pairs of the same rank.
///
/// -> bool
#let is-two-pairs(
  /// The cards to check for two pairs. This can be an array or any iterable collection of card codes.
  /// -> array
  cards
) = {
  return cards.len() == 4 and has-two-pairs(cards)
}

/// Check if the given cards contain three of a kind.
/// Three of a kind is defined as three cards of the same rank.
/// 
/// -> bool
#let has-three-of-a-kind(
  /// The cards to check for three of a kind. This can be an array or any iterable collection of card codes.
  /// -> array
  cards
) = {
  return has-n-of-a-kind(cards, n: 3)
}

/// Check if the given cards correspond to three of a kind, i.e. if they are three cards of the same rank.
/// 
/// -> bool
#let is-three-of-a-kind(
  /// The cards to check for three of a kind. This can be an array or any iterable collection of card codes.
  /// -> array
  cards
) = {
  return is-n-of-a-kind(cards, n: 3)
}

/// Check if the given cards contain a straight.
/// A straight is defined as five consecutive ranks, regardless of suit.
/// 
/// -> bool
#let has-straight(
  /// The cards to check for a straight. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of consecutive ranks required for a straight. Default: 5
  /// -> int
  n: 5,
) = {
  if cards.len() < n {
    return false // Not enough cards to form a straight
  }
  let rank-presence = get-rank-presence(cards).values()
  // Add the first rank to the end to handle wrap-around (e.g., A, 2, 3, 4, 5 or 10, J, Q, K, A)
  rank-presence.push(rank-presence.at(0))
  return rank-presence
    .windows(n) // Get all windows of size n
    .any( // If any window of 5 consecutive ranks
      (window) => window.all(rank => rank) // All ranks in the window are present
    )
}

/// Check if the given cards correspond to a straight.
/// A straight is defined as having exactly `n` consecutive ranks, regardless of suit.
#let is-straight(
  /// The cards to check for a straight. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of consecutive ranks required for a straight. Default: 5
  /// -> int
  n: 5,
) = {
  if cards.len() != n {
    return false // Not enough cards to form a straight
  }
  let rank-presence = get-rank-presence(cards).values()
  // Add the first rank to the end to handle wrap-around (e.g., A, 2, 3, 4, 5 or 10, J, Q, K, A)
  rank-presence.push(rank-presence.at(0))
  return rank-presence
    .windows(n) // Get all windows of size n
    .any( // Any window of 5 consecutive ranks
      (window) => window.all(rank => rank) // All ranks in the window are present
    )
}

/// Check if the given cards contain a flush.
/// A flush is defined as having at least `n` cards of the same suit.
/// 
/// -> bool
#let has-flush(
  /// The cards to check for a flush. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of cards required for a flush. Default: 5
  /// -> int
  n: 5,
) = {
  return get-suit-count(cards, add-zero: false).values().any((count) => count >= n)
}

/// Check if the given cards correspond to a flush, i.e. the hand is composed by `n` cards of the same suit.
/// This is done by checking that there are `n` cards in total, and that there is only one suit present in the hand.
/// 
/// -> bool
#let is-flush(
  /// The cards to check for a flush. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of cards required for a flush. Default: 5
  /// -> int
  n: 5,
) = {
  return cards.len() == n and {
    let suit-presence = get-suit-presence(cards, allow-invalid: false)
    return suit-presence.values().filter((present) => present).len() == 1 // Only one suit should be present
  }
}

/// Check if the given cards contain a full house.
/// A full house is defined as having three of a kind and a pair.
/// 
/// -> bool
#let has-full-house(
  /// The cards to check for a full house. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return has-three-of-a-kind(cards) and has-two-pairs(cards)
}

/// Check if the given cards correspond to a full house.
/// A full house is defined as having three of a kind and a pair.
/// 
/// -> bool
#let is-full-house(
  /// The cards to check for a full house. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return cards.len() == 5 and has-full-house(cards)
}

/// Check if the given cards contain four of a kind.
/// Four of a kind is defined as four cards of the same rank.
/// 
/// -> bool
#let has-four-of-a-kind(
  /// The cards to check for four of a kind. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return has-n-of-a-kind(cards, n: 4)
}

/// Check if the given cards correspond to four of a kind, i.e. if they are four cards of the same rank.
/// 
/// -> bool
#let is-four-of-a-kind(
  /// The cards to check for four of a kind. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return is-n-of-a-kind(cards, n: 4)
}

/// Check if the given cards contain a straight flush.
/// A straight flush is defined as having a straight and a flush at the same time.
/// 
/// Note: This function may accept more than `n` cards (default: more than 5 cards). This means that it will return true if there is a straight and if there is a flush, regardless of the number of cards. This means that the two conditions may not be met by the same cards.
/// 
/// -> bool
#let has-straight-flush(
  /// The cards to check for a straight flush. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of cards required for a straight flush. Default: 5
  /// -> int
  n: 5,
) = {
  return has-straight(cards, n: n) and has-flush(cards, n: n)
}

/// Check if the given cards correspond to a straight flush, i.e. a straight and a flush at the same time.
/// 
/// -> bool
#let is-straight-flush(
  /// The cards to check for a straight flush. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
  /// The number of cards required for a straight flush. Default: 5
  /// -> int
  n: 5,
) = {
  return is-straight(cards, n: n) and is-flush(cards, n: n)
}

/// Check if the given cards contain five of a kind.
/// Five of a kind is defined as five cards of the same rank.
/// 
/// -> bool
#let has-five-of-a-kind(
  /// The cards to check for five of a kind. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return has-n-of-a-kind(cards, n: 5)
}

/// Check if the given cards correspond to five of a kind, i.e. if they are five cards of the same rank.
///
/// -> bool
#let is-five-of-a-kind(
  /// The cards to check for five of a kind. This can be an array or any iterable collection of card codes.
  /// -> array
  cards,
) = {
  return is-n-of-a-kind(cards, n: 5)
}