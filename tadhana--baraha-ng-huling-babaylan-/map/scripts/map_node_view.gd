extends Control
class_name MapNodeView

var map_node  # reference to  MapNode data
@onready var texture_rect = $TextureRect #texture/image holder


func set_node_data(node):
	map_node = node
	
func _ready():
	if map_node != null:
		set_map_node_picture()
		
func set_map_node_picture():
	if texture_rect == null:
		push_error("TextureRect NOT FOUND in MapNodeView!")
		return

	var path = map_node.image_dict[map_node.type]
	var tex = load(path)
	texture_rect.texture = tex
	
