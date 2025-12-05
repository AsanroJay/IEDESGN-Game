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
		
	for i in range(1):
		var sipa = {
		"card_name": "Hilot",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/hilot.png",
		"property": "buff",
		"effects": [
			["heal", 5],
			["exhaust"]
		],
		"exhaust": true
	}

		deck.append(sipa)
		
	for i in range(1):
		var sipa =    {
		"card_name": "Tagiyamo",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/tagiyamo.png",
		"property": "buff",
		"effects": [
			["cleanse"]
		],
		"exhaust": false
	}

		deck.append(sipa)

func add_block(block_amt):
	block += block_amt
# Inside Entity.gd (or Player.gd)


func reset_battle_stats():
	# 1. Clear all temporary statuses
	statuses.clear()
	
	# 2. Reset block
	block = 0
	
	# 3. Reset mana
	mana = max_mana 
	
	# NOTE: We do NOT reset HP here, as HP persistence is core to a roguelike!
	print(entity_name, " battle stats and statuses have been reset.")
