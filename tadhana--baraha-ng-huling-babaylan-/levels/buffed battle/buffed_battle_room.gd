extends Node2D
class_name BuffedBattleRoom

# Preload BattleManager (NOT entity nodes)
var BattleManagerScene = preload("res://levels/buffed battle/buff_battle_manager.gd")
var DeckOverlayScene = preload("res://components/deck overlay/deck_overlay.tscn")
var battle_manager

var player
var enemy 

# Saved args for delayed start
var _pending_node_info = null
var _pending_player_ref = null

# Deck Related Variables
var deck = []
var draw_pile = []
var discard_pile = []
var exhaust_pile = []
var show_pile_flag = false

# Overlay/UI nodes (optional)
@onready var _overlay_control = get_node_or_null("BuffTitleLayer/OverlayControl")
@onready var _continue_button = get_node_or_null("BuffTitleLayer/OverlayControl/ContinueButton")
@onready var _background_sprite = get_node_or_null("Background")


func _ready():
	# If overlay exists, wire it up
	if _overlay_control:
		_overlay_control.visible = false

		if _continue_button and not _continue_button.pressed.is_connected(_on_continue_pressed):
			_continue_button.pressed.connect(_on_continue_pressed)

		_hide_gameplay_visuals()
		if has_node("BlackBG"):
			get_node("BlackBG").visible = true



func start_battle_from_node(node_info, player_ref):
	_pending_node_info = node_info
	_pending_player_ref = player_ref

	if _overlay_control:
		_show_buff_overlay()
	else:
		_create_and_start_battle_manager(node_info, player_ref)


func _show_buff_overlay():
	_overlay_control.visible = true
	_hide_gameplay_visuals()


func _on_continue_pressed():
	# Hide overlay
	if _overlay_control:
		_overlay_control.visible = false

	# Show background if exists
	if _background_sprite:
		_background_sprite.visible = true

	# Hide black BG when showing actual battle
	if has_node("BlackBG"):
		get_node("BlackBG").visible = false

	_show_gameplay_visuals()


	# Start battle manager
	if battle_manager == null:
		_create_and_start_battle_manager(_pending_node_info, _pending_player_ref)

	_pending_node_info = null
	_pending_player_ref = null


func _create_and_start_battle_manager(node_info, player_ref):
	if battle_manager != null:
		battle_manager.start_battle(self, node_info, player_ref)
		return

	battle_manager = BattleManagerScene.new()
	add_child(battle_manager)
	battle_manager.start_battle(self, node_info, player_ref)


func _hide_gameplay_visuals():
	if has_node("PlayerContainer"):
		get_node("PlayerContainer").visible = false

	if has_node("EnemyContainer"):
		get_node("EnemyContainer").visible = false

	if has_node("UI"):
		get_node("UI").visible = false


func _show_gameplay_visuals():
	if has_node("PlayerContainer"):
		get_node("PlayerContainer").visible = true

	if has_node("EnemyContainer"):
		get_node("EnemyContainer").visible = true

	if has_node("UI"):
		get_node("UI").visible = true


# ---------------- EXISTING FUNCTIONS ----------------

func _on_map_button_pressed():
	GameManager.return_to_map()


func _on_play_area_area_entered(area: Area2D) -> void:
	if area is CardNode:
		print("Card entered collision area")
		area.is_in_play_area = true


func _on_play_area_area_exited(area: Area2D) -> void:
	if area is CardNode:
		print("Card exited collision area")
		area.is_in_play_area = false


func _on_end_turn_button_pressed() -> void:
	if battle_manager:
		battle_manager.end_player_turn()


func _on_open_draw_pile_pressed() -> void:
	if battle_manager:
		show_pile("Draw Pile", battle_manager.get_draw_pile())


func _on_open_discard_pile_pressed() -> void:
	if battle_manager:
		show_pile("Discard Pile", battle_manager.get_discard_pile())


func _on_open_exhaust_pile_pressed() -> void:
	if battle_manager:
		show_pile("Exhaust Pile", battle_manager.get_exhaust_pile())


func show_pile(title: String, pile: Array):
	if show_pile_flag:
		return

	set_ui_visible(false)
	show_pile_flag = true

	var overlay = DeckOverlayScene.instantiate()
	add_child(overlay)

	overlay.open_overlay(title, pile)

	overlay.overlay_closed.connect(func():
		overlay.queue_free()
		show_pile_flag = false
		set_ui_visible(true)
	)


func set_ui_visible(is_visible: bool):
	if has_node("UI"):
		$UI.visible = is_visible
