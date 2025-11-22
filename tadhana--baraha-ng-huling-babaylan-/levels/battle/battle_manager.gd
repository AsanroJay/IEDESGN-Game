extends Node

var player_entity
var enemy_entity
var player_node
var enemy_node

var PlayerNodeScene = preload("res://entity/player/player_node.tscn")
var EnemyNodeScene  = preload("res://entity/enemy/enemy_node.tscn")

func start_battle(battleroom, node_info, player_ref):
	# store player entity
	player_entity = player_ref

	# CREATE PLAYER VISUAL NODE
	player_node = PlayerNodeScene.instantiate()
	battleroom.get_node("PlayerContainer").add_child(player_node)

	player_node.set_entity(player_entity)
	var spawn_point = battleroom.get_node("PlayerContainer/PlayerSpawn").global_position
	player_node.global_position = spawn_point


	# CREATE ENEMY ENTITY
	var enemy_type = generate_random_enemy(node_info)
	enemy_entity = Enemy.new(enemy_type)  # handle stats inside enemy.gd


	# CREATE ENEMY VISUAL NODE
	enemy_node = EnemyNodeScene.instantiate()
	battleroom.get_node("EnemyContainer").add_child(enemy_node)

	enemy_node.set_entity(enemy_entity)
	var enemy_spawn = battleroom.get_node("EnemyContainer/EnemySpawn").global_position
	enemy_node.global_position = enemy_spawn


	print("Battle initialized successfully with enemy:", enemy_type)


# This function returns a STRING only
func generate_random_enemy(node_info):
	var layer_rules = {
		1: ["default"],
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

	var list = layer_rules[node_info.row_index]
	var i = randi_range(0, list.size() - 1)
	return list[i]
