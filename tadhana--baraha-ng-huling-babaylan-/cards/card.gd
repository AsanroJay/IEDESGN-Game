extends Node
class_name Card

var card_name: String
var cost: int
var image_path: String
var description: String
var type: String

func _init(n , c , img_path , desc, t):
	card_name = n
	cost = c
	image_path = img_path
	description = desc
	type = t
