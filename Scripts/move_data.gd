extends RefCounted

var moves = {
	
"Scratch": {
	"name": "Scratch",
	"type": ElementalType.Type.NORMAL,
	"category": "Physical",
	"target": "Enemy",
	"power": 40
},

"Growl": {
	"name": "Growl",
	"type": ElementalType.Type.NORMAL,
	"category": "Status",
	"target": "Enemy",
	"message": "Growl!"
},

"Howl": {
	"name": "Howl",
	"type": ElementalType.Type.NORMAL,
	"category": "Status",
	"target": "Self",
	"effect": "attack_up"
},

"Fire Punch": {
	"name": "Fire Punch",
	"type": ElementalType.Type.FIRE,
	"category": "Physical",
	"target": "Enemy",
	"power": 75
},

"Ember": {
	"name": "Ember",
	"type": ElementalType.Type.FIRE,
	"category": "Special",
	"target": "Enemy",
	"power": 40
},

}
