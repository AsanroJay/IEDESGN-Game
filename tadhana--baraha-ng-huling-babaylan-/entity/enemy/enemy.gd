extends Entity
class_name Enemy

var animation_data: Dictionary
var resistance: String
var armor: int

func _init(enemy_type):
	load_enemy_data(enemy_type)

func load_enemy_data(type):
	var db = {
		"default": {
			"name": "Default Enemy",
			"hp": 40,
			"mana": 0,
			"armor": 0,
			"resistance":0,
			"frames": "res://entity/enemy/animations/default_frames.tres"
		},
		"aswang": {
			"name": "aswang",
			"hp": 42,
			"mana": 0,
			"armor": 2,
			"resistance":0,
			"frames": "res://entity/enemy/animations/aswang.tres"
		},
		"manananggal": {
			"name": "manananggal",
			"hp": 30,
			"mana": 0,
			"armor": 0,
			"resistance":0,
			"frames": "res://entity/enemy/animations/manananggal.tres"
		},
		"white_lady": {
			"name": "white_lady",
			"hp": 40,
			"mana": 0,
			"armor": 0,
			"resistance":0,
			"frames": "res://entity/enemy/animations/white_lady.tres"
		},
		"kapre": {
			"name": "kapre",
			"hp": 60,
			"mana": 0,
			"armor": 5,
			"resistance":0,
			"frames": "res://entity/enemy/animations/kapre.tres"
		},
			"sigbin": {
			"name": "sigbin",
			"hp": 40,
			"mana": 0,
			"armor": 2,
			"resistance":0,
			"frames": "res://entity/enemy/animations/sigbin.tres"
		},
			"mangkukulam": {
			"name": "mangkukulam",
			"hp": 55,
			"mana": 0,
			"armor": 0,
			"resistance":0,
			"frames": "res://entity/enemy/animations/mangkukulam.tres"
		}
	}

	animation_data = db[type]
	entity_name = animation_data["name"]
	hp = animation_data["hp"]
	max_hp = animation_data["hp"]
	mana = animation_data["mana"]
	armor = animation_data["armor"]
	
func take_damage(damage):
	print("Enemy taking " + str(damage) + "damage!")
	hp -= damage
	
