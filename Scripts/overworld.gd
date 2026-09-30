extends Control

const RandomEncounter = preload("res://Scripts/random_encounter.gd")

var random_encounter = RandomEncounter.new()

func _on_start_battle_button_pressed():
	EncounterInfo.enemy_species = random_encounter.generate_encounter()

	get_tree().change_scene_to_file("res://Scenes/BattleMenu.tscn")

func _on_quit_game_button_pressed():
	get_tree().quit()
