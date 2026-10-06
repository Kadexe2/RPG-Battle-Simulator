class_name SaveManager
extends RefCounted

const MAX_SAVE_SLOTS = 3


func get_save_path(slot: int) -> String:
	return "user://save_" + str(slot) + ".json"


func save_game(party_info, slot: int):
	var save_data = {
		"party": party_info.party,
		"characters": {}
	}

	for character_id in party_info.characters:
		var character_data = party_info.characters[character_id]

		save_data["characters"][str(character_id)] = {
			"nickname": character_data["nickname"]
		}

	var save_path = get_save_path(slot)
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

		print("Game saved to slot ", slot, "!")
		
func load_game(slot: int):
	var save_path = get_save_path(slot)
	
	if not FileAccess.file_exists(save_path):
		print("No save file found in slot ", slot, ".")
		return null

	var file = FileAccess.open(save_path, FileAccess.READ)

	if file == null:
		return null

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()

	if json.parse(json_text) != OK:
		print("Failed to parse save file.")
		return null

	print("Game loaded from slot ", slot, "!")

	return json.data
	
func load_into_party(party_info, slot:int):
	var save_data = load_game(slot)

	if save_data == null:
		return

	for character_id in party_info.characters:
		var character_id_string = str(character_id)

		if not save_data["characters"].has(character_id_string):
			continue

		var saved_character = save_data["characters"][character_id_string]

		party_info.characters[character_id]["nickname"] = saved_character["nickname"]
		
func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_save_path(slot))
