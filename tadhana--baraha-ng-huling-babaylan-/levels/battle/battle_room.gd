extends Node2D
class_name BattleRoom

# Preload BattleManager (NOT entity nodes)
# CRITICAL: This MUST be the normal battle manager, not the buffed one!
const NORMAL_BATTLE_MANAGER_PATH = "res://levels/battle/battle_manager.gd"
var BattleManagerScene = load(NORMAL_BATTLE_MANAGER_PATH) as GDScript
var DeckOverlayScene = preload("res://components/deck overlay/deck_overlay.tscn")
var battle_manager

var player
var enemy 

#Deck Related Variables
var deck = []        
var draw_pile = []
var discard_pile = []
var exhaust_pile = []
var show_pile_flag = false


func start_battle_from_node(node_info, player_ref):
	print("=== NORMAL BATTLE ROOM START_BATTLE_FROM_NODE CALLED ===")
	print("Normal BattleRoom: Preload path:", NORMAL_BATTLE_MANAGER_PATH)
	print("Normal BattleRoom: BattleManagerScene is:", BattleManagerScene)
	if BattleManagerScene:
		print("Normal BattleRoom: BattleManagerScene resource_path:", BattleManagerScene.resource_path)
	# Create BattleManager instance
	battle_manager = BattleManagerScene.new()
	print("Normal BattleRoom: Created battle_manager instance:", battle_manager)
	print("Normal BattleRoom: battle_manager script path:", battle_manager.get_script().get_path())
	
	# Verify we got the correct manager
	if battle_manager.has_method("get") and battle_manager.get("BATTLE_TYPE"):
		var battle_type = battle_manager.get("BATTLE_TYPE")
		print("Normal BattleRoom: Detected battle manager type:", battle_type)
		if battle_type != "NORMAL":
			print("ERROR! Wrong battle manager loaded! Expected NORMAL, got:", battle_type)
	else:
		print("WARNING: Could not verify battle manager type")

	# Add it under the BattleRoom
	add_child(battle_manager)

	# Begin battle
	battle_manager.start_battle(self, node_info, player_ref)


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
