#import "template.typ": *
#show: mantys


// ----------------------------
// Guide for DECKZ package
#include "guide/index.typ"

// ----------------------------
// Complete documentation for DECKZ functions and features
#include "documentation/index.typ"

// ----------------------------
// Examples
#include "examples/index.typ"

// ----------------------------
// Additional information
#heading(numbering: none)[Credits]

The DECKZ package is created and maintained by *Michele Dusi* (#github-user("micheledusi")), along with the people who contributed to the development:

- #link("https://github.com/lukas-dachtler", footnote: false)[Lukas Dachtler] for the outjogging feature;
- #link("https://github.com/jassler", footnote: false)[jassler] for German localization;
- #link("https://github.com/benzlokzik", footnote: false)[benzlokzik] for Armenian and Russian localizations.

The *name* is inspired by Typst's drawing package #universe("cetz"): it mirrors its sound while hinting at its own purpose: rendering card decks.

All *fonts* used in this package are licensed under the #link("https://openfontlicense.org", footnote: false)[SIL Open Font License, Version 1.1] 
(#link("https://fonts.google.com/specimen/Oldenburg", footnote: false)[_Oldenburg_], #link("https://fonts.google.com/specimen/Arvo", footnote: false)[_Arvo_])
or the #link("http://www.apache.org/licenses/", footnote: false)[Apache License, Version 2.0]
(#link("https://fonts.google.com/specimen/Roboto+Slab", footnote: false)[_Roboto Slab_]).

The *card designs* are inspired by the standard playing cards, with suit symbols taken from the #link("https://typst.app/docs/img/reference/symbols/emoji/")[emoji library of Typst].

This project owes a lot to the creators of these *Typst packages*, whose work made DECKZ possible:
- #universe("cetz"), for handling graphics and for the name inspiration.
- #universe("suiji") and #universe("digestify"), for random number generation and hashing respectively.
- #universe("linguify"), for localization.
- #universe("mantys"), #universe("tidy"), and #universe("codly"), for documentation.
- #universe("octique") and #universe("showybox"), for documentation styling.

Special thanks to everyone involved in the development of the #link("https://typst.app/about/", footnote: false)[Typst] language and engine, whose efforts made the entire ecosystem possible.

DECKZ is licensed under the #link("https://www.gnu.org/licenses/gpl-3.0.en.html")[GNU General Public License v3.0].

#heading(numbering: none, level: 2)[Contributions are welcome!]

Found a bug, have an idea, or want to contribute?
Feel free to open an *issue* or *pull request* on the _GitHub_ repository (#github("micheledusi/Deckz")).

Made something cool with Deckz? Let me know — I'd love to feature your work!