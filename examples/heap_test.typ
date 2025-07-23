#import "../src/lib.typ" as deckz

#set text(font: "Roboto Slab")


Sa sa prova.

#deckz.card-style()[Ciao]

#show: deckz.setup-bg-color(green)

#deckz.card-style()[Cucu]

#deckz.card-style(fill: red)[Cucu]

#show: deckz.setup-bg-color(blue)

#deckz.card-style()[Cucu]

#deckz.card-style(fill: red)[Cucu]

#deckz.heap(..deckz.deck52, format: "mini")