extends RefCounted

const BattleUnit = preload("res://Scripts/battle_unit.gd")
const Damage = preload("res://Scripts/damage.gd")

var damage = Damage.new()

var party_units = []
var enemy_units = []

signal damage_dealt
signal enemy_fainted(index)
signal battle_won

func setup(party, enemy_species):
	party_units = party
	create_enemy_units(enemy_species)
	print_enemy_attack_message()

func create_enemy_units(enemy_species):
	for i in range(enemy_species.size()):
		var species_data = enemy_species[i]

		var enemy_unit = BattleUnit.new()
		enemy_unit.species_name = species_data.species_name
		enemy_unit.name = "Enemy " + str(i + 1)
		enemy_unit.type_1 = species_data.type_1
		enemy_unit.type_2 = species_data.type_2
		enemy_unit.max_hp = species_data.base_hp
		enemy_unit.current_hp = enemy_unit.max_hp
		enemy_unit.attack = species_data.base_attack
		enemy_unit.defense = species_data.base_defense
		enemy_unit.sp_attack = species_data.base_sp_attack
		enemy_unit.sp_defense = species_data.base_sp_defense

		enemy_units.append(enemy_unit)
	
	assign_enemy_names()

func assign_enemy_names():
	var species_counts = {}

	for enemy in enemy_units:
		if not species_counts.has(enemy.species_name):
			species_counts[enemy.species_name] = 0

		species_counts[enemy.species_name] += 1

	for species_name in species_counts:
		if species_counts[species_name] > 1:
			var number = 1

			for enemy in enemy_units:
				if enemy.species_name == species_name:
					enemy.name = species_name + " " + str(number)
					number += 1
		else:
			for enemy in enemy_units:
				if enemy.species_name == species_name:
					enemy.name = species_name

func print_enemy_attack_message():
	var names = []

	for enemy in enemy_units:
		names.append(enemy.name)

	if names.size() == 1:
		print(names[0] + " attacked!")
	elif names.size() == 2:
		print(names[0] + " and " + names[1] + " attacked!")
	else:
		var message = ""

		for i in range(names.size()):
			if i == names.size() - 1:
				message += "and " + names[i]
			else:
				message += names[i] + ", "

		print(message + " attacked!")

func use_move(attacker: BattleUnit, move, target: BattleUnit):
	if move == null:
		return

	if move.has("power"):
		var multiplier = damage.get_effectiveness_multiplier(
			move["type"],
			target
		)

		if multiplier >= 2.0:
			print("It's super effective!")
		elif multiplier <= 0.5:
			print("It's not very effective...")

	var damage_amount = damage.calculate_damage(
		move["power"],
		move["type"],
		attacker,
		target,
		move["category"]
	)

	damage.deal_damage(target, damage_amount)
	damage_dealt.emit()

	if move.has("message"):
		print(move["message"])

	if move.has("effect"):
		apply_move_effect(move, attacker)

	if target != null and target.current_hp == 0:
		var target_index = enemy_units.find(target)
		faint_enemy(target_index)
		
func apply_move_effect(move, target: BattleUnit):
	if not move.has("effect"):
		return

	match move["effect"]:
		"attack_up":
			target.attack_stage = clamp(
				target.attack_stage + 1,
				0,
				6
			)

			print(target.name + "'s Attack rose!")

func faint_enemy(index):
	var enemy = enemy_units[index]

	print(enemy.name + " fainted!")

	enemy_units.remove_at(index)

	enemy_fainted.emit(index)

	if enemy_units.is_empty():
		battle_won.emit()
		
