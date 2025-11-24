extends Node

var player_entity
var player_node

var PlayerNodeScene = preload("res://entity/player/player_node.tscn")


func load_shop_room(node_info, player_ref):
	# store player entity
	player_entity = player_ref

	# CREATE PLAYER VISUAL NODE
	player_node = PlayerNodeScene.instantiate()
	get_node("PlayerContainer").add_child(player_node)

	player_node.set_entity(player_entity)
	var spawn_point = get_node("PlayerContainer/PlayerSpawn").global_position
	player_node.global_position = spawn_point
	

	


	print("Shop initialized successfully ")


func _on_map_button_pressed() -> void:
	GameManager.return_to_map()


func _on_open_shop_pressed() -> void:
	print("Shop button clicked!")
	pass # Replace with function body.


func _on_hover_area_mouse_entered() -> void:
	var sprite = $ShopKeeperContainer/TextureRect
	# white highlight
	sprite.modulate = Color(1.2, 1.2, 1.2)


func _on_hover_area_mouse_exited() -> void:
	var sprite = $ShopKeeperContainer/TextureRect
	# white highlight
	sprite.modulate = Color(1, 1, 1)
