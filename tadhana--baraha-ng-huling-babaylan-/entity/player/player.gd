extends Entity
class_name Player

var sprite_path : String = "res://player/assets/player.png"
var discard_pile = []
var draw_pile = []
var exhaust_pile = []
var gold
var max_mana
#Constructor
func _init() -> void:
	entity_name = "Player"
	hp = 50
	max_hp = 50
	mana = 3
	max_mana = 3
	gold = 99
	
	_initialize_starting_deck()
	

func _initialize_starting_deck():
	# Attack cards
	for i in range(3):
		var atk = {
		"card_name": "Sibat",
		"type": "attack",
		"cost": 1,
		"image_path": "res://cards/assets/sibat.png",
		"property": "physical",
		"effects": [
			["damage", 5]
		],
		"exhaust": false
	}
		deck.append(atk)

	# Defense cards
	for i in range(3):
		var def=  {
		"card_name": "Suntok ng Kapre",
		"type": "attack",
		"cost": 2,
		"image_path": "res://cards/assets/suntok_ng_kapre.png",
		"property": "physical",
		"effects": [
			["damage", 7],
			["pierce_armor"]
		],
		"exhaust": false
		}
		deck.append(def)
		
	for i in range(3):
		var sipa = {
		"card_name": "Sipa ng Tikbalang",
		"type": "attack",
		"cost": 2,
		"image_path": "res://cards/assets/sipa_ng_tikbalang.png",
		"property": "physical",
		"effects": [
			["damage", 4],
			["draw", 2]
		],
		"exhaust": false
		}

		deck.append(sipa)

func add_block(block_amt):
	block += block_amt
