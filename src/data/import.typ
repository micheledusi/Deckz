// import.typ

// This file imports the packages and modules needed for the Deckz package. It serves as a central hub for all dependencies, making it easier to manage the versions and updates of the imported packages.

// The `elembic` package is needed to handle the deck elements, such as suits and ranks.
#import "@preview/elembic:1.1.1" as e

// Elembic prefix to disambiguate from other elements with the same name.
// Convention: we use the package name and the major version.
#let elembic-namespace = "@preview/deckz:0.5"

// The `linguify` package is used to localize and translate card names.
#import "@preview/linguify:0.4.2": *

// The resources directory
#let res-dir = "../../res/"

// The reference to the language data for names translation.
#let lang-data = toml(res-dir + "lang.toml")

// Decks directory containing the styles specifications
#let decks-dir = res-dir + "decks/"

// -------------------------------------------------------------
// Utility functions

// Capitalizes the words within a string
#let title-case(string) = {
  return string.replace(
    regex("[A-Za-z]+('[A-Za-z]+)?"),
    word => upper(word.text.first()) + lower(word.text.slice(1)),
  )
}

#let regex-hex-color = regex("^#[0-9a-fA-F]{3}([0-9a-fA-F]{3})?$")
#let regex-gradient = regex("gradient\.[a-z_-]+\(.*\)")