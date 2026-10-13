class_name SaveManager
extends RefCounted

const MAX_SAVE_SLOTS = 3
const GAME_DATA = preload("res://Data/GameData.tres")

func get_save_path(slot: int) -> String:
	return "user://save_" + str(slot) + ".json"


func save_game(party_info, slot: int):
	var save_data = {
		"party": party_info.party,
		"characters": {}
	}

	for character_id in party_info.characters:
		var character_data = party_info.characters[character_id]
		var species_data = character_data["species"]
		var saved_moves = []
		
		for move_data in character_data["moves"]:
			if move_data == null:
				saved_moves.append(null)
			else:
				saved_moves.append(move_data.move_name)

		save_data["characters"][str(character_id)] = {
			"nickname": character_data["nickname"],
			"species": species_data.species_name,
			"moves": saved_moves
		}

	var save_path = get_save_path(slot)
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved to slot ", slot, "!")
	else:
		push_error("Could not open save file for writing: " + save_path)
		
func load_game(slot: int):
	var save_path = get_save_path(slot)
	
	if not FileAccess.file_exists(save_path):
		print("No save file found in slot ", slot, ".")
		return null

	var file = FileAccess.open(save_path, FileAccess.READ)

	if file == null:
		push_error("Could not open save file: " + save_path)
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
		
	if save_data.has("party"):
		party_info.party.clear()

		for saved_id in save_data["party"]:
			party_info.party.append(int(saved_id))
		
	if not save_data.has("characters"):
		return

	for character_id in party_info.characters:
		var character_id_string = str(character_id)

		if not save_data["characters"].has(character_id_string):
			continue

		var saved_character = save_data["characters"][character_id_string]
		var character_data = party_info.characters[character_id]
		
		if saved_character.has("nickname"):
			character_data["nickname"] = saved_character["nickname"]
			
		if saved_character.has("species"):
			var species_data = find_species(saved_character["species"])
			
			if species_data != null:
				character_data["species"] = species_data
		
		if saved_character.has("moves"):
			var restored_moves = []
			
			for move_name in saved_character["moves"]:
				if move_name == null or move_name == "":
					restored_moves.append(null)
				else:
					restored_moves.append(find_move(move_name))
		
			# Keep exactly four move slots.
			while restored_moves.size() < 4:
				restored_moves.resize(4)
			
			if restored_moves.size() > 4:
				restored_moves.resize(4)
				
			character_data["moves"] = restored_moves

		party_info.characters[character_id] = character_data

func find_species(species_name: String):
	for species_data in GAME_DATA.species:
		if species_data.species_name == species_name:
			return species_data

	print("Species requested: ", species_name)
	print("Species available in GameData:")
	for species_data in GAME_DATA.species:
		print(" - ", species_data.species_name)

	return null
		
func find_move(move_name: String):
	for move_data in GAME_DATA.moves:
		if move_data.move_name == move_name:
			return move_data

	print("Move requested: ", move_name)
	print("Moves available in GameData:")
	for move_data in GAME_DATA.moves:
		print(" - ", move_data.move_name)

	return null
	
func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_save_path(slot))
