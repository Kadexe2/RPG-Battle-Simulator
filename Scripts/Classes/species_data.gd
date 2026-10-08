class_name SpeciesData
extends Resource

@export var base_hp: int = 1
@export var base_attack: int = 1
@export var base_defense: int = 1
@export var base_sp_attack: int = 1
@export var base_sp_defense: int = 1
@export var base_speed: int = 1

@export var type_1: ElementalType.Type = ElementalType.Type.NONE
@export var type_2: ElementalType.Type = ElementalType.Type.NONE

var species_name: String:
	get:
		return resource_path.get_file().get_basename()
