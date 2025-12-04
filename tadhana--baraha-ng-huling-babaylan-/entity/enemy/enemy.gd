extends Entity
class_name Enemy

# Enemy data loaded from db (animation_data holds template values)
var animation_data: Dictionary = {}
var resistance: String = ""
var armor: int = 0


# Multiplier applied to this enemy's stats (1.0 = normal)
var buff_multiplier: float = 1.0

func _init(enemy_type):
	# CRITICAL: Always start with base multiplier
	buff_multiplier = 1.0
	load_enemy_data(enemy_type)

func load_enemy_data(type):
	var db = {
		"default": {
			"name": "Default Enemy",
			"hp": 40,
			"mana": 0,
			"armor": 0,
			"resistance": 0,
			"frames": "res://entity/enemy/animations/default_frames.tres"
		},
		"aswang": {
			"name": "Aswang",
			"hp": 50,
			"mana": 0,
			"armor": 0,
			"frames": "res://entity/enemy/animations/aswang.tres"
		},
		"manananggal": {
			"name": "Manananggal",
			"hp": 40,
			"mana": 0,
			"armor": 0,
			"frames": "res://entity/enemy/animations/manananggal.tres"
		},
		"white_lady": {
			"name": "White Lady",
			"hp": 40,
			"mana": 0,
			"armor": 0,
			"frames": "res://entity/enemy/animations/white_lady.tres"
		},
		"kapre": {
			"name": "Kapre",
			"hp": 40,
			"mana": 0,
			"armor": 0,
			"frames": "res://entity/enemy/animations/kapre.tres"
		}
	}

	# Defensive access in case an unknown type is requested
	if not db.has(type):
		type = "default"

	# Create a copy of the dictionary to avoid shared references
	animation_data = db[type].duplicate(true)
	entity_name = animation_data.get("name", "Enemy")
	
	# CRITICAL: Always load base stats directly from animation_data (never buffed)
	var base_hp = int(animation_data.get("hp", 10))
	var base_armor = int(animation_data.get("armor", 0))
	
	max_hp = base_hp
	hp = base_hp
	armor = base_armor
	resistance = str(animation_data.get("resistance", ""))

	# Ensure buff multiplier is default 1.0 at load; battle_manager can call apply_buff after creation.
	buff_multiplier = 1.0
	
	# Debug: Verify enemy starts with base stats
	print("Enemy._init: Created ", entity_name, " with base stats → HP:", hp, " Max HP:", max_hp, " Armor:", armor, " Buff multiplier:", buff_multiplier)

func apply_buff(multiplier: float) -> void:
	"""
	Apply a numeric multiplier to the enemy's gameplay stats.
	DOES NOT modify animation_data (keeps templates/frames untouched).
	"""
	if multiplier == 1.0:
		return

	buff_multiplier = multiplier

	# Scale main numeric fields used in gameplay (leave animation_data alone)
	max_hp = int(round(max_hp * multiplier))
	hp = max_hp # spawn at full health after buff
	armor = int(round(armor * multiplier))

func take_damage(damage: int) -> void:
	# Apply armor reduction (simple flat armor)
	var net = damage - armor
	if net < 0:
		net = 0

	print("Enemy taking " + str(net) + " damage (raw: " + str(damage) + ", armor: " + str(armor) + ")")
	hp -= net

	# Clamp hp
	if hp < 0:
		hp = 0
