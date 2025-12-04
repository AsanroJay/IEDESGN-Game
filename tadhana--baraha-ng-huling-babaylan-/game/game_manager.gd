extends Node

var player
var map_scene: Node = null
var current_room: Node = null

enum GameState { MAP, BATTLE, SHOP, REST, BOSS, BUFFED }
var state = GameState.MAP

func load_map():
	if player == null:
		player = Player.new()
		print("Player initialized:", player)
		
	if map_scene == null:
		map_scene = load("res://map/scenes/map.tscn").instantiate()
		print("Map initialized")
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
			start_buffed_battle_from_node(node)
		"shop": 
			print("Entering shop...")
			enter_shop(node)
		"rest": 
			print("Entering rest site...")
			enter_rest_site(node)
		"mystery": 
			print("Entering random encounter...")
			generate_random_encounter(node)
		"boss": 
			print("Entering boss fight...")
		_: 
			print("Not a room type!")
		
			

func start_battle_from_node(node):
	print("GameManager: Starting NORMAL battle")
	state = GameState.BATTLE
	
	# hide the map instead of removing it
	if map_scene:
		map_scene.visible = false

	# load battle room
	current_room = load("res://levels/battle/battle_room.tscn").instantiate()
	get_tree().root.add_child(current_room)

	# pass info to room and the global player
	current_room.start_battle_from_node(node, player)
	print("GameManager: Normal battle room loaded and started")
	
func start_buffed_battle_from_node(node):
	print("GameManager: Starting BUFFED battle")
	state = GameState.BUFFED
	
	# hide the map instead of removing it
	if map_scene:
		map_scene.visible = false

	# load battle room
	current_room = load("res://levels/buffed battle/buffed_battle.tscn").instantiate()
	get_tree().root.add_child(current_room)

	# pass info to room and the global player (buffed battle room uses same method name)
	current_room.start_battle_from_node(node, player)
	print("GameManager: Buffed battle room loaded and started")

func return_to_map():
	if current_room:
		current_room.queue_free()
		current_room = null

	if map_scene:
		map_scene.visible = true

	state = GameState.MAP

func generate_random_encounter(node):
	var rand_num = randf_range(0,1)
	
	if rand_num >= 0.4:
		print("Random encounter room: Battle")
		start_battle_from_node(node)
	elif rand_num > 0.2 and rand_num < 0.4:
		print("Random encounter room: Shop")
		enter_shop(node)
	else:
		print("Random encounter room: Rest Site")
		enter_rest_site(node)

func enter_shop(node):
	state = GameState.SHOP
	
	if map_scene:
		map_scene.visible = false
		
	current_room = load("res://levels/shop/shop.tscn").instantiate()
	get_tree().root.add_child(current_room)
		
	current_room.load_shop_room(node,player)
	
func enter_rest_site(node):
	state = GameState.REST
	
	if map_scene:
		map_scene.visible = false
		
	current_room = load("res://levels/rest/rest.tscn").instantiate()
	get_tree().root.add_child(current_room)
		
	current_room.load_rest_room(node,player)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_map()
