extends Node
class_name Map

#Scene variables
@onready var node_container = $ScrollContainer/MapView/NodeContainer 
var MapNodeViewScene = preload("res://map/scenes/map_node_view.tscn") 

var image_dict = {
	"default": "res://assets/background_default.png"
}

var location
var map_tree = [] 
var background_image

func generate_random_map() -> void:
	map_tree.clear()
	#define layer rules
	var max_layers = 12
	#randomize how many nodes per tree layer
	for layer in range(1,max_layers + 1):
		var count = 0
		if layer == 1 or layer == 11:
			count = 4
		elif layer == 12:
			count = 1	
		else:
			count = floor(randf_range(2.5,4.7))
		
		var layer_array = create_map_node_array(count,layer) #will hold the map_nodes for current layer
		map_tree.append(layer_array)
		
	connect_nodes()
	spawn_node_visuals()
	
	

func create_map_node_array(count,layer): #instantiates map_node objects into a map_tree layer
	var map_node_array = []
	for index in range(count):
		var map_node = MapNode.new()
		map_node.row_index = layer
		map_node.column_index = index
		map_node.type = define_layer_rule(layer)
		map_node_array.append(map_node)
		
	return map_node_array
	
func define_layer_rule(layer) -> String: #assigns a random map_node type based on predefined rules
	var layer_rules = {
		1: ["mystery","encounter"],
		2: ["mystery","encounter"],
		3: ["mystery","encounter"],
		4: ["rest","shop","buffed"],
		5: ["encounter","mystery","shop","buffed"],
		6: ["encounter","mystery","buffed"],
		7: ["encounter","mystery","shop"],
		8: ["rest","shop","mystery"],
		9: ["encounter","mystery","buffed"],
		10: ["encounter","mystery","shop"],
		11: ["rest"],
		12: ["boss"]
	}

	var rule = layer_rules[layer]
	var type = randi_range(0,rule.size() - 1)
	return rule[type]
	
	
func connect_nodes():
	for layer in range(map_tree.size() - 1): 
		var current_layer = map_tree[layer]
		var next_layer = map_tree[layer + 1]

		for node in current_layer:
			# Always connect to at least one node in the next layer (same column usually)
			var target = get_closest_node(node, next_layer)
			node.connections.append(target)

			# Connect left
			if randf() < 0.35:
				var left = get_adjacent_node(node, next_layer, -1)
				if left:
					node.connections.append(left)

			# Connect right
			if randf() < 0.35:
				var right = get_adjacent_node(node, next_layer, 1)
				if right:
					node.connections.append(right)
	
	for layer in range(map_tree.size() - 1):
		var current_layer = map_tree[layer]
		var next_layer = map_tree[layer + 1]

		for next_node in next_layer:
			var has_parent = false

			# check all previous layer nodes
			for node in current_layer:
				if next_node in node.connections:
					has_parent = true
					break

			# if no parent, connect to closest parent
			if not has_parent:
				var closest = reverse_get_closest_node(next_node, current_layer)
				closest.connections.append(next_node)
	
	
func get_closest_node(node, next_layer):
	var col = node.column_index
	# if same column exists in next layer pick that first
	if col < next_layer.size():
		return next_layer[col]

	# otherwise clamp to last index (use closest available)
	return next_layer[next_layer.size() - 1]
	
func reverse_get_closest_node(child_node, prev_layer):
	var col = child_node.column_index
	
	if col < prev_layer.size():
		return prev_layer[col]

	return prev_layer[prev_layer.size() - 1]


func get_adjacent_node(node, next_layer, offset):
	var new_col = node.column_index + offset

	if new_col >= 0 and new_col < next_layer.size():
		return next_layer[new_col]

	return null
	
func get_node_position(row: int, col: int) -> Vector2:
	# tweak later
	var start_x := 200
	var start_y := 200
	var spacing_x = randomize_x_spacing()
	var spacing_y = randomize_y_spacing()

	var x = start_x + (col * spacing_x)
	var max_rows := 12
	var y = start_y + ((max_rows - row) * spacing_y)

	return Vector2(x, y)
	
func randomize_x_spacing():
	return randf_range(275,300)
	
func randomize_y_spacing():
	return randf_range(290,300)
	 
func spawn_node_visuals():
	print("Spawning visuals...")
	for child in node_container.get_children():
		child.queue_free()

	for layer in map_tree:
		for node in layer:
			var view = MapNodeViewScene.instantiate()
			#print("View:", view) this is a debug print
			view.set_node_data(node)
			view.position = get_node_position(node.row_index, node.column_index)
			node.view = view
			node_container.add_child(view)
			view.node_clicked.connect(_on_node_clicked)

			
	$ScrollContainer/MapView/Paths.queue_redraw()

func snap_to_bottom_layer():
	var scroll := $ScrollContainer
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _on_node_clicked(node):
	GameManager.enter_room(node)
	
func _ready():
	print("MAP READY")
	print("Loaded scene:", MapNodeViewScene)
	generate_random_map()
	$ScrollContainer/MapView/Paths.map_scene = self
	await get_tree().process_frame
	snap_to_bottom_layer()


	
	
	
	
	
	
	
	
