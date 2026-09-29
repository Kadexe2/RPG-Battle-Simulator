extends RefCounted

const BattleUnit = preload("res://Scripts/battle_unit.gd")


func calculate_damage(power: int, attacker: BattleUnit, defender: BattleUnit) -> int:
	var damage = (10.0 * power * attacker.attack / defender.defense) / 50.0
	return int(damage)


func deal_damage(target: BattleUnit, damage: int):
	target.current_hp = clamp(
		target.current_hp - damage,
		0,
		target.max_hp
	)

	print(target.name + " took " + str(damage) + " damage")
