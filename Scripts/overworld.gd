extends Control

const ViridianForest = preload("res://Data/Areas/ViridianForest.tres")


func _on_start_battle_button_pressed():
	EncounterInfo.enemy_species = ViridianForest.generate_encounter()

	get_tree().change_scene_to_file("res://Scenes/BattleMenu.tscn")


func _on_quit_game_button_pressed():
	get_tree().quit()
