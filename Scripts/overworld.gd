extends Control

func _on_start_battle_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/BattleMenu.tscn")

func _on_quit_game_button_pressed():
	get_tree().quit()
