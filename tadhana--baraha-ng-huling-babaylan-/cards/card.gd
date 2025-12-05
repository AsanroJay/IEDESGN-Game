extends Node
class_name CardDB

var CARDS = {
	# ------------------------
	# PHYSICAL ATTACK CARDS
	# ------------------------
	"sibat": {
		"card_name": "Sibat",
		"type": "attack",
		"cost": 1,
		"image_path": "res://cards/assets/sibat.png",
		"property": "physical",
		"effects": [
			["damage", 5]
		],
		"exhaust": false
	},

	"sipa_ng_tikbalang": {
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
	},

	"suntok_ng_kapre": {
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
	},

	"hiwa_ng_manananggal": {
		"card_name": "Hiwa ng Manananggal",
		"type": "attack",
		"cost": 2,
		"image_path": "res://cards/assets/hiwa_ng_manananggal.png",
		"property": "physical",
		"effects": [
			["damage", 4],
			["bleed", 3]
		],
		"exhaust": false
	},

	"kagat_ng_bakunawa": {
		"card_name": "Kagat ng Bakunawa",
		"type": "attack",
		"cost": 3,
		"image_path": "res://cards/assets/kagat_ng_bakunawa.png",
		"property": "physical",
		"effects": [
			["bleed", 7]
		],
		"exhaust": false
	},

	"kagat_ng_aswang": {
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
	},

	# ------------------------
	# MAGIC ATTACK CARDS
	# ------------------------
	"gaway": {
		"card_name": "Gaway",
		"type": "attack",
		"cost": 1,
		"image_path": "res://cards/assets/gaway.png",
		"property": "magic",
		"effects": [
			["damage", 5]
		],
		"exhaust": false
	},


	"kulog_ng_kidlat": {
		"card_name": "Kulog ng Kidlat",
		"type": "attack",
		"cost": 2,
		"image_path": "res://cards/assets/kulog_ng_kidlat.png",
		"property": "magic",
		"effects": [
			["damage", 8]
		],
		"exhaust": false
	},




	# ------------------------
	# BUFF SPELL CARDS
	# ------------------------
	"hilot": {
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
	},

	"tagiyamo": {
		"card_name": "Tagiyamo",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/tagiyamo.png",
		"property": "buff",
		"effects": [
			["cleanse"]
		],
		"exhaust": false
	},




	# ------------------------
	# DEBUFF SPELL CARDS
	# ------------------------
	"hikap": {
		"card_name": "Hikap",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/hikap.png",
		"property": "debuff",
		"effects": [
			["block",5],
			["draw", 1]
		],
		"exhaust": false
	},
	
	"kalasag": {
		"card_name": "Kalasag",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/kalasag.png",
		"property": "debuff",
		"effects": [
			["block",5],
		],
		"exhaust": false
	},

	"basbas_ng_mangkukulam": {
		"card_name": "Basbas ng Mangkukulam",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/basbas_ng_mangkukulam.png",
		"property": "debuff",
		"effects": [
			["apply_damage_taken_mult", 0.20],
			["draw", 1]
		],
		"exhaust": false
	},

	"tingin_ni_mayari": {
		"card_name": "Paglalano ni Mayari",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/tingin_ni_mayari.png",
		"property": "debuff",
		"effects": [
			["enemy_miss_chance", 0.50]
		],
		"exhaust": false
	},

	"iyak_ng_tiyanak": {
		"card_name": "Iyak ng Tiyanak",
		"type": "spell",
		"cost": 3,
		"image_path": "res://cards/assets/iyak_ng_tiyanak.png",
		"property": "debuff",
		"effects": [
			["remove_enemy_armor"]
		],
		"exhaust": false
	},

	"pitik_ng_barang": {
		"card_name": "Pitik ng Barang",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/pitik_ng_barang.png",
		"property": "debuff",
		"effects": [
			["confuse", 0.50]
		],
		"exhaust": false
	}
}





# Returns a clean COPY of card data (NOT a reference)
func get_card(id: String) -> Dictionary:
	if CARDS.has(id):
		return CARDS[id].duplicate(true)
	else:
		push_warning("Card ID not found: %s" % id)
		return CARDS["default"].duplicate(true)
		
