extends Control

const GAME_DATA = preload("res://Data/GameData.tres")

func _ready() -> void:
	$CharacterEditors.hide()
	update_party_list()

func _on_create_button_pressed() -> void:
	open_party_editor()

func open_party_editor() -> void:
	clear_character_editors()
	
	for character_id in PartyInfo.party:
		var character_data = PartyInfo.characters[character_id]
		create_character_editor(character_id, character_data)
		
		$CharacterEditors.show()

func clear_character_editors() -> void:
	for child in $CharacterEditors/CharacterPanelList.get_children():
		child.queue_free()

func create_character_editor(character_id: int, character_data: Dictionary) -> void:
	var panel = VBoxContainer.new()
	panel.name = "CharacterPanel_"+str(character_id)
	panel.set_meta("character_id",character_id)
	
	var heading = Label.new()
	heading.text = character_data["nickname"] + " (ID: " + str(character_id) + ")"
	panel.add_child(heading)
	
	#Nickname
	var nickname_label = Label.new()
	nickname_label.text = "Nickname"
	panel.add_child(nickname_label)
	
	var nickname_edit = LineEdit.new()
	nickname_edit.name = "NicknameEdit"
	nickname_edit.text = character_data["nickname"]
	panel.add_child(nickname_edit)
	
	#Species
	var species_label = Label.new()
	species_label.text = "Species"
	panel.add_child(species_label)
	
	var species_dropdown = OptionButton.new()
	species_dropdown.name = "SpeciesOptionButton"
	
	for species_data in GAME_DATA.species:
		species_dropdown.add_item(species_data.species_name)
		
	var current_species = character_data["species"]
	
	for i in range(GAME_DATA.species.size()):
		if GAME_DATA.species[i] == current_species:
			species_dropdown.select(i)
			break
	
	panel.add_child(species_dropdown)
	
	#Four move slots
	var moves = character_data["moves"]
	
	for slot in range(4):
		var move_label = Label.new()
		move_label.text = "Move " + str(slot + 1)
		panel.add_child(move_label)
		
		var move_dropdown = OptionButton.new()
		move_dropdown.name = "Move" + str(slot + 1) + "OptionButton"
		move_dropdown.add_item("[No move]")
		
		for move_data in GAME_DATA.moves:
			move_dropdown.add_item(move_data.move_name)
			
		var current_move = null
		
		if slot < moves.size():
			current_move = moves[slot]
			
		if current_move == null:
			move_dropdown.select(0)
		else :
			for i in range(GAME_DATA.moves.size()):
				if GAME_DATA.moves[i] == current_move:
					move_dropdown.select(i + 1)
					break
					
		panel.add_child(move_dropdown)
	
	$CharacterEditors/CharacterPanelList.add_child(panel)

func _on_apply_button_pressed() -> void:
	for panel in $CharacterEditors/CharacterPanelList.get_children():
		var character_id: int = panel.get_meta("character_id")
		var character_data = PartyInfo.characters[character_id]
		
		character_data["nickname"] = panel.get_node("NicknameEdit").text
			
		var species_index = panel.get_node("SpeciesOptionButton").selected
			
		if species_index >= 0:
			character_data["species"] = GAME_DATA.species[species_index]
				
			var moves = character_data["moves"]
			
			for slot in range(4):
				var move_dropdown = panel.get_node(
					"Move" + str(slot + 1) + "OptionButton"
				)
				
				var move_index = move_dropdown.selected
				
				if move_index == 0:
					moves[slot] = null
				elif move_index > 0:
					moves[slot] = GAME_DATA.moves[move_index - 1]
					
			character_data["moves"] = moves
		
		PartyInfo.characters[character_id] = character_data
			
	print("Saved changes to all party members!")
		
	update_party_list()
	$CharacterEditors.hide()
	clear_character_editors()

func _on_cancel_button_pressed() -> void:
	$CharacterEditors.hide()
	clear_character_editors()

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
