extends Node2D


var map_scene

const DOT_SPACING := 24.0
const DOT_RADIUS := 3.0
const DOT_COLOR := Color(1, 1, 1, 0.75)

func _draw():
	if map_scene == null:
		return  
		
	for layer in map_scene.map_tree:
		for node in layer:
			if node.view == null:
				continue
			var pointA = to_local(node.view.get_global_position())

			for connected_node in node.connections:
				if connected_node.view == null:
					continue
				var pointB = to_local(connected_node.view.get_global_position())
				_draw_connection(pointA, pointB)


func _draw_connection(a: Vector2, b: Vector2) -> void:
	var dir = b - a
	var dist = dir.length()
	if dist <= 0:
		return

	var steps = int(dist / DOT_SPACING)
	var step_vec = dir / float(steps)

	for i in range(steps + 1):
		var pos = a + step_vec * i
		draw_circle(pos, DOT_RADIUS, DOT_COLOR)
