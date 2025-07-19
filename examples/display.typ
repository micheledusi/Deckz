#import "../src/lib.typ" as deckz: deck

#set text(font: "Arvo")

= Deck _inline_
#grid(columns: 13, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(deckz.inline)
)

= Deck _mini_
#grid(columns: 13, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(deckz.mini)
)

= Deck _small_
#grid(columns: 13, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(deckz.small)
)

= Deck _medium_
#grid(columns: 6, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(deckz.medium)
)

= Deck _large_
#grid(columns: 4, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(deckz.large)
)

= Deck _square_
#grid(columns: 4, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(deckz.square)
)
