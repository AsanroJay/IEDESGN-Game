extends Area2D
class_name CardNode

@onready var sprite: Sprite2D = $CardSpriteHolder/CardSprite
@onready var shape := $CollisionShape2D
@onready var sprite_holder := $CardSpriteHolder

var card_data
var base_position: Vector2                   # fan resting position

const CARD_WIDTH := 160.0
const CARD_HEIGHT := 200.0

@export var hover_lift := -80.0              # how high it pops out
@export var hover_scale := 1.15              # enlarge factor

var original_sprite_scale := Vector2.ZERO     # how big sprite is after fitting to 140×180
var holder_original_scale := Vector2.ONE      # sprite_holder starts at (1,1)
var is_hovered := false


# ------------------------------------------------------
# CARD INITIALIZATION
# ------------------------------------------------------

func set_card(card):
	card_data = card
	sprite.texture = load(card["image_path"])

	_apply_fixed_size()

	# Save original scale of both objects
	original_sprite_scale = sprite.scale
	holder_original_scale = sprite_holder.scale


func _apply_fixed_size():
	var tex = sprite.texture
	if tex == null:
		return

	var sx = CARD_WIDTH / tex.get_width()
	var sy = CARD_HEIGHT / tex.get_height()

	sprite.scale = Vector2(sx, sy)

	# Update hitbox size
	var rect := shape.shape as RectangleShape2D
	rect.extents = Vector2(CARD_WIDTH / 2, CARD_HEIGHT / 2)


# ------------------------------------------------------
# HOVER EFFECTS
# ------------------------------------------------------

func _on_mouse_entered():
	is_hovered = true
	hover_enter()


func _on_mouse_exited():
	is_hovered = false
	hover_exit()


func hover_enter():
	var tween = create_tween()

	# white highlight
	sprite.modulate = Color(1.2, 1.2, 1.2)

	# bring above other cards
	z_index = 1000

	# pop-out animation only sprite_holder moves/scales
	tween.tween_property(
		sprite_holder,
		"position",
		Vector2(0, hover_lift),
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		sprite_holder,
		"scale",
		holder_original_scale * hover_scale,
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func hover_exit():
	var tween = create_tween()

	# remove highlight
	sprite.modulate = Color(1, 1, 1)

	z_index = 0

	# return to neutral state
	tween.tween_property(
		sprite_holder,
		"position",
		Vector2(0, 0),
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		sprite_holder,
		"scale",
		holder_original_scale,
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
