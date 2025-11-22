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
