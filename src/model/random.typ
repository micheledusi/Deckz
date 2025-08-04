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



// Auxiliary function.
// Reshape the array into a multi-dimensional array with the given dimensions.
// This is useful for creating multi-dimensional arrays from flat arrays.
// 
// Typst does not have a built-in function for reshaping arrays, so this function is implemented manually.
#let reshape(arr, dims) = {
  let num-elements = arr.len()
  if dims.product() != num-elements {
    panic("The product of the dimensions must be equal to the length of the array.")
  }
  let first-dim = dims.at(0)
  let length-of-sub-array = calc.div-euclid(num-elements, first-dim)

  // Chunk the array into sub-arrays of the specified length and reshape them according to the dimensions.
  return arr.chunks(length-of-sub-array, exact: true).map(arr => {
    if dims.len() > 2 {
      // If the dimensions are more than 2, we need to reshape the array into a multi-dimensional array
      return reshape(arr, dims.slice(1))
    }
    return arr
  })
}

/// Split the given deck of cards into groups of specified sizes. This is useful for dealing cards to players or creating smaller decks from a larger one.
/// 
/// The function will return an array containing the groups of cards, and the last element of the array will contain the remaining cards if `rest` is `true`. If `rest` is `false`, the function will return only the groups of cards, discarding any remaining cards.
/// The groups are defined by the `size` parameter, which can be a single integer or an array of integers. Cards are guaranteed to be dealt *in-place*, meaning that the order of the cards in the original deck is preserved in the output groups.
/// 
/// More specifically, the `size` parameter can be:
///   - An integer, which will define the size of only one group. In this case, the function will return an array containing a cards group of the given size, and another group of remaining cards.
///   - Multiple integers (as an array), which will define the sizes of multiple groups. In this case, the function will return an array containing the groups of the given sizes, and the last element of the array will contain the remaining cards.
/// 
/// -> array | (suiji.rng, array)
#let split(
  /// The deck of cards to split.
  /// -> array
  cards,
  /// The size of the groups that the deck will be split into. 
  /// This parameter can accept:
  /// - An *integer*, which will be used as the size of only one group.
  ///   ```typst
  ///   #deckz.split(cards, size: 5) // Splits the deck into a group of 5 cards, and the rest of the cards.
  ///    ```
  /// - An *array of sizes* (where "sizes" are integers or array of integers), which will be used as the sizes of the groups. 
  ///   ```typst
  ///    #deckz.split(cards, size: (5, 3, 2)) // Splits the deck into three groups of 5, 3, and 2 cards respectively, and the rest of the cards in a fourth group.
  ///    #deckz.split(cards, size: (5, (3, 2))) // Splits the deck into a first group of 5 cards, a second group with of 6 cards structured as a _bidimensional matrix_ of dimensions 3x2, and a last group with the remaining cards.
  ///    ```
  /// -> int | array
  size: 1,
  /// Whether or not the function should return the rest of the cards after splitting.
  /// If `true`, the returned array will contain all cards in the input deck, with the remaining cards (i.e. the non-split cards) at the end. Default is `true`.
  /// If `false`, the returned array will contain only the split cards, and those which are not contained in the split size will be discarded.
  /// -> bool
  rest: true,
  /// The random number generator to use. If `auto`, a new RNG will be created using a seed derived from the cards. In this case, the function will return the split cards only.
  /// Otherwise, the provided RNG will be used and returned along with the split cards.
  /// -> suiji.rng
  rng: auto,
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

  // Always convert the size to an array of size 
  let sizes-array = if type(size) == int {
    if size < 0 {
      panic("The `size` parameter must be a non-negative integer or an array of positive integers.")
    } else {
      (size, )
    }
  } else if type(size) == array {
    size
  } else {
    panic("The `size` parameter must be an integer or an array of integers.")
  }

  let current-index = 0
  let cards-indices = ()
  for group-size in sizes-array {
    if type(group-size) == int {
      cards-indices += (current-index, ) * group-size
      current-index += 1
    } else if type(group-size) == array {
      let last-dim = group-size.at(-1)
      let subgroups-num = group-size.slice(0, -1).product()
      for _ in range(subgroups-num) {
        cards-indices += (current-index, ) * last-dim
        current-index += 1
      }
    } else {
      panic("The `size` parameter must be an integer or an array of integers.")
    }
  }

  let aux-groups = ((), ) * current-index
  // If the `rest` parameter is true, we need to add the remaining cards to the end of the array
  if rest {
    cards-indices += (current-index, ) * (cards.len() - cards-indices.len())
    aux-groups.push(())
    current-index += 1
  }

  (rng, cards-indices) = suiji.shuffle-f(rng, cards-indices)
  
  for (idx, card) in cards-indices.zip(cards) {
    aux-groups.at(idx).push(card)
  }

  current-index = 0 // Referencing the current index in the groups array
  let groups = ()
  for group-size in sizes-array {
    if type(group-size) == int {
      // If the group size is an integer, we can just slice the array
      groups.push(aux-groups.at(current-index))
      current-index += 1
    } else if type(group-size) == array {
      // If the group size is an array, we need to reshape the array into a multi-dimensional array
      let num-subgroups = group-size.slice(0, -1).product()
      groups.push(reshape(aux-groups.slice(current-index, current-index + num-subgroups).flatten(), group-size))
      current-index += num-subgroups 
    }
  }
  // If the `rest` parameter is true, we need to add the remaining cards to the end of the array
  if rest {
    groups.push(aux-groups.at(current-index))
  }
  if rng-from-outside {
    return (rng, groups)
  } else {
    return groups
  }
}