extends Node2D
class_name DeckOverlay

@onready var title_label = $Panel/TitleLabel
@onready var card_container = $Panel/GridContainer
@onready var close_button = $Panel/CloseButton

var DeckCardScene = preload("res://components/deck overlay/deck_card.tscn")

signal overlay_closed
signal card_selected(card_data)   



func _ready():
	visible = false
	await get_tree().process_frame  #
	await get_tree().process_frame  

	close_button = $Panel/CloseButton
	title_label = $Panel/TitleLabel
	card_container = $Panel/GridContainer

	print("DeckOverlay Loaded Correctly:")
	print(" - title_label =", title_label)
	print(" - card_container =", card_container)
	print(" - close_button =", close_button)

	if close_button:
		close_button.pressed.connect(_on_close)



func open_overlay(title: String, cards: Array, selectable := false):
	title_label.text = title
	visible = true

	# Clear previous cards
	for c in card_container.get_children():
		c.queue_free()

	# Populate new cards
	for card_data in cards:
		var card_entry = DeckCardScene.instantiate()

		# Add to grid setup to avoid onready issues
		card_container.add_child(card_entry)
		card_entry.setup(card_data)

		if selectable:
			card_entry.card_clicked.connect(_on_card_clicked)


func _on_card_clicked(card_data):
	emit_signal("card_selected", card_data)
	visible = false


func _on_close():
	visible = false
	emit_signal("overlay_closed")
