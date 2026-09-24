extends RefCounted

func deal_damage(target, damage):
	target.current_hp = clamp(
		target.current_hp - damage,
		0,
		target.max_hp
	)
