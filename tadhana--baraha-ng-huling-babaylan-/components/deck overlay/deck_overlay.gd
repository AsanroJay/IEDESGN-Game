extends Node2D
class_name DeckOverlay

@onready var title_label = $Panel/TitleLabel
@onready var scroll_container = $Panel/ScrollContainer
@onready var card_container = $Panel/ScrollContainer/GridContainer
@onready var close_button = $Panel/CloseButton

var DeckCardScene = preload("res://components/deck overlay/deck_card.tscn")

signal overlay_closed
signal card_selected(card_data)


func _ready():
	visible = false

	# Wait 1 frame so children fully initialize
	await get_tree().process_frame

	print("\n[DeckOverlay Loaded]")
	print(" Title Label:", title_label)
	print(" ScrollContainer:", scroll_container)
	print(" GridContainer:", card_container)
	print(" CloseButton:", close_button)

	close_button.pressed.connect(_on_close)


func open_overlay(title: String, cards: Array, selectable := false):
	title_label.text = title
	visible = true

	# Clear old cards
	for c in card_container.get_children():
		c.queue_free()

	# Add card entries
	for card_data in cards:
		var card_entry = DeckCardScene.instantiate()
		card_container.add_child(card_entry)
		card_entry.setup(card_data)

		if selectable:
			card_entry.card_clicked.connect(_on_card_clicked)

	# Force ScrollContainer to update scrollbars after cards added
	await get_tree().process_frame
	scroll_container.ensure_control_visible(card_container)


func _on_card_clicked(card_data):
	emit_signal("card_selected", card_data)
	visible = false


func _on_close():
	visible = false
	emit_signal("overlay_closed")
