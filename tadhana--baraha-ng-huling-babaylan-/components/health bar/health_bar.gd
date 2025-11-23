extends Node2D

var tweening := false

@onready var bar: TextureProgressBar = $HealthBar
@onready var hp_label: Label = $HPLabel

func set_hp(current: int, max: int):
	bar.max_value = max
	hp_label.text = str(current) + " / " + str(max)
	
	
	print("Max: ", max)
	print("Current: ", current)
	animate_to(current)

func animate_to(target_value: int):
	if tweening:
		return

	tweening = true
	var tween = create_tween()

	tween.tween_property(
		bar,               # tween  node
		"value",           # tween  property
		target_value,      # final value
		0.25               # duration
	).set_trans(Tween.TRANS_LINEAR)\
	 .set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func():
		tweening = false
	)
