extends Control

const SPECIES = [
	preload("res://Data/Species/Charmander.tres"),
	preload("res://Data/Species/Caterpie.tres"),
	preload("res://Data/Species/Kakuna.tres"),
	preload("res://Data/Species/Metapod.tres"),
	preload("res://Data/Species/Pikachu.tres"),
	preload("res://Data/Species/Weedle.tres")
]

var editing_character_id = 10001

func _ready() -> void:
	$CharacterEditor.hide()

	populate_species_dropdown()
	update_party_list()

func populate_species_dropdown() -> void:
	$CharacterEditor/SpeciesOptionButton.clear()

	for species_data in SPECIES:
		$CharacterEditor/SpeciesOptionButton.add_item(
			species_data.species_name
		)

func _on_create_button_pressed() -> void:
	var character_data = PartyInfo.characters[editing_character_id]

	$CharacterEditor/NicknameEdit.text = character_data["nickname"]

	var species_data = character_data["species"]

	for i in range($CharacterEditor/SpeciesOptionButton.item_count):
		if $CharacterEditor/SpeciesOptionButton.get_item_text(i) == species_data.species_name:
			$CharacterEditor/SpeciesOptionButton.select(i)
			break

	$CharacterEditor.show()

func _on_apply_button_pressed() -> void:
	var character_data = PartyInfo.characters[editing_character_id]

	character_data["nickname"] = $CharacterEditor/NicknameEdit.text

	var species_index = $CharacterEditor/SpeciesOptionButton.selected
	character_data["species"] = SPECIES[species_index]

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
