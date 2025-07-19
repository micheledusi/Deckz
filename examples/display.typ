#import "../src/lib.typ": *

= Deck _inline_
#grid(columns: 13, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(show-card-inline)
)

= Deck _mini_
#grid(columns: 13, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(show-card-mini)
)

= Deck _small_
#grid(columns: 13, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(show-card-small)
)

= Deck _medium_
#grid(columns: 6, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(show-card-medium)
)

= Deck _large_
#grid(columns: 4, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(show-card-large)
)

= Deck _square_
#grid(columns: 4, column-gutter: 1fr, row-gutter: 10pt,
    ..deck.map(show-card-square)
)
