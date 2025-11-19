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

			# Optional extra connections 
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
	
	
func get_closest_node(node, next_layer):
	var col = node.column_index
	# if same column exists in next layer pick that first
	if col < next_layer.size():
		return next_layer[col]

	# otherwise clamp to last index (use closest available)
	return next_layer[next_layer.size() - 1]

func get_adjacent_node(node, next_layer, offset):
	var new_col = node.column_index + offset

	if new_col >= 0 and new_col < next_layer.size():
		return next_layer[new_col]

	return null
	
func get_node_position(row: int, col: int) -> Vector2:
	# tweak later
	var start_x := 200
	var start_y := 200
	var spacing_x := 300
	var spacing_y := 250

	var x = start_x + (col * spacing_x)
	var max_rows := 12
	var y = start_y + ((max_rows - row) * spacing_y)

	return Vector2(x, y)
	 
func spawn_node_visuals():
	print("Spawning visuals...")
	for child in node_container.get_children():
		child.queue_free()

	for layer in map_tree:
		for node in layer:
			var view = MapNodeViewScene.instantiate()
			print("View:", view) 
			view.set_node_data(node)
			view.position = get_node_position(node.row_index, node.column_index)
			node.view = view
			node_container.add_child(view)
			
	$ScrollContainer/MapView/Paths.queue_redraw()
	
func _ready():
	print("MAP READY")
	print("Loaded scene:", MapNodeViewScene)
	generate_random_map()
	$ScrollContainer/MapView/Paths.map_scene = self

	
	
	
	
	
	
	
	
