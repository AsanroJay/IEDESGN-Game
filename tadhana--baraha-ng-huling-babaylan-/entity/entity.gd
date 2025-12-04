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

var bonus_damage_taken: float = 0.0 # 0.2 = +20%, 0.5 = +50%


signal block_changed(new_block_value)



func apply_damage(amount: int, property: String = "physical", is_piercing: bool = false) -> int:
	var multiplier: float = 1.0

	# TRUE DAMAGE (skip everything except direct HP loss)
	if property == "true_damage":
		var dmg = amount
		hp = max(0, hp - dmg)
		last_unblocked_damage = dmg
		print(entity_name, " takes TRUE DAMAGE ", dmg, " → HP:", hp, " Block:", block)
		return dmg

	# Vulnerable
	if statuses.has("Vulnerable"):
		multiplier *= 1.5

	# Resistance
	var resistance_multiplier: float = resistances.get(property, 1.0)
	multiplier *= resistance_multiplier

	# Base damage
	var incoming_damage = roundi(amount * multiplier)

	# Damage Taken Multiplier (Basbas ng Mangkukulam)
	if bonus_damage_taken > 0.0:
		incoming_damage = roundi(incoming_damage * (1.0 + bonus_damage_taken))


	var damage_to_hp = 0

	# Block calc
	if is_piercing:
		damage_to_hp = incoming_damage
	else:
		damage_to_hp = max(0, incoming_damage - block)
		block = max(0, block - incoming_damage)

	hp = max(0, hp - damage_to_hp)
	last_unblocked_damage = damage_to_hp

	print(entity_name, " takes ", damage_to_hp, " damage → HP:", hp, " Block:", block)

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

func resolve_turn_start_effects(battle_manager) -> Dictionary:
	var result := {"bleed": 0}
	var effects_to_remove = []
	var damage_from_effects = 0
	
	for name in statuses.keys():
		var amount = statuses[name]
		
		match name:
			"Bleed":
				damage_from_effects += amount
				result["bleed"] += amount
				statuses[name] -= 1
				print(entity_name, " bleeds for ", amount)
			
			"Stun":
				statuses[name] -= 1

			_:
				statuses[name] -= 1

		if statuses[name] <= 0:
			effects_to_remove.append(name)
			
	if damage_from_effects > 0:
		apply_damage(damage_from_effects, "true_damage")
	
	for name in effects_to_remove:
		statuses.erase(name)

	return result
