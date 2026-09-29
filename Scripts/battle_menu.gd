extends Control

#DECLARE VARIABLES

const BattleUnit = preload("res://Scripts/battle_unit.gd")
const PartyInfo = preload("res://Scripts/party_info.gd")
const MoveData = preload("res://Scripts/move_data.gd")
const Battle = preload("res://Scripts/battle.gd")

const Caterpie = preload("res://Data/Species/Caterpie.tres")

@onready var main_menu = $MainMenu
@onready var fight_menu = $FightMenu

var party_info = PartyInfo.new()
var move_data = MoveData.new()
var battle = Battle.new()

var party_units = []
var enemy_units = []

var party_hp_labels = []
var enemy_hp_labels = []

var selected_move_index = -1

#DISPLAY UNITS ON SCREEN

func create_hp_displays(units, container, labels):
	for unit in units:
		var hp_label = Label.new()
		hp_label.text = str(unit.current_hp) + " / " + str(unit.max_hp)
		container.add_child(hp_label)
		labels.append(hp_label)

func update_hp_display():
	for i in range(enemy_units.size()):
		enemy_hp_labels[i].text = str(enemy_units[i].current_hp) + " / " + str(enemy_units[i].max_hp)

	for i in range(party_units.size()):
		party_hp_labels[i].text = str(party_units[i].current_hp) + " / " + str(party_units[i].max_hp)

func _ready():
	fight_menu.hide()
	$TargetMenu.hide()

	for character_name in party_info.party:
		var character_data = party_info.characters[character_name]

		var species_data = character_data["species"]

		var party_unit = BattleUnit.new()
		party_unit.max_hp = species_data.base_hp
		party_unit.current_hp = party_unit.max_hp
		party_unit.attack = species_data.base_attack
		party_unit.defense = species_data.base_defense

		for i in range(character_data["moves"].size()):
			var move_name = character_data["moves"][i]

			if move_name != "":
				var move_data_entry = move_data.moves[move_name]
				party_unit.move_slots[i] = move_data_entry

		party_units.append(party_unit)

	for i in range(2):
		var enemy_unit = BattleUnit.new()
		enemy_unit.name = "Enemy " + str(i + 1)
		enemy_unit.max_hp = Caterpie.base_hp
		enemy_unit.current_hp = enemy_unit.max_hp
		enemy_unit.attack = Caterpie.base_attack
		enemy_unit.defense = Caterpie.base_defense
		enemy_units.append(enemy_unit)

	create_hp_displays(enemy_units, $EnemyHPContainer, enemy_hp_labels)
	create_hp_displays(party_units, $PartyHPContainer, party_hp_labels)

	battle.setup(party_units, enemy_units)

	battle.damage_dealt.connect(_on_damage_dealt)
	battle.enemy_fainted.connect(_on_enemy_fainted)
	battle.battle_won.connect(_on_battle_won)

#FIGHT MENU, CHOOSE YOUR MOVE

func _on_fight_button_pressed():
	main_menu.hide()
	fight_menu.show()

func _on_back_button_pressed():
	fight_menu.hide()
	main_menu.show()
	
func _on_run_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/overworld.tscn")
		
func _on_move_1_button_pressed():
	show_target_menu(0)

func _on_move_2_button_pressed():
	show_target_menu(1)

func _on_move_3_button_pressed():
	show_target_menu(2)

func _on_move_4_button_pressed():
	show_target_menu(3)
		
#TARGETING MENU, CHOOSE A TARGET AFTER MOVE WAS SELECTED
		
func show_target_menu(move_index):
	var move = party_units[0].move_slots[move_index]
	
	if move == null:
		return
	
	selected_move_index = move_index

	fight_menu.hide()
	$TargetMenu.show()

	create_target_buttons()
	
func create_target_buttons():
	for child in $TargetMenu.get_children():
		child.queue_free()

	for i in range(enemy_units.size()):
		var button = Button.new()
		button.text = enemy_units[i].name
		button.pressed.connect(_on_target_button_pressed.bind(i))
		$TargetMenu.add_child(button)

	var cancel_button = Button.new()
	cancel_button.text = "CANCEL"
	cancel_button.pressed.connect(_on_target_cancel_pressed)
	$TargetMenu.add_child(cancel_button)
	
func _on_target_button_pressed(target_index):
	$TargetMenu.hide()

	var attacker = party_units[0]
	var move = attacker.move_slots[selected_move_index]
	var target = enemy_units[target_index]

	battle.use_move(attacker, move, target)

	selected_move_index = -1
	main_menu.show()

func _on_target_cancel_pressed():
	$TargetMenu.hide()
	fight_menu.show()
	selected_move_index = -1
	
func _on_damage_dealt():
	update_hp_display()
	
func _on_enemy_fainted(index):
	var hp_label = enemy_hp_labels[index]
	hp_label.queue_free()
	enemy_hp_labels.remove_at(index)

	update_hp_display()
	
func _on_battle_won():
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")
