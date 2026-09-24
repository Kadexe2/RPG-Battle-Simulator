extends RefCounted

const Damage = preload("res://Scripts/damage.gd")
	
func use(target):
	var damage = Damage.new()
	damage.deal_damage(target,20)
