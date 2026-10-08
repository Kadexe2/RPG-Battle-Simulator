class_name TypeEffectiveness

extends RefCounted

func get_multiplier(attacking_type: ElementalType.Type, defending_type: ElementalType.Type) -> float:
	if defending_type == ElementalType.Type.NONE:
		return 1.0

	return effectiveness[attacking_type][defending_type]

func get_total_multiplier(
	attacking_type: ElementalType.Type,
	defender_type_1: ElementalType.Type,
	defender_type_2: ElementalType.Type
) -> float:

	var multiplier = get_multiplier(attacking_type, defender_type_1)

	if defender_type_2 != ElementalType.Type.NONE:
		multiplier *= get_multiplier(attacking_type, defender_type_2)

	return multiplier

var effectiveness = {
	ElementalType.Type.NORMAL: {
		ElementalType.Type.NORMAL: 1.0,
		ElementalType.Type.FIRE: 1.0,
		ElementalType.Type.WATER: 1.0,
		ElementalType.Type.GRASS: 1.0,
		ElementalType.Type.ELECTRIC: 1.0,
		ElementalType.Type.ROCK: 0.5,
		ElementalType.Type.FLYING: 1.0,
		ElementalType.Type.FIGHTING: 1.0,
		ElementalType.Type.DARK: 1.0,
		ElementalType.Type.PSYCHIC: 1.0,
		ElementalType.Type.STEEL: 0.5,
		ElementalType.Type.GROUND: 1.0,
		ElementalType.Type.BUG: 1.0,
		ElementalType.Type.POISON: 1.0,
		ElementalType.Type.ICE: 1.0,
		ElementalType.Type.DRAGON: 1.0,
		ElementalType.Type.GHOST: 0.0,
		ElementalType.Type.FAIRY: 1.0
	},

	ElementalType.Type.FIRE: {
		ElementalType.Type.NORMAL: 1.0,
		ElementalType.Type.FIRE: 0.5,
		ElementalType.Type.WATER: 0.5,
		ElementalType.Type.GRASS: 2.0,
		ElementalType.Type.ELECTRIC: 1.0,
		ElementalType.Type.ROCK: 0.5,
		ElementalType.Type.FLYING: 1.0,
		ElementalType.Type.FIGHTING: 1.0,
		ElementalType.Type.DARK: 1.0,
		ElementalType.Type.PSYCHIC: 1.0,
		ElementalType.Type.STEEL: 2.0,
		ElementalType.Type.GROUND: 1.0,
		ElementalType.Type.BUG: 2.0,
		ElementalType.Type.POISON: 1.0,
		ElementalType.Type.ICE: 2.0,
		ElementalType.Type.DRAGON: 0.5,
		ElementalType.Type.GHOST: 1.0,
		ElementalType.Type.FAIRY: 1.0
	}
}
