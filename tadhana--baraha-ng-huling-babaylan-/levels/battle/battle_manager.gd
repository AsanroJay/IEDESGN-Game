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

# Card system
const HAND_LIMIT := 8
var hand_cards: Array = []


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

	# HUD
	setup_ui()

	# Draw starting hand
	player_entity.draw_pile = player_entity.deck.duplicate()
	player_entity.draw_pile.shuffle()
	draw_starting_hand(5)
	
	print("Battle initialized successfully with enemy:", enemy_type)



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
	var player_healthbar = HealthBarScene.instantiate()
	battleroom_ref.get_node("UI/PlayerHUD").add_child(player_healthbar)
	player_healthbar.set_hp(player_entity.hp, player_entity.max_hp)

	# ENEMY HEALTH BAR
	var enemy_healthbar = HealthBarScene.instantiate()
	battleroom_ref.get_node("UI/EnemyHUD").add_child(enemy_healthbar)
	enemy_healthbar.set_hp(enemy_entity.hp, enemy_entity.max_hp)
	
	var mana_container = ManaCountScene.instantiate()
	battleroom_ref.get_node("UI/ManaContainer").add_child(mana_container)
	mana_container.set_mana(player_entity.mana)


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
