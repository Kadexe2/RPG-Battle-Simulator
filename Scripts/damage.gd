extends RefCounted

const BattleUnit = preload("res://Scripts/battle_unit.gd")

var type_effectiveness = TypeEffectiveness.new()

func get_effectiveness_multiplier(
	move_type: ElementalType.Type,
	defender: BattleUnit
) -> float:
	return type_effectiveness.get_total_multiplier(
		move_type,
		defender.type_1,
		defender.type_2
	)

func calculate_damage(
	power: int,
	move_type: ElementalType.Type,
	attacker: BattleUnit,
	defender: BattleUnit,
	category: String
) -> int:
	var attacking_stat
	var defending_stat

	if category == "Physical":
		attacking_stat = attacker.get_effective_attack()
		defending_stat = defender.defense
	elif category == "Special":
		attacking_stat = attacker.sp_attack
		defending_stat = defender.sp_defense
	
	print("Attacking stat: ", attacking_stat)
	print("Defending stat: ", defending_stat)
	
	var damage = (10.0 * power * attacking_stat / defending_stat) / 50.0

	var multiplier = get_effectiveness_multiplier(move_type, defender)

	damage *= multiplier

	return int(damage)


func deal_damage(target: BattleUnit, damage: int):
	target.current_hp = clamp(
		target.current_hp - damage,
		0,
		target.max_hp
	)

	print(target.name + " took " + str(damage) + " damage.")
