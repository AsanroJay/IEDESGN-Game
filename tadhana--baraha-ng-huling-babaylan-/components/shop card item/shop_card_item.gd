extends VBoxContainer

var card_data
var buy_callback

@onready var card_art = $CardArt
@onready var card_name = $CardName
@onready var cost_label = $CostLabel
@onready var buy_button = $BuyButton


func setup(data, callback):
	card_data = data
	buy_callback = callback
	
	print("SHOP CARD ITEM RECEIVED", card_data)
	# Load image correctly (dictionary lookup!)  
	var img_path = card_data["image_path"]
	if img_path != "":
		var tex = load(img_path)
		if tex:
			card_art.texture = tex
		else:
			print("FAILED TO LOAD:", img_path)

	# Text labels
	card_name.text = card_data["card_name"]
	cost_label.text = "Cost: %d gold" % card_data["shop_cost"]

	# Buy button
	buy_button.text = "Buy"
	buy_button.pressed.connect(_on_buy_pressed)



func _on_buy_pressed():
	if buy_callback:
		buy_callback.call(card_data)
