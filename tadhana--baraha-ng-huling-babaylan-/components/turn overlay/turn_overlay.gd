extends CanvasLayer

@onready var label := $OverlayText
@onready var bar := $BackgroundBar

func show_overlay(text: String, duration := 1.5):
	label.bbcode_enabled = true
	label.clear()

	# text can include icons later
	label.text = text

	var tween = create_tween()

	# fade-in
	label.modulate.a = 0.0
	
	tween.tween_property(label, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)

	# hold
	tween.tween_interval(duration)

	# fade-out
	tween.tween_property(label, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(bar, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	

	await tween.finished
	queue_free()
