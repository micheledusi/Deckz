// style.typ
// This file defines the style and colors used in the Deckz package.
// It includes the background color, border style, and suit colors.

/// Default style resource folder.
#let res-deck-dir = "res/decks/default"

/// The background color for the card rendering area.
/// It represents the color of the "paper" or "canvas" where the cards are displayed.
/// Currently set to a light aqua color.
/// 
/// -> color
#let bg-color = aqua.lighten(90%)

/// The color used for the back of the cards.
/// It is a light blue color, defined using a hex code.
#let back-color = color.rgb("#4796a4")

/// The border style for the card rendering area.
/// It defines the appearance of the border around the card area.
/// Currently set to a gray color mixed with aqua, darkened by 50% and with a width of 1pt.
/// 
/// -> color + length
#let border-style = gray.mix(aqua).darken(50%) + 1pt

#let title-case(string) = {
  return string.replace(
    regex("[A-Za-z]+('[A-Za-z]+)?"),
    word => upper(word.text.first()) + lower(word.text.slice(1)),
  )
}

#let regex-hex-color = regex("^#[0-9a-fA-F]{3}([0-9a-fA-F]{3})?$")
#let regex-gradient = regex("gradient\.[a-z_-]+\(.*\)")