extends Control

signal choice_made(player_choice: String, result: String, won: bool)

var coin_result: String = ""
var player_choice: String = ""

# Preload all coin animation frames
var coin_frames = [
	preload("res://levels/battle/assets/coin_toss/1.png"),   # 20 Piso front
	preload("res://levels/battle/assets/coin_toss/2.png"),   # Angled view
	preload("res://levels/battle/assets/coin_toss/3.png"),   # Edge view
	preload("res://levels/battle/assets/coin_toss/4.png"),   # Angled back
	preload("res://levels/battle/assets/coin_toss/5.png"),   # Back (plant side)
	preload("res://levels/battle/assets/coin_toss/6.png"),   # Angled back
	preload("res://levels/battle/assets/coin_toss/7.png"),   # Edge view
	preload("res://levels/battle/assets/coin_toss/8.png"),   # Angled front
]

# Define which frame is heads (Manuel L. Quezon) and tails (plant design)
var heads_frame = coin_frames[0]  # 20 Piso with face
var tails_frame = coin_frames[4]  # Plant design side

@onready var heads_button = $Panel/VBoxContainer/ButtonContainer/HeadsButton
@onready var tails_button = $Panel/VBoxContainer/ButtonContainer/TailsButton
@onready var result_label = $Panel/VBoxContainer/ResultLabel
@onready var coin_sprite = $Panel/VBoxContainer/CoinSprite
@onready var instruction_label = $Panel/VBoxContainer/InstructionLabel

func _ready():
	# Hide result initially
	result_label.visible = false
	coin_sprite.visible = true
	coin_sprite.texture = heads_frame  # Start with heads
	instruction_label.text = "Choose Heads or Tails!"
	
	heads_button.pressed.connect(_on_heads_pressed)
	tails_button.pressed.connect(_on_tails_pressed)

func _on_heads_pressed():
	_make_choice("heads")

func _on_tails_pressed():
	_make_choice("tails")

func _make_choice(choice: String):
	player_choice = choice
	
	# Disable buttons
	heads_button.disabled = true
	tails_button.disabled = true
	
	# Flip the coin
	coin_result = "heads" if randf() < 0.5 else "tails"
	
	# Show animation
	await _play_coin_flip_animation()
	
	# Show result
	var won = (player_choice == coin_result)
	_show_result(won)
	
	# Wait a bit then emit signal
	await get_tree().create_timer(1.5).timeout
	choice_made.emit(player_choice, coin_result, won)
	queue_free()

func _play_coin_flip_animation():
	# Animate through all frames to create a realistic coin flip
	var flip_speed = 0.05  # Time between frames
	var total_loops = 3    # How many times to cycle through all frames
	
	for loop in range(total_loops):
		for frame in coin_frames:
			coin_sprite.texture = frame
			await get_tree().create_timer(flip_speed).timeout
	
	# Slow down at the end for dramatic effect
	for i in range(4):
		coin_sprite.texture = coin_frames[i % coin_frames.size()]
		await get_tree().create_timer(0.1).timeout
	
	# Set final result texture
	if coin_result == "heads":
		coin_sprite.texture = heads_frame
	else:		coin_sprite.texture = tails_frame

func _show_result(won: bool):
	result_label.visible = true
	
	if won:
		result_label.text = "[center][color=green]YOU WIN!\n" + coin_result.to_upper() + "![/color][/center]"
	else:
		result_label.text = "[center][color=red]YOU LOSE!\n" + coin_result.to_upper() + "![/color][/center]"
