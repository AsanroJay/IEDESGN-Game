extends Node
class_name CardDB

# Master dictionary of all cards
var CARDS := {
	"default": {
		"card_name": "Default",
		"type": "attack",
		"cost": 1,
		"image_path": "res://cards/assets/default_card.png",
		"damage": 6,
		"block": 0,
		"effect": null
	},

	"defend": {
		"card_name": "Defend",
		"type": "defend",
		"cost": 1,
		"image_path": "res://cards/assets/defend.png",
		"damage": 0,
		"block": 5,
		"effect": null
	},

	"strike": {
		"card_name": "Strike",
		"type": "attack",
		"cost": 1,
		"image_path": "res://cards/assets/strike.png",
		"damage": 6,
		"block": 0,
		"effect": null
	},

	"bash": {
		"card_name": "Bash",
		"type": "attack",
		"cost": 2,
		"image_path": "res://cards/assets/bash.png",
		"damage": 8,
		"block": 0,
		"effect": "apply_vulnerable"
	}
}


# Returns a clean COPY of card data (NOT a reference)
func get_card(id: String) -> Dictionary:
	if CARDS.has(id):
		return CARDS[id].duplicate(true)
	else:
		push_warning("Card ID not found: %s" % id)
		return CARDS["default"].duplicate(true)
		
