// src/model/random.typ

#import "@preview/suiji:0.4.0" // Random numbers library
#import "@preview/digestify:0.1.0": sha256 // Hashing library, used to create a seed from the cards

#let get-seed-from-cards(cards) = {
	// Generate a seed based on the card values
	return int(array(sha256(bytes(cards.join()))).at(0)) + 42
}

/// Shuffle the given cards and return the shuffled array.
/// If `rng` is `auto`, a new RNG will be created using a seed derived from the cards. Otherwise, the provided RNG will be used and returned along with the shuffled cards.
/// The RNG works with the `suiji` library, which provides a random number generator. This function uses the `suiji.shuffle-f` function to shuffle the cards.
/// 
/// -> array | (suiji.rng, array)
#let shuffle(
	/// The cards to shuffle.
	/// -> array
	cards,
	/// The random number generator to use. If `auto`, a new RNG will be created using a seed derived from the cards. In this case, the function will return the shuffled cards only.
	/// Otherwise, the provided RNG will be used and returned along with the shuffled cards.
	/// -> suiji.rng
	rng: auto
) = {
	let rng-from-outside = false
	if rng == auto {
		// Create the RNG using a seed derived from the cards
		let seed = get-seed-from-cards(cards)
		rng = suiji.gen-rng-f(seed)
	} else {
		// Use the provided RNG
		rng-from-outside = true
	}
	let (rng, cards) = suiji.shuffle-f(rng, cards)
	if rng-from-outside {
		return (rng, cards)
	} else {
		return cards
	}
}

/// Choose `n` cards from the given `cards` array, optionally allowing replacement and permutation.
/// If `n` is greater than the number of cards and `replacement` is `false`, the function will return all cards (optionally shuffled, if `permutation` is `true`).
/// If `n` is 0 or less, the function will return an empty array.
/// 
/// This function uses the `suiji.choose-f` function from the `suiji` library to choose the cards.
/// If `rng` is `auto`, a new RNG will be created using a seed derived from the cards. Otherwise, the provided RNG will be used and returned along with the chosen cards.
/// 
/// -> array | (suiji.rng, array)
#let choose(
	/// The cards to choose from.
	/// -> array
	cards,
	/// The number of cards to choose.
	/// Default is 1, meaning that only one card will be chosen from the given cards.
	/// 
	/// If `n` is greater than the number of cards and `replacement` is `false`, the function will return an error. 
	/// If `replacement` is `true`, the function will return `n` cards, possibly including duplicates.
	/// If `n` is 0 or less, the function will return an empty array.
	/// -> int
	n: 1,
	/// Whether to allow replacement of cards. If `true`, the same card can be chosen multiple times. If `false`, each card can only be chosen once.
	/// -> bool
	replacement: false,
	/// Whether the sample is permuted when choosing. If `true`, the order of the chosen cards is random. If `false`, the order of the chosen cards is the same as in the original array.
	/// According to the `suiji` library, false provides a faster implementation, but the order of the chosen cards will not be random.
	/// -> bool
	permutation: false,
	/// The random number generator to use. If `auto`, a new RNG will be created using a seed derived from the cards. In this case, the function will return the chosen cards only.
	/// Otherwise, the provided RNG will be used and returned along with the chosen cards.
	/// -> suiji.rng
	rng: auto
) = {
	if n <= 0 {
		return ()
	}
	let rng-from-outside = false
	if rng == auto {
		// Create the RNG using a seed derived from the cards
		let seed = get-seed-from-cards(cards)
		rng = suiji.gen-rng-f(seed)
	} else {
		// Use the provided RNG
		rng-from-outside = true
	}
	let (rng, sample) = suiji.choice-f(rng, cards, size: n, replacement: replacement, permutation: permutation)
	if rng-from-outside {
		return (rng, sample)
	} else {
		return sample
	}
}