extends Node2D
class_name BattleRoom

var player
var enemy 

func start_battle_from_node(node, player_var):
	player = player_var
	var enemy_type = generate_random_enemy(node)
	print("Random enemy: ", enemy_type)

func generate_random_enemy(node):
	var layer_rules = {
		1: ["default","sigbin","white lady"],
		2: ["default"],
		3: ["default"],
		4: ["default"],
		5: ["default"],
		6: ["default"],
		7: ["default"],
		8: ["default"],
		9: ["default"],
		10: ["default"],
		11: ["default"],
		12: ["default"]
	}
	var layer =  layer_rules[node.row_index]
	var index = randi_range(0,layer.size() -1)
	return layer[index]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_map_button_pressed() -> void:
	GameManager.return_to_map()
