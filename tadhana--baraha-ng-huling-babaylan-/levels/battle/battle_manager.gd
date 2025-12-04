extends Node

var battleroom_ref

var player_entity
var enemy_entity
var player_node
var enemy_node

var PlayerNodeScene = preload("res://entity/player/player_node.tscn")
var EnemyNodeScene  = preload("res://entity/enemy/enemy_node.tscn")
var HealthBarScene = preload("res://components/health bar/health_bar.tscn")
var CardScene = preload("res://cards/card.tscn")
var ManaCountScene = preload("res://components/mana count/mana_counter.tscn")
var TurnOverlayScene := preload("res://components/turn overlay/turn_overlay.tscn")


var CardEngineClass = preload("res://levels/battle/card_engine.gd") # Update path
var card_engine: CardEngine
# Card system
const HAND_LIMIT := 8
var hand_cards: Array = []

#Battle Loop Variables
var is_player_turn := true
var card_input_enabled := true
var turn_counter: int = 1

var player_healthbar
var enemy_healthbar

func start_battle(battleroom, node_info, player_ref):
	# store battleroom reference
	battleroom_ref = battleroom

	# store player entity
	player_entity = player_ref

	# CREATE PLAYER VISUAL NODE
	player_node = PlayerNodeScene.instantiate()
	battleroom_ref.get_node("PlayerContainer").add_child(player_node)
	
	player_node.battle_room = battleroom_ref  
	player_node.set_entity(player_entity)
	var spawn_point = battleroom_ref.get_node("PlayerContainer/PlayerSpawn").global_position
	player_node.global_position = spawn_point


	# CREATE ENEMY ENTITY
	var enemy_type = generate_random_enemy(node_info)
	enemy_entity = Enemy.new(enemy_type)

	# CREATE ENEMY VISUAL NODE
	enemy_node = EnemyNodeScene.instantiate()
	enemy_node.battle_room = battleroom_ref  
	battleroom_ref.get_node("EnemyContainer").add_child(enemy_node)

	enemy_node.set_entity(enemy_entity)
	var enemy_spawn = battleroom_ref.get_node("EnemyContainer/EnemySpawn").global_position
	enemy_node.global_position = enemy_spawn
	
	#Reset stats
	player_entity.hp = player_entity.max_hp
	player_entity.mana = player_entity.max_mana
	# HUD
	setup_ui()
	
	#instantiate card engine
	card_engine = CardEngineClass.new()
	
	#Start Battle Overlay
	show_turn_overlay("[b][img=64x64]res://components/turn overlay/assets/battle_start.png[/img][color=yellow]BATTLE START![/color][/b]",1)

	# Draw starting hand
	player_entity.draw_pile = player_entity.deck.duplicate()
	player_entity.draw_pile.shuffle()
	draw_starting_hand(5)
	battle_loop()
	
	
	print("Battle initialized successfully with enemy:", enemy_type)


func battle_loop():
	await start_player_turn()
	
func start_player_turn() -> void:
	process_turn_start_effects(player_entity,player_node)


	
	is_player_turn = true
	card_input_enabled = true

	if turn_counter > 1:
		show_turn_overlay("[b][color=cyan]PLAYER TURN[/color][/b]", 0.4)
		await get_tree().create_timer(0.4).timeout 

	# Reset mana
	battleroom_ref.get_node("UI/ManaContainer").get_child(0).set_mana(player_entity.max_mana, player_entity.max_mana)
	player_entity.mana = player_entity.max_mana
	
	#Reset block
	player_entity.block = 0
	
	#Reenable end turn button
	battleroom_ref.get_node("UI/EndTurnButton").disabled = false
	
	# Draw until hand has 6 cards
	draw_until_hand_size(6)
	



func end_player_turn():
	if !is_player_turn:
		return # prevent double clicks
	
	print("Player ends turn.")
	is_player_turn = false
	
	# Disable the button during enemy turn
	battleroom_ref.get_node("UI/EndTurnButton").disabled = true

	await start_enemy_turn()


func start_enemy_turn() -> void:
	process_turn_start_effects(enemy_entity,enemy_node)
	
	is_player_turn = false
	card_input_enabled = false
	
	

	show_turn_overlay("[b][color=red]ENEMY TURN[/color][/b]",0.4)

	# Wait for overlay + enemy action
	await get_tree().create_timer(1.0).timeout
	#enemy_attack()

   # End of enemy turn → back to player
	print("Skip to player turn")
	await start_player_turn()

	


func generate_random_enemy(node_info):
	var layer_rules = {
		1: ["kapre"],
		2: ["manananggal","aswang","kapre","white_lady"],
		3: ["manananggal"],
		4: ["default"],
		5: ["default"],
		6: ["default"],
		7: ["default"],
		8: ["default"],
		9: ["default"],
		10: ["default"],
		11: ["default"],
		12: ["default"]
	}

	var list = layer_rules[node_info.row_index]
	var i = randi_range(0, list.size() - 1)
	return list[i]


func setup_ui():
	# PLAYER HEALTH BAR
	player_healthbar = HealthBarScene.instantiate()
	battleroom_ref.get_node("UI/PlayerHUD").add_child(player_healthbar)
	player_healthbar.set_hp(player_entity.hp, player_entity.max_hp)

	# ENEMY HEALTH BAR
	enemy_healthbar = HealthBarScene.instantiate()
	battleroom_ref.get_node("UI/EnemyHUD").add_child(enemy_healthbar)
	enemy_healthbar.set_hp(enemy_entity.hp, enemy_entity.max_hp)
	
	var mana_container = ManaCountScene.instantiate()
	battleroom_ref.get_node("UI/ManaContainer").add_child(mana_container)
	mana_container.set_mana(player_entity.mana, player_entity.max_mana)


func get_hand_container():
	return battleroom_ref.get_node("UI/HandContainer")



func draw_card():
	# Limit reached
	if hand_cards.size() >= HAND_LIMIT:
		print("Hand is full!")
		return

	# Reshuffle discard if empty
	if player_entity.draw_pile.is_empty():
		reshuffle_discard_into_draw()

	# If still empty → no cards
	if player_entity.draw_pile.is_empty():
		print("No cards left to draw.")
		return

	var card_data = player_entity.draw_pile.pop_front()
	
	
	var card_node = CardScene.instantiate()
	var hand = get_hand_container()
	hand.add_child(card_node)
	card_node.set_card(card_data)
	
	#Connect to play card logic
	card_node.card_played.connect(_on_card_played)
	
	card_node.set_play_area(
	battleroom_ref.get_node("PlayArea"),
	battleroom_ref.get_node("PlayArea/SnapPoint")
	)
	
	card_node.battle_manager = self

	

	hand_cards.append(card_node)

	hand.arrange_cards()



func draw_starting_hand(amount = 5):
	for i in range(amount):
		draw_card()

func draw_until_hand_size(target_size: int) -> void:
	var hand = battleroom_ref.get_node("UI/HandContainer")
	while hand.get_child_count() < target_size:
		draw_card()


func reshuffle_discard_into_draw():
	if player_entity.discard_pile.is_empty():
		return

	player_entity.discard_pile.shuffle()

	for card in player_entity.discard_pile:
		player_entity.draw_pile.append(card)

	player_entity.discard_pile.clear()



func remove_card_from_hand(card_node, exhausted: bool = false):
	if card_node in hand_cards:
		hand_cards.erase(card_node)
	
	if exhausted:
		card_node.play_exhaust_animation()
		await get_tree().create_timer(0.3).timeout # allow animation to finish

		player_entity.exhaust_pile.append(card_node.card_data)
	else:
		player_entity.discard_pile.append(card_node.card_data)

	card_node.queue_free()

	get_hand_container().arrange_cards()


# -----------------------------
# 		UI RELATED LOGIC
# -----------------------------
func show_turn_overlay(text: String,duration):
	var overlay = TurnOverlayScene.instantiate()
	battleroom_ref.add_child(overlay)
	overlay.show_overlay(text,duration)

func update_player_health_display():
	player_healthbar.set_hp(player_entity.hp, player_entity.max_hp)

func update_enemy_health_display():
	enemy_healthbar.set_hp(enemy_entity.hp, enemy_entity.max_hp)

func process_turn_start_effects(entity, entity_node):
	var result = entity.resolve_turn_start_effects(self)

	# --- BLEED ---
	if result.get("bleed", 0) > 0:
		entity_node.show_floating_text(
			"Bleed  -" + str(result["bleed"]) + " HP",
			Color.RED
		)

	# --- FUTURE EFFECTS ---
	# if result.get("burn_damage", 0) > 0:
	#     entity_node.show_floating_text("🔥" + str(result["burn_damage"]), Color.ORANGE)

	# if result.get("poison_tick", 0) > 0:
	#     entity_node.show_floating_text("☠ " + str(result["poison_tick"]), Color.GREEN)

	# After animations → update UI
	update_player_health_display()
	update_enemy_health_display()


# -----------------------------
# 		CARD BATTLE LOGIC
# -----------------------------
func _on_card_played(card_node):
	var card_data = card_node.card_data
	var card_type = card_data.get("type", "")
	var caster = player_entity
	var target = enemy_entity

	print("Card played:", card_data.get("card_name", "Unknown Card"))

	# Prevent play during enemy turn
	if not is_player_turn:
		card_node.return_to_hand()
		return

	# Check mana cost
	var cost = card_data.get("cost", 0)
	if caster.mana < cost:
		print("Not enough mana!")
		card_node.return_to_hand()
		return

	# Spend mana
	caster.mana -= cost
	battleroom_ref.get_node("UI/ManaContainer").get_child(0).set_mana(caster.mana, caster.max_mana)

	# ----------------------------------------------------
	# 1. Play animations depending on type (no math here)
	# ----------------------------------------------------
	_play_card_animation(card_type, caster, target)

	# ----------------------------------------------------
	# 2. Apply all card effects using CardEngine (math only)
	# ----------------------------------------------------
	card_engine.resolve_effects(card_data, caster, target, self)

	# ----------------------------------------------------
	# 3. Update UI after math
	# ----------------------------------------------------
	_update_ui_after_effects()

	# ----------------------------------------------------
	# 4. Move card to discard or exhaust
	# ----------------------------------------------------
	var exhausted := false
	var effects = card_node.card_data.get("effects", [])
	for effect_def in effects:
		if typeof(effect_def) == TYPE_ARRAY and effect_def.size() > 0 and effect_def[0] == "exhaust":
			exhausted = true
			break

	remove_card_from_hand(card_node, exhausted)

	get_hand_container().arrange_cards()

func _update_ui_after_effects():
	player_healthbar.set_hp(player_entity.hp, player_entity.max_hp)
	enemy_healthbar.set_hp(enemy_entity.hp, enemy_entity.max_hp)

	# If your health bar shows block visually:
	if player_healthbar.has_method("update_block"):
		player_healthbar.update_block(player_entity.block)
	if enemy_healthbar.has_method("update_block"):
		enemy_healthbar.update_block(enemy_entity.block)


func _play_card_animation(card_type: String, caster, target):
	match card_type:
		"attack":
			player_node.play_attack_animation()
			target_node().play_hit_animation()

		"defend":
			player_node.play_add_block_animation(5) # no block number needed

		"spell":
			pass 
			#TODO : player_node.play_spell_animation()

		_:
			print("No animation for card type:", card_type)

func target_node():
	return enemy_node

# -----------------------------
# 		Returning Decks
# -----------------------------
func get_draw_pile():
	return player_entity.draw_pile

func get_discard_pile():
	return player_entity.discard_pile

func get_exhaust_pile():
	return player_entity.exhaust_pile

func get_full_deck():
	return player_entity.deck
