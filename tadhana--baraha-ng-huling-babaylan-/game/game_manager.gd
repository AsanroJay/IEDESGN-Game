extends Node

var player
var map_scene: Node = null
var current_room: Node = null

enum GameState { MAP, BATTLE, SHOP, REST, BOSS }
var state = GameState.MAP

func load_map():
	if map_scene == null:
		map_scene = load("res://map/scenes/map.tscn").instantiate()
		get_tree().root.add_child(map_scene)

	map_scene.visible = true
	state = GameState.MAP
	

func enter_room(node):
	var type = node.type
	match type:
		"encounter": 
			print("Entering encounter...")
			start_battle_from_node(node)
		"buffed": 
			print("Entering buffed encounter...")
		"shop": 
			print("Entering shop...")
		"rest": 
			print("Entering rest site...")
		"mystery": 
			print("Entering random encounter...")
		"boss": 
			print("Entering boss fight...")
		_: 
			print("Not a room type!")
		
			

func start_battle_from_node(node):
	state = GameState.BATTLE
	
	# hide the map instead of removing it
	if map_scene:
		map_scene.visible = false

	# load battle room
	current_room = load("res://levels/battle/battle_room.tscn").instantiate()
	get_tree().root.add_child(current_room)

	# pass info to room and the global player
	current_room.start_battle_from_node(node, player)

func return_to_map():
	if current_room:
		current_room.queue_free()
		current_room = null

	if map_scene:
		map_scene.visible = true

	state = GameState.MAP


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
