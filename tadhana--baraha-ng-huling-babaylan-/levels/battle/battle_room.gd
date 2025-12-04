extends Node2D
class_name BattleRoom

# Preload BattleManager (NOT entity nodes)
var BattleManagerScene = preload("res://levels/battle/battle_manager.gd")
var DeckOverlayScene = preload("res://components/deck overlay/deck_overlay.tscn")
var battle_manager

var player
var enemy 

@onready var gold_counter = $NavbarTemp/GoldCounter

#Deck Related Variables
var deck = []        
var draw_pile = []
var discard_pile = []
var exhaust_pile = []
var show_pile_flag = false


func start_battle_from_node(node_info, player_ref):
	# Create BattleManager instance
	battle_manager = BattleManagerScene.new()

	# Add it under the BattleRoom
	add_child(battle_manager)

	# Begin battle
	battle_manager.start_battle(self, node_info, player_ref)
	
	gold_counter.text = str(player_ref.gold)


func _ready():
	pass



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
	battle_manager.end_player_turn()


func _on_open_draw_pile_pressed() -> void:
	show_pile("Draw Pile", battle_manager.get_draw_pile())

func _on_open_discard_pile_pressed() -> void:
	show_pile("Discard Pile", battle_manager.get_discard_pile())

func _on_open_exhaust_pile_pressed() -> void:
	show_pile("Exhaust Pile", battle_manager.get_exhaust_pile())


func show_pile(title: String, pile: Array):
	if show_pile_flag == true:
		return
		
	set_ui_visible(false)
	show_pile_flag = true
	var overlay = DeckOverlayScene.instantiate()
	add_child(overlay)

	overlay.open_overlay(title, pile)

	# Destroy overlay when closed
	overlay.overlay_closed.connect(func():
		overlay.queue_free()
		show_pile_flag = false
		set_ui_visible(true)
	)
func set_ui_visible(is_visible: bool):
	$UI.visible = is_visible
