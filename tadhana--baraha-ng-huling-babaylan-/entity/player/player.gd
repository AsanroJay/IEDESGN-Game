extends Entity
class_name Player

var sprite_path : String = "res://player/assets/player.png"
var discard_pile = []
var draw_pile = []
var gold
var max_mana
#Constructor
func _init() -> void:
	entity_name = "Player"
	hp = 50
	max_hp = 50
	mana = 3
	max_mana = 3
	
	_initialize_starting_deck()
	

func _initialize_starting_deck():
	# Attack cards
	for i in range(4):
		var atk = {
			"name": "Attack",
			"type": "attack",
			"image_path": "res://cards/assets/default_card.png",
			"damage": 6,
			"cost": 1
		}
		deck.append(atk)

	# Defense cards
	for i in range(4):
		var def = {
			"name": "Defend",
			"type": "defend",
			"image_path": "res://cards/assets/default_card.png",
			"block": 5,
			"cost": 1
		}
		deck.append(def)

func add_block(block_amt):
	block += block_amt
