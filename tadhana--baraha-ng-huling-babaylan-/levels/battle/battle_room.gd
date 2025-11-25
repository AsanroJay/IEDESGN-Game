extends Node2D
class_name BattleRoom

# Preload BattleManager (NOT entity nodes)
var BattleManagerScene = preload("res://levels/battle/battle_manager.gd")
var battle_manager

var player
var enemy 

func start_battle_from_node(node_info, player_ref):
	# Create BattleManager instance
	battle_manager = BattleManagerScene.new()

	# Add it under the BattleRoom
	add_child(battle_manager)

	# Begin battle
	battle_manager.start_battle(self, node_info, player_ref)


func _ready():
	pass


func _on_map_button_pressed():
	GameManager.return_to_map()


func _on_play_area_area_entered(area: Area2D) -> void:
	if area is CardNode:
		area.is_in_play_area = true
		

func _on_play_area_area_exited(area: Area2D) -> void:
	if area is CardNode:
		area.is_in_play_area = false
