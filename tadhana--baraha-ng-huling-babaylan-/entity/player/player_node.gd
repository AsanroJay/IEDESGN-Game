extends Node2D
class_name PlayerNode

var entity
@onready var anim = $Sprite   

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
