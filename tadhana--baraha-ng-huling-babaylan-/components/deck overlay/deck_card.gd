extends TextureButton
class_name DeckCard

signal card_clicked(card_data)

var card_data


func setup(data):
	card_data = data
	populate()


func populate():
	var tex = load(card_data["image_path"])
	if tex:
		texture_normal = tex
		texture_hover = tex
		texture_pressed = tex
		texture_disabled = tex


func _ready():
	connect("pressed", Callable(self, "_on_pressed"))
	connect("mouse_entered", Callable(self, "_on_hover"))
	connect("mouse_exited", Callable(self, "_on_unhover"))


func _on_pressed():
	emit_signal("card_clicked", card_data)


func _on_hover():
	# smooth Slay-the-Spire enlarge
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1.15, 1.15), 0.1)
	z_index = 10   # bring to front


func _on_unhover():
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1, 1), 0.1)
	z_index = 0
