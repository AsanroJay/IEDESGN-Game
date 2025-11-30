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

	player_node.set_entity(player_entity)
	var spawn_point = battleroom_ref.get_node("PlayerContainer/PlayerSpawn").global_position
	player_node.global_position = spawn_point


	# CREATE ENEMY ENTITY
	var enemy_type = generate_random_enemy(node_info)
	enemy_entity = Enemy.new(enemy_type)

	# CREATE ENEMY VISUAL NODE
	enemy_node = EnemyNodeScene.instantiate()
	battleroom_ref.get_node("EnemyContainer").add_child(enemy_node)

	enemy_node.set_entity(enemy_entity)
	var enemy_spawn = battleroom_ref.get_node("EnemyContainer/EnemySpawn").global_position
	enemy_node.global_position = enemy_spawn
	
	#Reset stats
	player_entity.hp = player_entity.max_hp
	player_entity.mana = player_entity.max_mana
	# HUD
	setup_ui()
	
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
	is_player_turn = true
	card_input_enabled = true

	if turn_counter > 1:
		show_turn_overlay("[b][color=cyan]PLAYER TURN[/color][/b]",0.4)

	# Reset mana
	battleroom_ref.get_node("UI/ManaContainer").get_child(0).set_mana(player_entity.mana,player_entity.max_mana)

	# WAIT for player to finish their turn (button press)
	#await wait_for_player_end_turn()

	#await start_enemy_turn()

func end_player_turn():
	if !is_player_turn:
		return # prevent double clicks
	
	print("Player ends turn.")
	is_player_turn = false
	
	# Disable the button during enemy turn
	battleroom_ref.get_node("UI/EndTurnButton").disabled = true

	await start_enemy_turn()


func start_enemy_turn() -> void:
	is_player_turn = false
	card_input_enabled = false

	show_turn_overlay("[b][color=red]ENEMY TURN[/color][/b]",0.4)

	# Wait for overlay + enemy action
	await get_tree().create_timer(1.0).timeout
	#enemy_attack()

   # End of enemy turn → back to player
 	#start_player_turn()

	


func generate_random_enemy(node_info):
	var layer_rules = {
		1: ["default","aswang"],
		2: ["default","aswang"],
		3: ["default"],
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



func reshuffle_discard_into_draw():
	if player_entity.discard_pile.is_empty():
		return

	player_entity.discard_pile.shuffle()

	for card in player_entity.discard_pile:
		player_entity.draw_pile.append(card)

	player_entity.discard_pile.clear()



func remove_card_from_hand(card_node):
	if card_node in hand_cards:
		hand_cards.erase(card_node)

	player_entity.discard_pile.append(card_node.card_data)
	card_node.queue_free()

	get_hand_container().arrange_cards()
	
func show_turn_overlay(text: String,duration):
	var overlay = TurnOverlayScene.instantiate()
	battleroom_ref.add_child(overlay)
	overlay.show_overlay(text,duration)
	
# -----------------------------
# 		CARD BATTLE LOGIC
# -----------------------------
func _on_card_played(card_node):
	print("Card played: ", card_node.card_data)

	# Check mana
	var cost = card_node.card_data.get("cost", 0)
	if player_entity.mana < cost:
		print("Not enough mana!")
		#TODO: implememt a text pop up saying not enough mana
		card_node.return_to_hand()
		
		return

	# Deduct mana
	player_entity.mana -= cost
	battleroom_ref.get_node("UI/ManaContainer").get_child(0).set_mana(player_entity.mana,player_entity.max_mana)

	# Apply effects depending on card type
	var type = card_node.card_data.get("type", "")

	match type:
		"attack":
			_play_attack_card(card_node)
		"defend":
			#TODO: animation effect on block
			_play_defend_card(card_node)
		"spell":
			#TODO: animation effect on spell
			_play_spell_card(card_node)
		_:
			print("Unknown card type: ", type)

	# Remove card from hand & move to discard
	remove_card_from_hand(card_node)
	get_hand_container().arrange_cards()


func _play_attack_card(card_node):
	var dmg = card_node.card_data.get("damage", 0)
	print("Attack card deals ", dmg, " damage!")
	
	#PLAYER ANIMATION
	player_node.play_attack_animation()
	#ENEMY ANIMATIONS
	enemy_entity.take_damage(dmg)
	enemy_healthbar.set_hp(enemy_entity.hp, enemy_entity.max_hp) #healthbar 
	enemy_node.play_hit_animation()
	
func _play_defend_card(card_node):
	var block = card_node.card_data.get("block", 0)
	print("Gained ", block, " block!")
	player_entity.add_block(block)

func _play_spell_card(card_node):
	print("Spell card activated: ", card_node.card_data["name"])
	# Add your buff logic here
