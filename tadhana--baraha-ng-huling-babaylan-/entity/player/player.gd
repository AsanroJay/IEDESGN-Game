extends Entity
class_name Player

var discard_pile = []
var draw_pile = []
var gold
#Constructor
func _init(name) -> void:
	entity_name = name
	gold = 0
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
