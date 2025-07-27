#import "template.typ": *

Introduction.

We're at the version #doc.package.version #emoji.party

== Importing the package

To use DECKZ functionalities in your project, add this instruction to your document:

#show-import(imports: "deckz")

DECKZ is typically imported with the keyword `deckz`, which will be used to call the package functions.

You can then call any of the rendering functions using the `deckz` namespace.

== Basic usage

The main entry point is the `deckz.render()` function:

```side-by-side
#deckz.render("7D", format: "large")
```

The first argument is the *card identifier* as a string. Use standard short notation like `"AH"`, `"10S"`, `"QC"`, etc., where the first letter(s) indicates the *rank*, and the last letter the *suit*.

- *Available ranks*: `A`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `J`, `Q`, `K`.
- *Available suits*: `H` (Hearts #text(red)[#emoji.suit.heart]), `D` (Diamonds #text(red)[#emoji.suit.diamond]), `C` (Clubs #emoji.suit.club), `S` (Spades #emoji.suit.spade).

_Note_. Card identifier is case-insensitive, so `"as"` and `"AS"` are equivalent and both represent the Ace of Spades.

The second argument is optional and specifies the *format* of the card display. If not provided, it defaults to `medium`.
See the next section for available formats.


