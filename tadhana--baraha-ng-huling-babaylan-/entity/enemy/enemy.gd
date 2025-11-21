extends Entity
class_name Enemy


func _init(enemy_name,enemy_hp,enemy_mana):
	entity_name = enemy_name
	hp = enemy_hp
	mana = enemy_mana
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
