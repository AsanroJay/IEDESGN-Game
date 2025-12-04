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
		var def = {
		"card_name": "Kalasag",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/kalasag.png",
		"property": "debuff",
		"effects": [
			["block",5],
		],
		"exhaust": false
	}
		deck.append(def)

	# Defense cards
	for i in range(3):
		var atk=  {
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
		
	for i in range(3):
		var sipa = {
		"card_name": "Kagat ng Bakunawa",
		"type": "attack",
		"cost": 3,
		"image_path": "res://cards/assets/kagat_ng_bakunawa.png",
		"property": "physical",
		"effects": [
			["bleed", 7]
		],
		"exhaust": false
	}

		deck.append(sipa)
		
	for i in range(2):
		var sipa =  {
		"card_name": "Kagat ng Aswang",
		"type": "attack",
		"cost": 3,
		"image_path": "res://cards/assets/kagat_ng_aswang.png",
		"property": "physical",
		"effects": [
			["damage", 7],
			["lifesteal_unblocked"]
		],
		"exhaust": false
	}

		deck.append(sipa)

func add_block(block_amt):
	block += block_amt
