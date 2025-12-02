extends Control
class_name DeckOverlay

@onready var title_label = $Panel/TitleLabel
@onready var card_container = $Panel/CardsContainer
@onready var close_button = $Panel/CloseButton

signal overlay_closed

func _ready():
	visible = false
	close_button.pressed.connect(_on_close)

func open_overlay(title: String, cards: Array):
	title_label.text = title
	visible = true

	# Clear old cards
	for c in card_container.get_children():
		c.queue_free()

	# Display cards
	for card in cards:
		var card_entry = create_card_entry(card)
		card_container.add_child(card_entry)

func _on_close():
	visible = false
	emit_signal("overlay_closed")

func create_card_entry(card_data):
	# SIMPLE VERSION (text only)
	var label = Label.new()
	label.text = "%s (Cost: %d)" % [card_data.card_name, card_data.cost]
	return label
