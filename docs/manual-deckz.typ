#import "template.typ": *
#show: mantys

// ----------------------------
// Manual for DECKZ package
= Getting started

#include "01.manual.typ"


// ----------------------------
// Complete documentation for DECKZ functions and features
= Documentation

== Card Visualization
#show-module("view/format")
#show-module("view/back", show-outline: false)

#pagebreak()
== Group Visualization
#show-module("view/group")

#pagebreak()
== Data
#show-module("data/suit")
#show-module("data/rank")
//#show-module("data/style")
#show-module("model/structs")


// ----------------------------
// Examples
= Examples


// ----------------------------
// Additional information
= Credits

The name is inspired by Typst's drawing package #link("https://typst.app/universe/package/cetz")[CeTZ] — it mirrors its sound while hinting at its own purpose: rendering card decks. In fact, _Deckz_ also relies on CeTZ internally to position elements precisely.