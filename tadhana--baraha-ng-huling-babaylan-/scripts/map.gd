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
	
	#randomize how many nodes per tree layer
	for layer in range(max_layers):
		var count = 0
		if layer == 1:
			count = 4
		else:
			count = floor(randf_range(2.5,4.7))
		
		var layer_array = [count]
		
		map_tree.append(layer_array)
	

	
