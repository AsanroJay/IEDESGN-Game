extends Node2D
class_name PlayerNode

var entity
@onready var anim = $Sprite   
var FloatingText = preload("res://components/floating text/floating_text.tscn")
var battle_room


func set_entity(e):
	entity = e
	anim.play("idle")
	
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
