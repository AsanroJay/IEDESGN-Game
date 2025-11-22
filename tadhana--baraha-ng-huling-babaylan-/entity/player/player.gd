extends Entity
class_name Player

var sprite_path : String = "res://player/assets/player.png"
var discard_pile = []
var draw_pile = []
var gold
#Constructor
func _init(name) -> void:
	entity_name = name
	gold = 0

func set_enemy_type(enemy_name: String):
	name = enemy_name

	match enemy_name:
		"sigbin":
			sprite_path = "res://enemy/assets/sigbin.png" 
		"white lady":
			sprite_path = "res://enemy/assets/white lady.png"
		"mananaggal":
			sprite_path = "res://enemy/assets/mananaggal.png"
		_:
			sprite_path = "res://enemy/assets/default_enemy.png"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
