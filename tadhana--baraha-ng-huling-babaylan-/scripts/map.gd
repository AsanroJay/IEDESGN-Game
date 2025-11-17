extends Node
class_name Map

var image_dict = {
	"default": "res://assets/background_default.png"
}

var location
var map_tree = [] 
var background_image

func generate_random_map() -> void:
	#define layer rules
	var max_layers = 12
	#randomize how many nodes per tree layer
	for layer in range(1,max_layers + 1):
		var count = 0
		if layer == 1:
			count = 4
		else:
			count = floor(randf_range(2.5,4.7))
		
		var layer_array = []	#will hold the map_nodes for current layer
		layer_array = create_map_node_array(count,layer)
		
		
		map_tree.append(layer_array)
	

func create_map_node_array(count,layer):
	map_tree.clear()
	var map_node_array = []
	for index in range(count):
		var map_node = MapNode.new()
		map_node.row_index = layer
		map_node.column_index = index
		map_node.type = define_layer_rule(layer)
		map_node_array.append(map_node)
		
	return map_node_array
	
func define_layer_rule(layer) -> String:
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

	var rule = []
	rule = layer_rules[layer]
	var type = randi_range(0,len(rule)-1)
	return rule[type]
	
	
	
	
	
	
	
	
	
