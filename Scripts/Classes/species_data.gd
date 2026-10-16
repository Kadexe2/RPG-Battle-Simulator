class_name SpeciesData
extends Resource

@export var species_name: String = ""

@export var base_hp: int = 1
@export var base_attack: int = 1
@export var base_defense: int = 1
@export var base_sp_attack: int = 1
@export var base_sp_defense: int = 1
@export var base_speed: int = 1

@export var type_1: ElementalType.Type = ElementalType.Type.NONE
@export var type_2: ElementalType.Type = ElementalType.Type.NONE

@export var learnset: Array[MoveData] = []
