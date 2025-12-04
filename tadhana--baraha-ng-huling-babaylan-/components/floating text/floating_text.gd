extends Node2D

@onready var label: Label = $Label

func show_text(text: String, color: Color = Color.WHITE):
	label.text = text
	label.modulate = color
	label.scale = Vector2(1, 1)

	var tween = create_tween()

	var start_pos = global_position
	var end_pos = start_pos + Vector2(0, -40)

	# float upward in global space (correct)
	tween.tween_property(self, "global_position", end_pos, 0.6) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# fade out
	tween.parallel().tween_property(label, "modulate", Color(color.r, color.g, color.b, 0), 1.5)

	await tween.finished
	queue_free()
