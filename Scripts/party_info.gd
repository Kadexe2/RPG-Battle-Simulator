extends RefCounted

const Charmander = preload("res://Data/Species/Charmander.tres")

var characters = {
	"Jerry": {
		"species": Charmander,
		"moves": [
			"Scratch",
			"Ember",
			"Howl",
			"Fire Punch"
		]
	}
}

var party = [
	"Jerry"
]
