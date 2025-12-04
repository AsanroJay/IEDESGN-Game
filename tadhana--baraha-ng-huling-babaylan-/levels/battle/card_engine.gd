extends Node
class_name CardEngine


func resolve_effects(card_data: Dictionary, caster, target, battle_manager):
	# Effects list
	var effects: Array = card_data.get("effects", [])
	if effects.is_empty():
		return

	# Damage type (physical / magic / null)
	var property = card_data.get("property")

	## --- STEP 1: PRE-SCAN FOR ATTACK MODIFIERS ---
	# We need to know if the attack pierces BEFORE we process the "damage" effect.
	var is_piercing = false
	var is_lifesteal = false
	
	for effect_def in effects:
		if effect_def[0] == "pierce_armor":
			is_piercing = true
		if effect_def[0] == "lifesteal_unblocked":
			is_lifesteal = true

	# --- STEP 2: PROCESS EFFECTS ---
	for effect_def in effects:
		if typeof(effect_def) != TYPE_ARRAY or effect_def.is_empty():
			continue

		var effect_name = effect_def[0]
		var params = effect_def.slice(1)

		# Pass the flags we found in Step 1
		_process_effect(effect_name, params, property, is_piercing, is_lifesteal, caster, target, battle_manager)



func _process_effect(effect_name: String, params: Array, property, is_piercing, is_lifesteal, caster, target, battle_manager):
	match effect_name:

		# ---------------------------------------------------------
		# DAMAGE (Now handles Piercing!)
		# ---------------------------------------------------------
		"damage":
			var amount = params[0]
			# Pass the piercing flag to the entity!
			target.apply_damage(amount, property, is_piercing)
			print("CardEngine: Dealt ", amount, " damage (" + str(property) + "). Piercing:", is_piercing)

		# ---------------------------------------------------------
		# LIFESTEAL (Uses the Entity's memory of damage taken)
		# ---------------------------------------------------------
		"lifesteal_unblocked":
			var healed = target.last_unblocked_damage
			if healed > 0:
				caster.heal(healed)
				battle_manager.update_player_health_display()
				
			if caster == battle_manager.player_entity:
				battle_manager.player_node.show_floating_text("Healed +" + str(healed) + " HP", Color.GREEN, -60)
			else:
				battle_manager.enemy_node.show_floating_text("Healed +" + str(healed) + " HP", Color.GREEN, -60)
				
			print("CardEngine: Lifesteal healed: ", healed)
		# ---------------------------------------------------------
		# BLOCK
		# ---------------------------------------------------------
		"block":
			var amount = params[0]
			caster.gain_block(amount)
			print("CardEngine: Gained", amount, "block.")

		# ---------------------------------------------------------
		# HEAL
		# ---------------------------------------------------------
		"heal":
			var amount = params[0]
			caster.heal(amount)
			
			if caster == battle_manager.player_entity:
				battle_manager.player_node.show_floating_text("Healed +" + str(amount) + " HP", Color.GREEN, -60)
			else:
				battle_manager.enemy_node.show_floating_text("Healed +" + str(amount) + " HP", Color.GREEN, -60)

		# ---------------------------------------------------------
		# DRAW CARDS
		# ---------------------------------------------------------
		"draw":
			var count = params[0]
			for i in count:
				battle_manager.draw_card()
			print("CardEngine: Drew", count, "cards.")

		# ---------------------------------------------------------
		# BLEED (stacking DOT)
		# ---------------------------------------------------------
		"bleed":
			var stacks = params[0]
			target.add_status("Bleed", stacks)
			print("CardEngine: Applied Bleed", stacks)


		# ---------------------------------------------------------
		# STUN
		# ---------------------------------------------------------
		"enemy_stun_next_turn":
			target.set_status("Stun", 1)
			print("CardEngine: Applied Stun")

		# ---------------------------------------------------------
		# REMOVE ARMOR / BLOCK
		# ---------------------------------------------------------
		"remove_enemy_armor":
			target.block = 0
			print("CardEngine: Removed enemy block.")

		# ---------------------------------------------------------
		# CLEANSE SELF DEBUFFS
		# ---------------------------------------------------------
		"cleanse":
			caster.statuses.clear()
			print("CardEngine: All debuffs cleansed.")

		# ---------------------------------------------------------
		# Lifesteal (damage must be unblocked)
		# ---------------------------------------------------------
		"lifesteal_unblocked":
			# target.last_damage_taken should be stored in apply_damage()
			var healed = target.last_unblocked_damage
			if healed > 0:
				caster.heal(healed)
			print("CardEngine: Lifesteal healed", healed)

		# ---------------------------------------------------------
		# INCREASE enemy damage taken
		# ---------------------------------------------------------
		"increase_enemy_damage_taken":
			var mult = params[0]
			target.add_status("DamageTakenMult", mult)
			print("CardEngine: Enemy damage taken multiplier increased:", mult)

		# ---------------------------------------------------------
		# MORE TODO EFFECTS
		# ---------------------------------------------------------
		"flip_resistance":
			print("TODO: flip_resistance")

		"flood":
			print("TODO: flood effect", params)

		"force_physical_next_turn":
			caster.set_status("ForcePhysical", 1)
			print("TODO: force_physical_next_turn")

		"burn":
			print("TODO: burn effect", params)

		"ignore_armor_next_attack":
			caster.set_status("IgnoreArmorNext", 1)
			print("TODO: ignore_armor_next_attack")

		"return_exhausted":
			print("TODO: return_exhausted")

		"fetch_card_cost0":
			print("TODO: fetch_card_cost0")

		"add_random_cards_cost0":
			print("TODO: add_random_cards_cost0")

		"set_hand_cost_zero":
			print("TODO: set_hand_cost_zero")

		"block_attack":
			print("TODO: block_attack")

		"enemy_miss_chance":
			print("TODO: enemy_miss_chance")

		"confuse":
			print("TODO: confuse")

		"pierce_armor":
			caster.set_status("Piercing", 1)
			print("TODO: pierce_armor (flag for next damage calc)")

		# ---------------------------------------------------------
		# UNKNOWN EFFECT
		# ---------------------------------------------------------
		_:
			print("CardEngine ERROR: Unknown effect:", effect_name)
