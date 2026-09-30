extends RefCounted


func generate_encounter() -> Array:
	var enemy_species = []
	var enemy_count = randi_range(1, 6)

	for i in range(enemy_count):
		var roll = randf()

		if roll < 0.9:
			enemy_species.append("Caterpie")
		else:
			enemy_species.append("Metapod")

	return enemy_species
