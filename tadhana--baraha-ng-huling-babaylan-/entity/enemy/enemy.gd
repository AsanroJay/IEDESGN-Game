extends Entity
class_name Enemy

var animation_data: Dictionary

func _init(enemy_type):
	load_enemy_data(enemy_type)

func load_enemy_data(type):
	var db = {
		"default": {
			"name": "Default Enemy",
			"hp": 40,
			"mana": 0,
			"frames": "res://entity/enemy/animations/default_frames.tres"
		},
		"sigbin": {
			"name": "Sigbin",
			"hp": 60,
			"mana": 0,
			"frames": "res://entity/enemy/animations/sigbin_frames.tres"
		},
		"white_lady": {
			"name": "White Lady",
			"hp": 75,
			"mana": 0,
			"frames": "res://entity/enemy/animations/white_lady_frames.tres"
		}
	}

	animation_data = db[type]
	entity_name = animation_data["name"]
	hp = animation_data["hp"]
	max_hp = animation_data["hp"]
	mana = animation_data["mana"]
