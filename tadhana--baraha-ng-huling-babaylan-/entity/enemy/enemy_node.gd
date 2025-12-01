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
	var original_pos = position
	var original_scale = scale

	# Flash
	tween.tween_property(anim, "modulate", Color(2, 2, 2), 0.05)
	tween.tween_property(anim, "modulate", Color(1, 1, 1), 0.1)

	# Squash
	tween.tween_property(self, "scale", original_scale * Vector2(1.05, 0.95), 0.05)
	tween.tween_property(self, "scale", original_scale, 0.05)

	# Shake left-right
	tween.tween_property(self, "position", original_pos + Vector2(10, 0), 0.05)
	tween.tween_property(self, "position", original_pos - Vector2(10, 0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)
