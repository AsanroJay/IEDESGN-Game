extends Area2D
class_name CardNode

@onready var sprite: Sprite2D = $CardSpriteHolder/CardSprite
@onready var shape := $CollisionShape2D
@onready var sprite_holder := $CardSpriteHolder

var play_area: Area2D
var snap_point: Node2D


var card_data
var base_position: Vector2                   # fan resting position
var base_rotation := 0.0

	
const CARD_WIDTH := 160.0
const CARD_HEIGHT := 200.0

@export var hover_lift := -80.0              # how high it pops out
@export var hover_scale := 1.15              # enlarge factor

var original_sprite_scale := Vector2.ZERO     # how big sprite is after fitting to 140×180
var holder_original_scale := Vector2.ONE      # sprite_holder starts at (1,1)
var is_hovered := false

var is_in_play_area := false
var is_dragging := false
var drag_start_pos := Vector2.ZERO
var drag_threshold := 10.0


signal card_played(card)

var battle_manager
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
	if is_dragging:
		return

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
	
	if is_dragging:
		return

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
	

func _input_event(viewport, event, shape_idx):
	if not battle_manager.card_input_enabled:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and is_hovered:
				is_dragging = true
				z_index = 2000        # bring card to top layer
				sprite_holder.position = Vector2.ZERO  # avoid offset from hover
				rotation = 0
				
func _process(delta):
	if not battle_manager.card_input_enabled:
		return
	
	if is_dragging:
		global_position = get_global_mouse_position()
		
func _unhandled_input(event):
	if not battle_manager.card_input_enabled:
		return
		
	if is_dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			is_dragging = false

			if is_in_play_area:
				snap_to_play_area_and_emit()
			else:
				return_to_hand()
				
func set_play_area(play_area_ref: Area2D, snap_point_ref: Node2D):
	play_area = play_area_ref
	snap_point = snap_point_ref


func snap_to_play_area_and_emit():
	if play_area == null or snap_point == null:
		push_error("CardNode: PlayArea or SnapPoint not set!")
		return_to_hand()
		return

	var target_pos = snap_point.global_position

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		sprite_holder, "scale",
		holder_original_scale * 1.15, 0.15
	)

	await tween.finished
	emit_signal("card_played", self)



			
func return_to_hand():
	var tween = create_tween()

	tween.tween_property(self, "global_position", base_position, 0.2)

	# ⭐ restore fan rotation
	tween.parallel().tween_property(self, "rotation", base_rotation, 0.2)

	tween.parallel().tween_property(sprite_holder, "scale", holder_original_scale, 0.2)
	tween.parallel().tween_property(sprite_holder, "position", Vector2.ZERO, 0.2)

	z_index = 0
	
func play_exhaust_animation():
	var tween = create_tween()

	# Slight scale punch (like a "poof")
	tween.tween_property(self, "scale", scale * 1.1, 0.08)
	tween.tween_property(self, "scale", scale * 0.6, 0.15)

	# Random tile fade (using modulate noise)
	var steps = 10
	for i in range(steps):
		await get_tree().create_timer(0.3).timeout
		modulate = Color(1, 1, 1, 1.0 - float(i) / steps)

	# Fully gone
	await tween.finished
	queue_free()
