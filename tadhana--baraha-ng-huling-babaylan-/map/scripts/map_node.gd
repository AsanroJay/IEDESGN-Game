extends Node
class_name MapNode

var image_dict = {
	"default": "res://map/assets/mapnode_default.png",
	"mystery": "res://map/assets/mapnode_mystery.png",
	"encounter": "res://map/assets/mapnode_encounter.png",
	"rest": "res://map/assets/mapnode_rest.png",
	"boss": "res://map/assets/mapnode_boss.png",
	"shop": "res://map/assets/mapnode_shop.png",
	"buffed": "res://map/assets/mapnode_buffed.png",
	
}

var type				#(encounter,boss,shop etc)
var row_index 			#which layer of the tree its on
var column_index		#which column slot
var image_path 			#for image paths
var connections = []	#connection to other nodes
var view = null
