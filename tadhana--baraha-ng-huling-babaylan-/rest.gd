extends Node


var PlayerNodeScene = preload("res://entity/player/player_node.tscn")

# --- Configuration ---
# Heal for 30% of Max Health, a common value for a Rest Site
const HEAL_PERCENTAGE: float = 0.3

# --- State ---
var player_entity
var player_node
var action_available: bool = true # Flag to ensure only one action (Rest or Upgrade) is chosen


# --- Node References (Adjust these paths to match your actual scene layout) ---

# @onready var map_button = $"NavbarTemp/MapButton"
@onready var rest_button = $UI/RestButton
@onready var upgrade_button = $UI/UpgradeButton
@onready var message_label = $UI/MessageLabel 
@onready var continue_button = $ContinueButton


var DeckOverlayScene = preload("res://components/deck overlay/deck_overlay.tscn")
var deck_overlay_instance





# The setup function, mirroring the structure of your load_shop_room
func load_rest_room(_node_info, player_ref):
	# Store player entity reference
	player_entity = player_ref
	
	
	# CREATE PLAYER VISUAL NODE
	player_node = PlayerNodeScene.instantiate()
	get_node("PlayerContainer").add_child(player_node)
	
	player_node.set_entity(player_entity)
	var spawn_point = get_node("PlayerContainer/PlayerSpawn").global_position
	player_node.global_position = spawn_point
	


	
	
	# Initial UI update and signal connection
	_update_ui_state()
	rest_button.pressed.connect(_on_rest_button_pressed)
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	
	rest_button.visible = true
	upgrade_button.visible = true
	message_label.visible = true
	continue_button.visible = false
	
	print("Rest Site initialized successfully.")


# --- Core Healing Logic ---
func _heal_player():
	if not action_available:
		message_label.text = "You have already chosen an action at this bonfire."
		print("DEBUG: Rest failed - action already taken.")
		return

	# --- MODIFIED LOGIC: Over-heal is now possible, removing max_hp check and clamping ---
	if player_entity and player_entity.max_hp and player_entity.hp:
		
		print("DEBUG: Player HP BEFORE REST: %d/%d" % [player_entity.hp, player_entity.max_hp])
		
		# Calculate heal amount based on percentage of max health
		var heal_amount = floor(player_entity.max_hp * HEAL_PERCENTAGE)
		
		# Apply the healing directly, allowing HP to go over max_hp
		
		if (player_entity.hp + heal_amount) > player_entity.max_hp:
			player_entity.hp = player_entity.max_hp
		else:
			player_entity.hp += heal_amount
		var actual_heal = heal_amount # The amount healed is simply the calculated amount

		# Optional: Update the visual node's health display if it has one
		if player_node and player_node.has_method("update_health_display"):
			player_node.update_health_display()
		
		# Disable future actions at this site
		action_available = false
		message_label.text = "Rested! Healed for %d HP" % actual_heal
		
		print("DEBUG: Player HP AFTER REST: %d/%d" % [player_entity.hp, player_entity.max_hp])
		
		# Update UI state
		_update_ui_state()
	else:
		message_label.text = "Error: Player data not accessible."
		print("ERROR: Player entity data is missing or incomplete for healing.")


# --- UI and Interaction ---

func _update_ui_state():
	# Use player_entity.hp and player_entity.max_hp
	var heal_for = floor(player_entity.max_hp * HEAL_PERCENTAGE)
	
	if action_available:
		# Action is available, now check for individual button eligibility
		
		# 1. Upgrade Button: Always available if action hasn't been taken
		upgrade_button.text = "Upgrade Card"
		upgrade_button.disabled = false
		
		# 2. Rest Button: Always available for over-heal
		rest_button.text = "Rest (Heal %d HP)" % heal_for
		rest_button.disabled = false
			
		message_label.text = "A quiet place to rest (heal) or hone your deck (upgrade)"
		
	else:
		# Action has been taken, disable both
		rest_button.text = "Rest (Used)"
		upgrade_button.text = "Upgrade (Used)"
		rest_button.disabled = true
		upgrade_button.disabled = true
		message_label.text = "You have already chosen an action."
		continue_button.visible = true


# --- Signal Handlers ---

func _on_rest_button_pressed():
	print("DEBUG: Rest button pressed.")
	# This is the heal action
	_heal_player()

func _on_upgrade_button_pressed():
	if not action_available:
		message_label.text = "Action already taken."
		return
	
	rest_button.visible = false
	upgrade_button.visible = false
	message_label.visible = false
	
	# Create overlay dynamically (same as in battleroom)
	deck_overlay_instance = DeckOverlayScene.instantiate()
	add_child(deck_overlay_instance)
	
	# Open overlay
	deck_overlay_instance.open_overlay(
		"Select a card to upgrade",
		player_entity.deck,
		true
	)

	# Connect signal
	deck_overlay_instance.card_selected.connect(_on_upgrade_card_chosen)
	deck_overlay_instance.overlay_closed.connect(_on_overlay_closed)


func _on_upgrade_card_chosen(card_data):
	# If no coin flag yet, add it
	card_data["coin"] = 1

	action_available = false
	message_label.text = "%s upgraded!" % card_data["card_name"]

	_update_ui_state()

func _on_overlay_closed():
	if deck_overlay_instance:
		deck_overlay_instance.queue_free()
		deck_overlay_instance = null
	
	rest_button.visible = true
	upgrade_button.visible = true
	message_label.visible = true


func _on_map_button_pressed() -> void:
	# Assuming GameManager is a global singleton as in your shop script
	# This line assumes you have a map button connected to this script, 
	# but it's commented out in your @onready section.
	# If the map button is elsewhere, ensure the GameManager.return_to_map() is called correctly.
	GameManager.return_to_map()


func _on_continue_button_pressed() -> void:
	GameManager.return_to_map()
