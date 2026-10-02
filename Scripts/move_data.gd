extends RefCounted

class_name MoveData

enum Category {
	PHYSICAL,
	SPECIAL,
	STATUS
}

enum Target {
	ENEMY,
	SELF
}

var moves = {
	"Scratch": {
		"name": "Scratch",
		"type": ElementalType.Type.NORMAL,
		"category": Category.PHYSICAL,
		"target": Target.ENEMY,
		"power": 40
	},

	"Growl": {
		"name": "Growl",
		"type": ElementalType.Type.NORMAL,
		"category": Category.STATUS,
		"target": Target.ENEMY,
		"message": "Growl!"
	},

	"Howl": {
		"name": "Howl",
		"type": ElementalType.Type.NORMAL,
		"category": Category.STATUS,
		"target": Target.SELF,
		"effect": "attack_up"
	},

	"Fire Punch": {
		"name": "Fire Punch",
		"type": ElementalType.Type.FIRE,
		"category": Category.PHYSICAL,
		"target": Target.ENEMY,
		"power": 75
	},

	"Ember": {
		"name": "Ember",
		"type": ElementalType.Type.FIRE,
		"category": Category.SPECIAL,
		"target": Target.ENEMY,
		"power": 40
	}
}
