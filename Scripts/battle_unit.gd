extends RefCounted


var name = ""

var species_name = ""
var max_hp = 100
var current_hp = 100
var attack: int
var defense: int

var move_slots = [null, null, null, null]

var attack_stage = 0

func get_effective_attack() -> int:
	var multiplier = 1.0 + (attack_stage * 0.5)
	return int(attack * multiplier)
