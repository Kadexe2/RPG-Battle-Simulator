extends RefCounted


var name = ""

var species_name = ""

var type_1: ElementalType.Type
var type_2: ElementalType.Type

var max_hp = 100
var current_hp = 100

var attack: int
var defense: int
var sp_attack: int
var sp_defense: int
var speed: int

var attack_stage: int = 0
var defense_stage: int = 0
var sp_attack_stage: int = 0
var sp_defense_stage: int = 0
var speed_stage: int = 0

var move_slots = [null, null, null, null]

func modify_attack_stage(stages: int):
	attack_stage = clamp(attack_stage + stages, -6, 6)


func modify_defense_stage(stages: int):
	defense_stage = clamp(defense_stage + stages, -6, 6)


func modify_sp_attack_stage(stages: int):
	sp_attack_stage = clamp(sp_attack_stage + stages, -6, 6)


func modify_sp_defense_stage(stages: int):
	sp_defense_stage = clamp(sp_defense_stage + stages, -6, 6)


func modify_speed_stage(stages: int):
	speed_stage = clamp(speed_stage + stages, -6, 6)

func get_stage_multiplier(stage: int) -> float:
	if stage >= 0:
		return 1.0 + (stage * 0.5)

	return 2.0 / (2.0 + abs(stage))
	
func get_effective_attack() -> int:
	return int(attack * get_stage_multiplier(attack_stage))


func get_effective_defense() -> int:
	return int(defense * get_stage_multiplier(defense_stage))


func get_effective_sp_attack() -> int:
	return int(sp_attack * get_stage_multiplier(sp_attack_stage))


func get_effective_sp_defense() -> int:
	return int(sp_defense * get_stage_multiplier(sp_defense_stage))


func get_effective_speed() -> int:
	return int(speed * get_stage_multiplier(speed_stage))
