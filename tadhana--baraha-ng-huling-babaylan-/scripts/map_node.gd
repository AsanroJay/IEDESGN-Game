extends Node
class_name MapNode

var image_dict = {
	"default": "res://assets/mapnode_default.png"
}

var type				#(encounter,boss,shop etc)
var row_index 		#which layer of the tree its on
var column_index			#which column slot
var image_path 			#for image paths
var connections = []	#connection to other nodes

	
