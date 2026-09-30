extends Resource
class_name EncounterTable

@export var slot_1: SpeciesData #20%
@export var slot_2: SpeciesData #20%
@export var slot_3: SpeciesData #20%
@export var slot_4: SpeciesData #15%
@export var slot_5: SpeciesData #10%
@export var slot_6: SpeciesData #5%
@export var slot_7: SpeciesData #4%
@export var slot_8: SpeciesData #4%
@export var slot_9: SpeciesData #1%
@export var slot_10: SpeciesData #1%

func generate_encounter() -> Array[Resource]:
	var encounter: Array[Resource] = []
	var enemy_count = randi_range(1, 5)

	for i in range(enemy_count):
		encounter.append(get_random_species())

	return encounter


func get_random_species() -> Resource:
	var roll = randi_range(1, 100)

	if roll <= 20:
		return slot_1
	elif roll <= 40:
		return slot_2
	elif roll <= 60:
		return slot_3
	elif roll <= 75:
		return slot_4
	elif roll <= 85:
		return slot_5
	elif roll <= 90:
		return slot_6
	elif roll <= 94:
		return slot_7
	elif roll <= 98:
		return slot_8
	elif roll <= 99:
		return slot_9
	else:
		return slot_10
