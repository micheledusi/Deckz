#import "../src/data/rank.typ": ranks
#import "../src/data/suit.typ": suits
#import "../src/data/card.typ": card

#import "@preview/elembic:1.1.1" as e

#set text(lang: "en")

#show: e.set_(card)

#card("5D", format: "inline")
#card("5D", format: "mini")
#card("5D", format: "small")
#card("5D", format: "medium")
#card("5H", format: "large")
#card("5D", format: "square")

#card("QS")
#card("back")
#card(none)