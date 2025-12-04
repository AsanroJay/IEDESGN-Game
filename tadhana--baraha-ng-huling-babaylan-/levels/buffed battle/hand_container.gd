extends Control

@export var max_fan_angle := 25.0
@export var radius := 400.0
@export var y_offset := -75.0

func arrange_cards():
	var cards = get_children()
	var count = cards.size()
	if count == 0:
		return

	var start_angle = -max_fan_angle
	var end_angle = max_fan_angle
	var angle_step = (end_angle - start_angle) / max(1, count - 1)

	var pivot = Vector2(size.x / 2, size.y + radius + y_offset)

	for i in range(count):
		var card = cards[i]

		# Skip hovered or dragged cards
		if card.is_hovered or card.is_dragging:
			continue

		var angle_deg = start_angle + angle_step * i
		var angle = deg_to_rad(angle_deg)

		var pos = pivot + Vector2(
			radius * sin(angle),
			-radius * cos(angle)
		)

		# store fan resting data
		card.base_position = card.get_parent().global_position + pos
		card.base_rotation = angle  # ⭐ IMPORTANT

		var tween = create_tween()
		tween.tween_property(card, "position", pos, 0.3)
		tween.parallel().tween_property(card, "rotation", angle, 0.3)
