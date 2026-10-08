extends Control

const GAME_DATA = preload("res://Data/GameData.tres")

var editing_character_id = 10001

func _ready() -> void:
	$CharacterEditor.hide()

	populate_species_dropdown()
	populate_move_dropdowns()
	update_party_list()

func populate_species_dropdown() -> void:
	$CharacterEditor/SpeciesOptionButton.clear()

	for species_data in GAME_DATA.species:
		$CharacterEditor/SpeciesOptionButton.add_item(
			species_data.species_name
		)

func populate_move_dropdowns() -> void:
	var dropdowns = [
		$CharacterEditor/Move1OptionButton,
		$CharacterEditor/Move2OptionButton,
		$CharacterEditor/Move3OptionButton,
		$CharacterEditor/Move4OptionButton
	]

	for dropdown in dropdowns:
		dropdown.clear()
		dropdown.add_item("[No move]")

		for move_data in GAME_DATA.moves:
			dropdown.add_item(move_data.move_name)

func _on_create_button_pressed() -> void:
	var character_data = PartyInfo.characters[editing_character_id]

	$CharacterEditor/NicknameEdit.text = character_data["nickname"]

	var species_data = character_data["species"]

	for i in range($CharacterEditor/SpeciesOptionButton.item_count):
		if $CharacterEditor/SpeciesOptionButton.get_item_text(i) == species_data.species_name:
			$CharacterEditor/SpeciesOptionButton.select(i)
			break
			
	var moves = character_data["moves"]

	var move_dropdowns = [
		$CharacterEditor/Move1OptionButton,
		$CharacterEditor/Move2OptionButton,
		$CharacterEditor/Move3OptionButton,
		$CharacterEditor/Move4OptionButton
	]

	for slot in range(4):
		var current_move = moves[slot]
		
		if current_move == null:
			move_dropdowns[slot].select(0)
			continue
		
		for i in range(move_dropdowns[slot].item_count):
			if move_dropdowns[slot].get_item_text(i) == current_move.move_name:
				move_dropdowns[slot].select(i)
				break

	$CharacterEditor.show()

func _on_apply_button_pressed() -> void:
	var character_data = PartyInfo.characters[editing_character_id]

	character_data["nickname"] = $CharacterEditor/NicknameEdit.text

	var species_index = $CharacterEditor/SpeciesOptionButton.selected
	character_data["species"] = GAME_DATA.species[species_index]

	var move_dropdowns = [
		$CharacterEditor/Move1OptionButton,
		$CharacterEditor/Move2OptionButton,
		$CharacterEditor/Move3OptionButton,
		$CharacterEditor/Move4OptionButton
	]

	for slot in range(4):
		var move_index = move_dropdowns[slot].selected

		if move_index == 0:
			character_data["moves"][slot] = null
		else:
			character_data["moves"][slot] = GAME_DATA.moves[move_index - 1]

	print("Saved changes to ", character_data["nickname"], "!")

	update_party_list()
	$CharacterEditor.hide()

func _on_cancel_button_pressed() -> void:
	$CharacterEditor.hide()

func update_party_list() -> void:
	for child in $PartyList.get_children():
		child.queue_free()

	for character_id in PartyInfo.party:
		var character_data = PartyInfo.characters[character_id]

		var button = Button.new()
		button.text = character_data["nickname"]

		$PartyList.add_child(button)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")
