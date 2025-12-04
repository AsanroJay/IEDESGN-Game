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
	play_add_block_animation(new_block_value)
	
func play_attack_animation():
	var tween = create_tween()

	var original_pos = position

	# Lunge forward
	tween.tween_property(self, "position", original_pos + Vector2(70, 0), 0.1)
	# Snap back
	tween.tween_property(self, "position", original_pos, 0.1)
	
func play_add_block_animation(amount: int):
	var pop = FloatingText.instantiate()

	var ui_layer = battle_room.get_node("UI/FloatingTextLayer")
	ui_layer.add_child(pop)

	pop.global_position = global_position + Vector2(0, -50)
	pop.show_text("+" + str(amount) + " Block", Color(0.3, 0.8, 1))
