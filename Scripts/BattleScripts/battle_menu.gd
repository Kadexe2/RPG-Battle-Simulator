extends Control

#DECLARE VARIABLES

const BattleUnit = preload("res://Scripts/BattleScripts/battle_unit.gd")
const Battle = preload("res://Scripts/BattleScripts/battle.gd")

@onready var main_menu = $MainBattleMenu
@onready var fight_menu = $FightMenu

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

func update_move_buttons():
	var move_buttons = [
		$FightMenu/Move1Button,
		$FightMenu/Move2Button,
		$FightMenu/Move3Button,
		$FightMenu/Move4Button
	]
	
	var moves = battle.party_units[0].move_slots

	for i in range(move_buttons.size()):
		var move = moves[i]
		
		if move == null:
			move_buttons[i].text = "-"
		else:
			move_buttons[i].text = move.move_name
			move_buttons[i].tooltip_text = get_move_tooltip(move)
	

func _ready():
	fight_menu.hide()
	$TargetMenu.hide()

	battle.setup(PartyInfo, EncounterInfo.enemy_species)

	party_units = battle.party_units
	enemy_units = battle.enemy_units

	create_hp_displays(enemy_units, $EnemyHPContainer, enemy_hp_labels)
	create_hp_displays(party_units, $PartyHPContainer, party_hp_labels)
	
	update_move_buttons()

	battle.damage_dealt.connect(_on_damage_dealt)
	battle.enemy_fainted.connect(_on_enemy_fainted)
	battle.battle_won.connect(_on_battle_won)
	battle.party_unit_fainted.connect(_on_party_unit_fainted)
	battle.party_wiped.connect(_on_party_wiped)

func get_move_tooltip(move_tooltip: MoveData) -> String:
	var text = move_tooltip.move_name + "\n\n"

	text += "Type: " + ElementalType.Type.keys()[move_tooltip.type] + "\n"
	text += "Category: " + MoveData.Category.keys()[move_tooltip.category] + "\n"
	
	if move_tooltip.category != MoveData.Category.STATUS:
		text += "Power: " + str(move_tooltip.power) + "\n"
	
	text += "Accuracy: " + str(move_tooltip.accuracy) + "\n"
	text += "PP: " + str(move_tooltip.power_points) + "\n"

	if move_tooltip.description != "":
		text += "\n" + move_tooltip.description

	return text

#FIGHT MENU, CHOOSE YOUR MOVE

func _on_fight_button_pressed():
	main_menu.hide()
	fight_menu.show()

func _on_back_button_pressed():
	fight_menu.hide()
	main_menu.show()
	
func _on_run_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")
	print("You got away safely.")
		
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
	var move = battle.party_units[0].move_slots[move_index]

	if move == null:
		return

	selected_move_index = move_index

	var attacker = battle.party_units[0]

	match move.target:
		MoveData.Target.SELF:
			fight_menu.hide()

			battle.use_move(attacker, move, attacker)

			selected_move_index = -1
			main_menu.show()

		MoveData.Target.ENEMY:
			fight_menu.hide()
			$TargetMenu.show()

			create_target_buttons()

		MoveData.Target.ALL_ENEMIES:
			fight_menu.hide()

			battle.use_move_on_all_enemies(attacker, move)

			selected_move_index = -1
			main_menu.show()
	
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

	var attacker = battle.party_units[0]
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
	
func remove_fainted_party_label(index: int) -> void:
	if index < 0 or index >= party_hp_labels.size():
		return

	var hp_label = party_hp_labels[index]
	party_hp_labels.remove_at(index)
	hp_label.queue_free()	

func _on_enemy_fainted(index):
	var hp_label = enemy_hp_labels[index]
	hp_label.queue_free()
	enemy_hp_labels.remove_at(index)

	update_hp_display()

func _on_party_unit_fainted(index: int) -> void:
	remove_fainted_party_label(index)
	update_hp_display()

func _on_party_wiped() -> void:
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")

func _on_battle_won():
	print("All enemies were defeated!")
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")
	
func _input(event):
	if event.is_action_pressed("test_damage"):
		battle.test_party_damage()
		update_hp_display()
