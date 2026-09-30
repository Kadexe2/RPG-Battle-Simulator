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

func create_enemy_units(enemy_species):
	for i in range(enemy_species.size()):
		var species_name = enemy_species[i]
		var species_data = load("res://Data/Species/" + species_name + ".tres")

		var enemy_unit = BattleUnit.new()
		enemy_unit.name = "Enemy " + str(i + 1)
		enemy_unit.max_hp = species_data.base_hp
		enemy_unit.current_hp = enemy_unit.max_hp
		enemy_unit.attack = species_data.base_attack
		enemy_unit.defense = species_data.base_defense

		enemy_units.append(enemy_unit)

func use_move(attacker: BattleUnit, move, target: BattleUnit):
	if move == null:
		return

	if move.has("power"):
		var damage_amount = damage.calculate_damage(
			move["power"],
			attacker,
			target
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
		
