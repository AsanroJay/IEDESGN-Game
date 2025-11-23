extends Area2D
class_name CardNode

@onready var sprite: Sprite2D = $CardSprite
var card_data

const CARD_WIDTH := 120.0
const CARD_HEIGHT := 180.0

func set_card(card):
	card_data = card
	sprite.texture = load(card["image_path"])

	_apply_card_scaling()   # IMPORTANT: do scaling *after* texture is set


func _apply_card_scaling():
	var tex = sprite.texture
	if tex == null:
		return

	var tex_w = tex.get_width()
	var tex_h = tex.get_height()

	var scale_x = CARD_WIDTH / tex_w
	var scale_y = CARD_HEIGHT / tex_h

	sprite.scale = Vector2(scale_x, scale_y)
