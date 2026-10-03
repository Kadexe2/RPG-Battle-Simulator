extends RefCounted

const Charmander = preload("res://Data/Species/Charmander.tres")

var characters = {
	"Jerry": {
		"species": Charmander,
		"moves": [
			preload("res://Data/Moves/Scratch.tres"),
			preload("res://Data/Moves/Leer.tres"),
			preload("res://Data/Moves/Howl.tres"),
			preload("res://Data/Moves/FirePunch.tres"),
			]
	}
}

var party = [
	"Jerry"
]
