class_name MoveData
extends Resource

enum Category {
	PHYSICAL,
	SPECIAL,
	STATUS
}

enum Target {
	ENEMY,
	SELF,
	ALL_ENEMIES
}

enum Effect {
	NONE,
	ATTACK_UP,
	ATTACK_DOWN,
	DEFENSE_UP,
	DEFENSE_DOWN,
	SP_ATTACK_UP,
	SP_ATTACK_DOWN,
	SP_DEFENSE_UP,
	SP_DEFENSE_DOWN,
	SPEED_UP,
	SPEED_DOWN
}

@export_category("Basic Information")
@export var move_name: String
@export_multiline var description: String

@export_category("Battle Properties")
@export var type: ElementalType.Type = ElementalType.Type.NORMAL
@export var category: Category = Category.PHYSICAL
@export var target: Target = Target.ENEMY

@export_category("Stats")
@export_range(0, 101) var accuracy: int = 100
@export var power_points: int = 10
@export var power: int = 0
@export_range(0, 100) var effect_rate: int = 0

@export_category("Properties")
@export var physical_contact: bool = false
@export var sound_type: bool = false

@export_category("Secondary Effect")
@export var effect: Effect = Effect.NONE
@export var stat_boost_stages: int = 0
