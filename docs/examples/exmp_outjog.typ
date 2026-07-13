#v(2cm)

#deckz.line(width: 100%, 
	"AH", 													// Should be down
	(id: "2H"), 										// Should be down
	(id: "3H", outjogged: false), 	// Should be down
	(id: "4H", outjogged: true), 		// Should be up by half the height
	(id: "5H", outjogged: auto), 		// Should be up by half the height
	(id: "6H", outjogged: none), 		// Should be down
	(id: "7H", outjogged: 1mm),			// Should be up by 1mm, 
	(id: "8H", outjogged: 1em),			// Should be up by 1em
	(id: "9H", outjogged: 1cm), 		// Should be up by 1cm
)

#v(2cm)

#deckz.hand(width: 12cm, angle: 45deg,
	"AS", 													// Should be down
	(id: "2S"), 										// Should be down
	(id: "3S", outjogged: false), 	// Should be down
	(id: "4S", outjogged: true), 		// Should be up by half the height
	(id: "5S", outjogged: auto), 		// Should be up by half the height
	(id: "6S", outjogged: none), 		// Should be down
	(id: "7S", outjogged: 1mm),			// Should be up by 1mm, 
	(id: "8S", outjogged: 1em),			// Should be up by 1em
	(id: "9S", outjogged: 1cm), 		// Should be up by 1cm
)