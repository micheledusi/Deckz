# Deckz

<a href="https://github.com/typst/packages/tree/main/packages/preview/deckz" style="text-decoration: none;"><img src="https://img.shields.io/badge/typst-package-239dad?style=flat" alt="Typst package Deckz" /></a>
<a href="https://www.gnu.org/licenses/gpl-3.0.en.html" style="text-decoration: none;"><img src="https://img.shields.io/badge/license-GPLv3-brightgreen?style=flat" alt="License GPLv3.0" /></a>

A flexible and customizable package to **render and display poker-style playing cards** in [Typst](https://typst.app/).

Use **Deckz** to visualize individual cards, create stylish examples in documents, or (coming soon!) build full decks and hands for games and illustrations. ♠️♦️♣️♥️

![A sample of rendered cards using different formats.](docs/example_cards.png)

The name is inspired by Typst’s drawing package [CeTZ](https://typst.app/universe/package/cetz) — it mirrors its sound while hinting at its own purpose: rendering card decks.
In fact, _Deckz_ also relies on _CeTZ_ internally to position elements precisely.


## Quick Example

```typ
#import "@preview/deckz:0.1.0": card

= Card Example

#card.show("QS", format: "medium")
#card.show("10H", format: "mini")
#card.inline("KC")
```

## Importing the Package
To use Deckz, import it into your _Typst_ document with:

```typ
#import "@preview/deckz:0.1.0" as deckz
```

You can then call any of the rendering functions using the `deckz` namespace.

## Basic Usage – `deckz.render`

The main entry point is the `deckz.render()` function:

```typ
#card.show("7D", format: "large")
```

The first argument is the **card identifier** as a string. Use standard short notation like `"AH"`, `"10S"`, `"QC"`, etc.

The format parameter defines the card layout. See the next section for available formats.

## Formats

Deckz provides multiple display formats to fit different design needs:

| Format | Description |
| --- | --- |
| `inline` | A minimal format where the rank and suit are shown directly inline with text — perfect for references like *"you drew a #deckz.inline("KH")"*. |
| `mini`   | The smallest visual format: a tiny rectangle with the rank on top and the suit at the bottom. |
| `small`  | A compact but clearer card with rank in opposite corners and the suit centered. |
| `medium` | A full, structured card with proper layout, two corner summaries, and realistic suit placement. |
| `large`  | An expanded version of `medium` with corner summaries on all four sides for maximum readability. |
| `square` | A balanced 1:1 format with summaries in all corners and the main figure centered — great for grid layouts. |

You can use any of these with the `deckz.render()` function, or directly via specific calls:

```typ
#deckz.mini("2C")
#deckz.large("JH")
#deckz.square("AD")
```

**Note**. All formats are responsive to the current text size — they scale proportionally using `em` units, making them adaptable to different layouts and styles.

## Decks & Hands *(COMING SOON)*
The next versions of Deckz will include support for:

- Rendering full decks;
- Grouping hands of cards. 

Stay tuned!

## Final Examples

### Example: Hand of Cards
```typ
#stack(spacing: 6pt,
  card.small("10H"),
  card.small("JC"),
  card.small("QD"),
  card.small("KS"),
  card.small("AC"),
)
```

### Example: Inline Mention
```typ
You drew the #card.inline("AS") — a lucky ace of spades!
```

## Contributing
Found a bug, have an idea, or want to contribute?
Feel free to open an **issue** or **pull request** on the [GitHub repository](https://github.com/micheledusi/Deckz).

Made something cool with Deckz? Let me know — I’d love to feature your work!

### Credits
This package is created by [Michele Dusi](https://github.com/micheledusi).

