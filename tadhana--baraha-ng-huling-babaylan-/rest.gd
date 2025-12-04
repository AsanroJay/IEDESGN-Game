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
@onready var message_label = $UI/MessageLabel # For feedback (Ensure this node exists under UI)



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
		player_entity.hp += heal_amount
		var actual_heal = heal_amount # The amount healed is simply the calculated amount

		# Optional: Update the visual node's health display if it has one
		if player_node and player_node.has_method("update_health_display"):
			player_node.update_health_display()
		
		# Disable future actions at this site
		action_available = false
		message_label.text = "Rested! Healed for %d HP. Your health may now exceed the normal maximum!" % actual_heal
		
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
			
		message_label.text = "A quiet place to rest or hone your deck. Resting can now temporarily exceed your max HP."
		
	else:
		# Action has been taken, disable both
		rest_button.text = "Rest (Used)"
		upgrade_button.text = "Upgrade (Used)"
		rest_button.disabled = true
		upgrade_button.disabled = true
		message_label.text = "You have already chosen an action at this bonfire."


# --- Signal Handlers ---

func _on_rest_button_pressed():
	print("DEBUG: Rest button pressed.")
	# This is the heal action
	_heal_player()

func _on_upgrade_button_pressed():
	# This is the placeholder for the future card upgrade action
	if not action_available:
		message_label.text = "Action already taken."
		return
		
	# Mark the action as taken
	action_available = false
	message_label.text = "Upgrade system is next! (Action taken)"
	
	# In a real game, you would show the card selection panel here.
	# _show_upgrade_panel()
	
	_update_ui_state()


func _on_map_button_pressed() -> void:
	# Assuming GameManager is a global singleton as in your shop script
	# This line assumes you have a map button connected to this script, 
	# but it's commented out in your @onready section.
	# If the map button is elsewhere, ensure the GameManager.return_to_map() is called correctly.
	GameManager.return_to_map()
