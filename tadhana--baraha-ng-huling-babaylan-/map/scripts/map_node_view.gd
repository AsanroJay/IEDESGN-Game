extends Control
class_name MapNodeView

var map_node  # reference to  MapNode data
@onready var texture_rect = $TextureRect #texture/image holder

var clickable = false
var _pulse_tween : Tween = null
signal node_clicked(node)

func set_clickable(value):
	clickable = value

func _gui_input(event):
	if not clickable:
		return
	if event is InputEventMouseButton and event.pressed:
		emit_signal("node_clicked", map_node)

func set_node_data(node):
	map_node = node
	
func _ready():
	if map_node != null:
		set_map_node_picture()
		
	

		
func set_map_node_picture():
	if texture_rect == null:
		push_error("TextureRect NOT FOUND in MapNodeView!")
		return

	var path = map_node.image_dict.get(map_node.type, map_node.image_dict["default"])
	var tex = load(path)
	texture_rect.texture = tex

	# normal size for all other nodes
	var size = Vector2(56, 56)
	texture_rect.custom_minimum_size = size
	texture_rect.size = size

	# special boss handling
	if map_node.type == "boss":
		var boss_size = Vector2(200, 200)
		texture_rect.custom_minimum_size = boss_size
		texture_rect.size = boss_size
		texture_rect.position = -boss_size / 2      # center ONLY boss icon
	else:
		texture_rect.position = Vector2.ZERO        # standard alignment
		
	

func pulse():
	# avoid creating duplicate tweens
	if _pulse_tween and _pulse_tween.is_running():
		return

	# Tween type in Godot 4.5
	_pulse_tween = create_tween()
	_pulse_tween.set_loops()  # infinite loop

	_pulse_tween.tween_property(texture_rect, "scale", Vector2(1.10, 1.10), 0.5)
	_pulse_tween.tween_property(texture_rect, "scale", Vector2(1.0, 1.0), 0.5)

func stop_pulse():
	texture_rect.scale = Vector2(1, 1)

	if _pulse_tween:
		_pulse_tween.kill()  # kill the animation
		_pulse_tween = null
