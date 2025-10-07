// import.typ

// This file imports the packages and modules needed for the Deckz package. It serves as a central hub for all dependencies, making it easier to manage the versions and updates of the imported packages.

#import "@preview/elembic:1.1.1" as e

// Elembic prefix to disambiguate from other elements with the same name.
// Convention: we use the package name and the major version.
#let elembic-namespace = "@preview/deckz:0.4"