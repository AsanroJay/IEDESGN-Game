extends CanvasLayer
class_name RewardOverlay

signal reward_chosen(card_data)

@onready var card_container = $Panel/CardContainer
@onready var title_label = $Panel/TitleLabel

var CardDisplayScene := preload("res://components/deck overlay/deck_card.tscn")

var card_pool = []   # ← inject your pool externally or assign in ready

func open_reward(card_pool: Array):
	visible = false

	# Clear container
	for c in card_container.get_children():
		c.queue_free()

	# ---- Pick EXACTLY 3 random cards ----
	var reward_cards := []
	for i in range(3):
		reward_cards.append(card_pool.pick_random())

	# ---- Spawn clickable deck cards ----
	for card_data in reward_cards:
		var card_entry = CardDisplayScene.instantiate()

		# ★ Scale the card smaller (adjust 0.6 to your liking)
		card_entry.scale = Vector2(0.2, 0.2)

		card_container.add_child(card_entry)

		card_entry.setup(card_data)
		card_entry.card_clicked.connect(_on_card_selected)



func _on_card_selected(card_data):
	emit_signal("reward_chosen", card_data)
	visible = false
