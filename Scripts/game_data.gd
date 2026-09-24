extends RefCounted

const Scratch = preload("res://Scripts/scratch.gd")
const Growl = preload("res://Scripts/growl.gd")

var moves = {
	"Scratch": Scratch,
	"Growl": Growl
}

var characters = {
	"Jerry": {
		"max_hp": 100,
		"moves": [
			"Scratch",
			"Growl",
			"",
			""
		]
	}
}

var party = [
	"Jerry"
]
