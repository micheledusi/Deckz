// sort.typ
// This file defines the sorting functions for the Deckz package.

#import "convert.typ": extract-card-data

/// Compare two cards based on their score, given the card data.
/// The score is determined by the rank of the card, where Ace comes first, followed by King, Queen, Jack, and then numbered cards from 10 to 2:
/// A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2.
/// 
/// -> key
#let score-comparator(
	/// The iterator of the card, from which the rank is extracted.
	/// -> card
	card-it,
) = {
	return (-extract-card-data(card-it).rank-score)
}

/// Sort a list of cards by their score.
/// The cards are sorted in descending order based on their score, which is determined by the rank of the card.
/// The order is as follows: Ace, King, Queen, Jack, 10, 9, 8, 7, 6, 5, 4, 3, 2.
///
/// -> cards
#let sort-by-score(
	/// The cards to sort.
	/// -> array
	cards,
) = {
	return cards.sorted(key: score-comparator)
}

/// Compare two cards based on their order in a standard sorted deck.
/// The order compares two cards by their suit (first) and rank (second).
/// Suits and ranks are ordered according to their attributes "suit-order" and "rank-order".
/// These are defined by default as:
/// - Suits: Hearts, Diamonds, Clubs, Spades
/// - Ranks: A, 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K
/// 
/// -> (key, key)
#let order-comparator(
	/// The iterator of the card, from which the suit and rank are extracted.
	/// -> card
	card-it,
) = {
	let card-data = extract-card-data(card-it)
	return (card-data.suit-order, card-data.rank-order)
}

/// Sort a list of cards by their order in a standard sorted deck.
/// The cards are sorted in ascending order based on their suit and rank.
/// 
/// -> cards
#let sort-by-order(
	/// The cards to sort.
	/// -> array
	cards,
) = {
	return cards.sorted(key: order-comparator)
}

/// Sort a list of cards based on a specified key.
/// The key can be "score", "order", or any other attribute of the card.
/// If the key is *"score"*, the cards are sorted by their score (see @cmd:deckz.sort-by-score).
/// If the key is *"order"*, the cards are sorted by their order in a standard sorted deck (see @cmd:deckz.sort-by-order).
/// If the key is not specified or is #value(`auto`), the behavior defaults to sorting by *order*.
/// Other keys will be interpreted as attributes of the card and sorted accordingly, as if using the `sorted` method with that key.
/// 
/// -> arraykey
#let sort(
	/// The cards to sort.
	/// -> array
	cards,
	/// The key to sort by. Can be "score", "order", or any other attribute of the card.
	/// Defaults to "order" if not specified.
	/// -> string | auto
	by: auto,
) = {
	if by == "score" {
		return sort-by-score(cards)
	} else if by == "order" or by == auto {
		return sort-by-order(cards)
	} else {
		return cards.sorted(key: by)
	}
}