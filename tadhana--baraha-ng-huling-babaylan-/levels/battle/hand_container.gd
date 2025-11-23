extends Control

@export var max_fan_angle := 40.0     # degrees left/right
@export var radius := 250.0           # distance from pivot
@export var y_offset := -150.0           # move fan up/down

func arrange_cards():
	var cards = get_children()
	var count = cards.size()
	if count == 0:
		return

	# Fan angles
	var start_angle = -max_fan_angle
	var end_angle = max_fan_angle
	var angle_step = (end_angle - start_angle) / max(1, count - 1)

	# Pivot point (below container)
	var pivot = Vector2(size.x / 2, size.y + radius + y_offset)

	for i in range(count):
		var card = cards[i]

		var angle_deg = start_angle + angle_step * i
		var angle = deg_to_rad(angle_deg)

		# Circular arc position
		var pos = pivot + Vector2(
			radius * sin(angle),
			-radius * cos(angle)
		)

		# Card should face outward
		var rot = angle

		# Tween animation
		var tween = create_tween()
		tween.tween_property(card, "position", pos, 0.3)
		tween.parallel().tween_property(card, "rotation", rot, 0.3)
