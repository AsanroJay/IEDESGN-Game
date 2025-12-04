extends Node2D
class_name PlayerNode

var entity
@onready var anim = $Sprite   
var FloatingText = preload("res://components/floating text/floating_text.tscn")
var battle_room


func set_entity(e):
	entity = e
	anim.play("idle")
	entity.block_changed.connect(_on_block_changed)

func _on_block_changed(new_block_value: int):
	# This function is called when Entity.gain_block() is run
	show_floating_text("+" + str(new_block_value) + " Block", Color.DEEP_SKY_BLUE)
	
func play_attack_animation():
	var tween = create_tween()

	var original_pos = position

	# Lunge forward
	tween.tween_property(self, "position", original_pos + Vector2(70, 0), 0.1)
	# Snap back
	tween.tween_property(self, "position", original_pos, 0.1)
	
	

	
func show_floating_text(text: String, color: Color = Color.WHITE, y_offset := -60):
	var pop = FloatingText.instantiate()
	var ui_layer = battle_room.get_node("UI/FloatingTextLayer")
	ui_layer.add_child(pop)

	pop.global_position = global_position + Vector2(0, y_offset)
	pop.show_text(text, color)
