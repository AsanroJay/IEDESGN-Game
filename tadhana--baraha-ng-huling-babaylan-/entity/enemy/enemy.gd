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
		"aswang": {
			"name": "Aswang",
			"hp": 50,
			"mana": 0,
			"frames": "res://entity/enemy/animations/aswang.tres"
		},
		"mananaggal": {
			"name": "Manananggal",
			"hp": 30,
			"mana": 0,
			"frames": "res://entity/enemy/animations/manananggal.tres"
		}
	}

	animation_data = db[type]
	entity_name = animation_data["name"]
	hp = animation_data["hp"]
	max_hp = animation_data["hp"]
	mana = animation_data["mana"]
	
func take_damage(damage):
	print("Enemy taking " + str(damage) + "damage!")
	hp -= damage
	
