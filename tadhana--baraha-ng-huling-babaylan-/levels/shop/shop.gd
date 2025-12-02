extends Node

var player_entity
var player_node

var PlayerNodeScene = preload("res://entity/player/player_node.tscn")

@onready var shop_panel = $UI/ShopPanel
@onready var shop_cards_container = $UI/ShopPanel/Panel/CardsContainer
@onready var shop_info = $UI/ShopPanel/Panel/InfoLabel

var shop_inventory = []



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

	


	print("Shop initialized successfully ")


func _on_map_button_pressed() -> void:
	GameManager.return_to_map()


func _on_open_shop_pressed() -> void:
	print("Shop button clicked!")
	_generate_shop_inventory()
	_show_shop_panel()

func _generate_shop_inventory():
	shop_inventory = [
		CardDatabase.CARDS["sibat"].duplicate(true),
		CardDatabase.CARDS["hilot"].duplicate(true),
		CardDatabase.CARDS["kulam"].duplicate(true)
	]

	# Add default prices
	for c in shop_inventory:
		if not c.has("shop_cost"):
			c["shop_cost"] = 40 + randi_range(0,20)

	# Clear UI container
	for child in shop_cards_container.get_children():
		child.queue_free()

	# Create shop UI buttons
	for card_data in shop_inventory:
		var card_button = create_shop_button(card_data)
		shop_cards_container.add_child(card_button)


func create_shop_button(card_data):
	var btn = Button.new()

	btn.text = "%s\nCost: %d gold" % [card_data.card_name, card_data.shop_cost]
	btn.custom_minimum_size = Vector2(220, 120)

	btn.connect("pressed", func():
		_attempt_buy(card_data)
	)

	return btn

func _attempt_buy(card_data):
	var price = card_data["shop_cost"]

	if player_entity.gold < price:
		shop_info.text = "Not enough gold!"
		return

	# Deduct gold
	player_entity.gold -= price
	shop_info.text = "Purchased %s!" % card_data.card_name

	# Add to deck
	player_entity.deck.append(card_data)

func _show_shop_panel():
	shop_panel.visible = true


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
