extends Node2D
class_name EnemyNode

var entity
@onready var anim = $Sprite

func set_entity(e):
	entity = e

	# load animation frames resource
	var frames_path = entity.animation_data["frames"]
	anim.sprite_frames = load(frames_path)

	anim.play("idle")

func play_hit_animation():
	var tween = create_tween()

	# QUICK white flash
	tween.tween_property(anim, "modulate", Color(2,2,2), 0.05)
	tween.tween_property(anim, "modulate", Color(1,1,1), 0.1)

	# Shake effect
	var original_pos = position
	tween.parallel().tween_property(self, "position", original_pos + Vector2(10,0), 0.05)
	tween.parallel().tween_property(self, "position", original_pos - Vector2(10,0), 0.05)
	tween.parallel().tween_property(self, "position", original_pos, 0.05)
