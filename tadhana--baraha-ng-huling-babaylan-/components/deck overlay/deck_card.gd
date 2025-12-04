extends VBoxContainer
class_name DeckCard

signal card_clicked(card_data)

var card_data
@onready var card_image = $CardImage

func setup(data):
	card_data = data
	populate()
	setup_interactions()

func populate():
	var tex = load(card_data["image_path"])
	if tex:
		card_image.texture = tex

func setup_interactions():
	card_image.gui_input.connect(_on_gui_input)
	card_image.mouse_entered.connect(_on_hover)
	card_image.mouse_exited.connect(_on_unhover)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("card_clicked", card_data)

func _on_hover():
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	z_index = 10

func _on_unhover():
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1, 1), 0.1)
	z_index = 0
