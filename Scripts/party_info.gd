extends Node

var party = [10001]

var characters = {
	10001: {
		"id": 10001,
		"nickname": "Jerry",
		"species": preload("res://Data/Species/Charmander.tres"),
		"moves": [
			preload("res://Data/Moves/Scratch.tres"),
			preload("res://Data/Moves/Growl.tres"),
			preload("res://Data/Moves/Ember.tres"),
			preload("res://Data/Moves/FirePunch.tres")
		]
	}
}

func create_character():
	var character_id = get_next_character_id()

	characters[character_id] = {
		"id": character_id,
		"nickname": "New Character",
		"species": null,
		"moves": [null, null, null, null]
	}

	party.append(character_id)

	return character_id
	
func get_next_character_id() -> int:
	var highest_id = 10000

	for character_id in characters:
		if character_id > highest_id:
			highest_id = character_id

	return highest_id + 1
