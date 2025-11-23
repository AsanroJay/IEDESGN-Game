extends Area2D
class_name CardNode


@onready var sprite: Sprite2D = $CardSprite
@onready var shape := $CollisionShape2D

var card_data
var base_position: Vector2   # fan position before hover

const CARD_WIDTH := 140.0
const CARD_HEIGHT := 180.0

@export var hover_lift := -80.0         # how high the card lifts on hover
@export var hover_scale := 1.15         # slight enlarge on hover

var original_scale := Vector2.ZERO
var is_hovered := false


func set_card(card):
	card_data = card
	sprite.texture = load(card["image_path"])

	_apply_fixed_size()

	# Save original scale for easy reset on hover exit
	original_scale = sprite.scale


func _apply_fixed_size():
	var tex = sprite.texture
	if tex == null:
		return

	var sx = CARD_WIDTH / tex.get_width()
	var sy = CARD_HEIGHT / tex.get_height()

	sprite.scale = Vector2(sx, sy)

	# update collision shape too
	var rect := shape.shape as RectangleShape2D
	rect.extents = Vector2(CARD_WIDTH / 2, CARD_HEIGHT / 2)


# -----------------------------------------
# HOVER EFFECTS
# -----------------------------------------

func _on_mouse_entered():
	is_hovered = true
	hover_enter()


func _on_mouse_exited():
	is_hovered = false
	hover_exit()


func hover_enter():
	var tween = create_tween()

	# Highlight
	sprite.modulate = Color(1.2, 1.2, 1.2)
	z_index = 1000

	# POP OUT EFFECT (absolute target, not relative)
	var target_pos = base_position + Vector2(0, hover_lift)

	tween.tween_property(self, "position", target_pos, 0.15)
	tween.parallel().tween_property(sprite, "scale", original_scale * hover_scale, 0.15)



func hover_exit():
	var tween = create_tween()

	sprite.modulate = Color(1, 1, 1)
	z_index = 0

	# Return to base fan position
	tween.tween_property(self, "position", base_position, 0.15)
	tween.parallel().tween_property(sprite, "scale", original_scale, 0.15)
