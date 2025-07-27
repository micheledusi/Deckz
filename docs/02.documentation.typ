#import "template.typ": *

== Card Visualization
This section provides a comprehensive overview of the DECKZ package's *card visualization* capabilities. It presents the available formats and how to use them effectively.
#show-module("view/format")
#show-module("view/back", show-outline: false)

#pagebreak()
== Group Visualization
This section covers the *group visualization* features of the DECKZ package, i.e. all functions that allow you to visualize groups of cards, such as hands, decks, and heaps.

_(More functions and options will be added in the future)._
#show-module("view/group")

#pagebreak()
== Data
This section provides an overview of the data structures used in the DECKZ package, including suits, ranks, and cards. It explains how these data structures are organized and how to access them.
#show-module("data/suit")
#show-module("data/rank")
//#show-module("data/style")
#show-module("model/structs")