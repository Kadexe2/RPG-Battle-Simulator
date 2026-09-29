extends RefCounted

const BattleUnit = preload("res://Scripts/battle_unit.gd")
const Damage = preload("res://Scripts/damage.gd")

var damage = Damage.new()

var party_units = []
var enemy_units = []

signal damage_dealt
signal enemy_fainted(index)
signal battle_won

func setup(party, enemies):
	party_units = party
	enemy_units = enemies


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

	if target.current_hp == 0:
		var target_index = enemy_units.find(target)
		faint_enemy(target_index)


func faint_enemy(index):
	var enemy = enemy_units[index]

	print(enemy.name + " fainted")

	enemy_units.remove_at(index)

	enemy_fainted.emit(index)

	if enemy_units.is_empty():
		battle_won.emit()
		
