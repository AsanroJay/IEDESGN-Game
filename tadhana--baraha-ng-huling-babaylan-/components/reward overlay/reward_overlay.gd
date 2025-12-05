extends CanvasLayer
class_name RewardOverlay

signal reward_chosen(card_data)

@onready var card_container = $Panel/CardContainer
@onready var title_label = $Panel/TitleLabel

var CardDisplayScene := preload("res://components/deck overlay/deck_card.tscn")

func open_reward(cards: Array):
	visible = true

	# Clear old cards
	for c in card_container.get_children():
		c.queue_free()

	# Add reward cards
	for card_data in cards:
		var card_entry = CardDisplayScene.instantiate()
		card_container.add_child(card_entry)
		card_entry.setup(card_data)

		card_entry.card_clicked.connect(_on_card_selected.bind(card_data))


func _on_card_selected(card_data):
	emit_signal("reward_chosen", card_data)
	visible = false
