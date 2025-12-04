extends Node

var player_entity
var player_node

var PlayerNodeScene = preload("res://entity/player/player_node.tscn")
var ShopCardItemScene = preload("res://components/shop card item/shop_card_item.tscn")


@onready var shop_panel = $UI/ShopPanel
@onready var shop_cards_container = $UI/ShopPanel/Panel/CardsContainer
@onready var shop_info = $UI/ShopPanel/Panel/InfoLabel
@onready var skip_button = $SkipButton


var shop_inventory = []
var reroll_cost = 30





func load_shop_room(node_info, player_ref):
	# store player entity
	player_entity = player_ref

	# CREATE PLAYER VISUAL NODE
	player_node = PlayerNodeScene.instantiate()
	get_node("PlayerContainer").add_child(player_node)

	player_node.set_entity(player_entity)
	var spawn_point = get_node("PlayerContainer/PlayerSpawn").global_position
	player_node.global_position = spawn_point
	
	shop_panel.visible = false
	skip_button.visible = true

	


	print("Shop initialized successfully ")


func _on_map_button_pressed() -> void:
	GameManager.return_to_map()


func _on_open_shop_pressed() -> void:
	print("Shop button clicked!")
	_generate_shop_inventory()
	_show_shop_panel()
	
func reroll_cards():
	if player_entity.gold < reroll_cost:
		shop_info.text = "Not enough gold to reroll!"
		return

	player_entity.gold -= reroll_cost

	# Regenerate new shop inventory + UI
	_generate_shop_inventory()

	shop_info.text = "Shop rerolled for %d gold!" % reroll_cost

	
func get_random_shop_card() -> Dictionary:
	var pool = CardDatabase.CARDS.keys()

	# Pick a random card ID
	var id = pool[randi() % pool.size()]

	# Always deep-duplicate so effects don't overwrite the DB
	var card = CardDatabase.CARDS[id].duplicate(true)

	# Give shop price if missing
	if not card.has("shop_cost"):
		card["shop_cost"] = 24 + randi_range(10,15) * card["cost"]

	return card


func _generate_shop_inventory():
	shop_inventory.clear()

	# Generate 6 random cards
	for i in range(6):
		shop_inventory.append(get_random_shop_card())

	# Clear UI
	for child in shop_cards_container.get_children():
		child.queue_free()

	# Spawn the cards into UI
	for card_data in shop_inventory:
		var item = create_shop_item(card_data)



func create_shop_item(card_data):
	var item = ShopCardItemScene.instantiate()
	shop_cards_container.add_child(item)
	item.setup(card_data, _attempt_buy)



func _attempt_buy(card_data):
	var price = card_data["shop_cost"]

	if player_entity.gold < price:
		shop_info.text = "Not enough gold!"
		return

	# Deduct gold
	player_entity.gold -= price
	shop_info.text = "Purchased %s!" % card_data["card_name"]

	# Add to deck
	player_entity.deck.append(card_data)

func _show_shop_panel():
	shop_panel.visible = true
	skip_button.visible = false


func _on_hover_area_mouse_entered() -> void:
	var sprite = $ShopKeeperContainer
	# white highlight
	sprite.modulate = Color(1.2, 1.2, 1.2)


func _on_hover_area_mouse_exited() -> void:
	var sprite = $ShopKeeperContainer
	# white highlight
	sprite.modulate = Color(1, 1, 1)


func _on_close_button_pressed() -> void:
	shop_panel.visible = false
	skip_button.visible = true


func _on_reroll_button_pressed() -> void:
	reroll_cards()


func _on_skip_button_pressed() -> void:
	GameManager.return_to_map()
