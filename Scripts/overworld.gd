extends Control

const ViridianForest = preload("res://Data/Areas/ViridianForest.tres")
const PARTY_MENU_SCENE = preload("res://Scenes/PartyMenu.tscn")


var save_manager = SaveManager.new()
var party_menu

var selected_save_slot: int = 0

func _ready():
	party_menu = PARTY_MENU_SCENE.instantiate()
	add_child(party_menu)

	party_menu.hide()

func _on_start_battle_button_pressed():
	EncounterInfo.enemy_species = ViridianForest.generate_encounter()

	get_tree().change_scene_to_file("res://Scenes/BattleMenu.tscn")

func _on_party_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/PartyMenu.tscn")

func _on_save_button_pressed():
	$SaveMenu.show()
	$OverworldMainMenu.hide()
	update_save_slot_buttons()

func update_save_slot_buttons():
	$SaveMenu/SaveSlot1Button.text = get_save_slot_text(1)
	$SaveMenu/SaveSlot2Button.text = get_save_slot_text(2)
	$SaveMenu/SaveSlot3Button.text = get_save_slot_text(3)

func _on_save_slot_1_button_pressed():
	save_to_slot(1)


func _on_save_slot_2_button_pressed():
	save_to_slot(2)


func _on_save_slot_3_button_pressed():
	save_to_slot(3)

func save_to_slot(slot: int):
	if save_manager.save_exists(slot):
		selected_save_slot = slot
		$OverwriteYesNo/OverwriteLabel.text = "Overwrite Save Slot " + str(slot) + "?"
		$SaveMenu.hide()
		$OverwriteYesNo.show()
		return

	save_manager.save_game(PartyInfo, slot)
	$SaveMenu.hide()
	$OverworldMainMenu.show()

func _on_yes_button_pressed():
	save_manager.save_game(PartyInfo, selected_save_slot)

	$OverwriteYesNo.hide()
	$OverworldMainMenu.show()
	
func _on_no_button_pressed():
	$OverwriteYesNo.hide()
	$SaveMenu.show()

func get_save_slot_text(slot: int) -> String:
	if save_manager.save_exists(slot):
		return "Save Slot " + str(slot) + " - Occupied"

	return "Save Slot " + str(slot) + " - Empty"

func _on_cancel_save_button_pressed():
	$SaveMenu.hide()
	$OverworldMainMenu.show()

func _on_load_button_pressed():
	$OverworldMainMenu.hide()
	$LoadMenu.show()
	update_load_slot_buttons()

func update_load_slot_buttons():
	$LoadMenu/LoadSlot1Button.text = get_load_slot_text(1)
	$LoadMenu/LoadSlot2Button.text = get_load_slot_text(2)
	$LoadMenu/LoadSlot3Button.text = get_load_slot_text(3)

func get_load_slot_text(slot: int) -> String:
	if save_manager.save_exists(slot):
		return "Load Slot " + str(slot)

	return "Load Slot " + str(slot) + " - Empty"

func _on_load_slot_1_button_pressed():
	load_from_slot(1)


func _on_load_slot_2_button_pressed():
	load_from_slot(2)


func _on_load_slot_3_button_pressed():
	load_from_slot(3)

func load_from_slot(slot: int):
	if not save_manager.save_exists(slot):
		return

	save_manager.load_into_party(PartyInfo, slot)

	$LoadMenu.hide()
	$OverworldMainMenu.show()

func _on_cancel_load_button_pressed():
	$LoadMenu.hide()
	$OverworldMainMenu.show()

func _on_quit_game_button_pressed():
	get_tree().quit()
