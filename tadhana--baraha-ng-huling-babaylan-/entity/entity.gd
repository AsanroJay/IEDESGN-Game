extends Node
class_name Entity

var entity_name: String = "Entity"
var deck = []
var hp: int = 0
var mana: int = 0
var block: int = 0
var max_hp: int = 0

# Store this for Lifesteal calculations
var last_unblocked_damage: int = 0 
var resistances := {
	"physical": 1.0,
	"magic": 1.0,
	"true_damage": 1.0 # True damage usually ignores resistance
}

var statuses := {}

signal block_changed(new_block_value)



# Updated to accept Property (physical/magic) and Piercing flag
func apply_damage(amount: int, property: String = "physical", is_piercing: bool = false) -> int:
	var multiplier: float = 1.0
	
	# 1. Check Global Modifiers (Vulnerable)
	if statuses.has("Vulnerable"):
		multiplier = 1.5 
	
	# --- 1b. Check Entity Resistance ---
	var resistance_multiplier: float = resistances.get(property, 1.0)
	
	# Ensure True Damage (from DOTs) bypasses typical resistance/vulnerability checks, 
	# but we keep the multiplier in the calculation just in case.
	if property != "true_damage":
		multiplier *= resistance_multiplier
		
		# You can add logic here for special statuses like 'FlipResistance'
		if statuses.has("ResistanceFlip"):
			# This would reverse the logic if property was Magic/Physical
			pass

	var incoming_damage = roundi(amount * multiplier)
	var damage_to_hp = 0
	
	# 2. Calculate Block
	if is_piercing:
		# ... (Piercing logic remains the same)
		damage_to_hp = incoming_damage
		print(entity_name, " takes PIERCING ", property, " damage (ignores block).")
	else:
		# Standard block logic
		damage_to_hp = max(0, incoming_damage - block)
		block = max(0, block - incoming_damage)

	# 3. Apply to HP
	# ... (Rest of the function remains the same) ...

	hp = max(0, hp - damage_to_hp)
	last_unblocked_damage = damage_to_hp
	
	print(entity_name, " takes ", damage_to_hp, " damage (Type: ", property, ") → HP:", hp, " Block:", block)

	if is_dead():
		print(entity_name, " has been defeated!")
		
	return damage_to_hp


func heal(amount: int) -> void:
	hp = min(max_hp, hp + amount)
	print(entity_name, " heals for ", amount, " → HP:", hp)


func gain_block(amount: int) -> void:
	block += amount
	print(entity_name, " gains ", amount, " block → Block:", block)
	block_changed.emit(block)


func add_status(status_name: String, stacks: int) -> void:
	statuses[status_name] = statuses.get(status_name, 0) + stacks
	print(entity_name, " gains ", stacks, " stacks of ", status_name)


func set_status(status_name: String, turns: int) -> void:
	statuses[status_name] = turns
	print(entity_name, " set ", status_name, " for ", turns, " turn(s).")


func has_status(status_name: String) -> bool:
	return statuses.has(status_name)


func is_dead() -> bool:
	return hp <= 0

func resolve_turn_start_effects(battle_manager) -> void:
	var effects_to_remove = []
	var damage_from_effects = 0
	
	for name in statuses.keys():
		var amount = statuses[name]
		
		match name:
			"Bleed":
				damage_from_effects += amount
				statuses[name] -= 1
				print(entity_name, " bleeds for ", amount)
			
			"Poison":
				# Poison typically decays duration, not damage amount
				# Assuming you stored duration in a separate key or handled logic differently
				# For now, simplistic implementation:
				damage_from_effects += amount
				statuses["PoisonDuration"] -= 1 # You need to manage the duration key
				if statuses["PoisonDuration"] <= 0:
					effects_to_remove.append(name)
					effects_to_remove.append("PoisonDuration")
					
			"Stun":
				statuses[name] -= 1
				
			_:
				statuses[name] -= 1

		if statuses.has(name) and statuses[name] <= 0 and not name in effects_to_remove:
			effects_to_remove.append(name)
			
	if damage_from_effects > 0:
		apply_damage(damage_from_effects, "true_damage")
	
	for name in effects_to_remove:
		statuses.erase(name)

	# Update UI logic here
	if damage_from_effects > 0:
		if self == battle_manager.player_entity:
			battle_manager.update_player_health_display()
		elif self == battle_manager.enemy_entity:
			battle_manager.update_enemy_health_display()
