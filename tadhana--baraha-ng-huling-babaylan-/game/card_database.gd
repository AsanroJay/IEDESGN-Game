extends Node

const CARDS = {
	"default": {
		"card_name": "Default",
		"type": "attack",
		"cost": 1,
		"image_path": "res://cards/assets/default_card.png",
		"property": "physical",
		"effects": [
			["damage", 6]
		],
		"exhaust": false
	},

	"defend": {
		"card_name": "Defend",
		"type": "defend",
		"cost": 1,
		"image_path": "res://cards/assets/defend.png",
		"property": "defense",
		"effects": [
			["block", 5]
		],
		"exhaust": false
	},

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

	"kulam": {
		"card_name": "Kulam",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/kulam.png",
		"property": "magic",
		"effects": [
			["flip_resistance"]
		],
		"exhaust": true
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

	"baha_ni_magwayen": {
		"card_name": "Baha ni Magwayen",
		"type": "spell",
		"cost": 3,
		"image_path": "res://cards/assets/baha.png",
		"property": "magic",
		"effects": [
			["flood", 2, 3],
			["force_physical_next_turn"]
		],
		"exhaust": false
	},

	"apoy_ni_agui": {
		"card_name": "Apoy ni Agui",
		"type": "spell",
		"cost": 3,
		"image_path": "res://cards/assets/apoy.png",
		"property": "magic",
		"effects": [
			["burn", 2, 3],
			["ignore_armor_next_attack"]
		],
		"exhaust": false
	},

	"lindol_ni_panlinugon": {
		"card_name": "Lindol ni Panlinugon",
		"type": "attack",
		"cost": 3,
		"image_path": "res://cards/assets/lindol.png",
		"property": "magic",
		"effects": [
			["damage", 6],
			["enemy_stun_next_turn"]
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

	"pagpag": {
		"card_name": "Pagpag",
		"type": "spell",
		"cost": 1,
		"image_path": "res://cards/assets/pagpag.png",
		"property": "buff",
		"effects": [
			["return_exhausted"]
		],
		"exhaust": true
	},

	"tulong_ng_duwende": {
		"card_name": "Tulong ng Duwende",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/tulong.png",
		"property": "buff",
		"effects": [
			["fetch_card_cost0"]
		],
		"exhaust": false
	},

	"dasal_para_kay_anagolay": {
		"card_name": "Dasal para kay Anagolay",
		"type": "spell",
		"cost": 3,
		"image_path": "res://cards/assets/dasal.png",
		"property": "buff",
		"effects": [
			["add_random_cards_cost0", 2]
		],
		"exhaust": false
	},

	"ginhawa_ng_anino": {
		"card_name": "Ginhawa ng Anino",
		"type": "spell",
		"cost": 3,
		"image_path": "res://cards/assets/ginhawa.png",
		"property": "buff",
		"effects": [
			["set_hand_cost_zero"]
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
			["block_attack"],
			["draw", 1]
		],
		"exhaust": false
	},

	"basbas_ng_mangkukulam": {
		"card_name": "Basbas ng Mangkukulam",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/basbas.png",
		"property": "debuff",
		"effects": [
			["increase_enemy_damage_taken", 1.20],
			["draw", 1]
		],
		"exhaust": false
	},

	"paglalano_ni_mayari": {
		"card_name": "Paglalano ni Mayari",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/paglalano.png",
		"property": "debuff",
		"effects": [
			["enemy_miss_chance", 0.50]
		],
		"exhaust": false
	},

	"kulam_ng_ugat": {
		"card_name": "Kulam ng Ugat",
		"type": "spell",
		"cost": 2,
		"image_path": "res://cards/assets/kulam_ng_ugat.png",
		"property": "debuff",
		"effects": [
			["poison", 4, 3]
		],
		"exhaust": false
	},

	"iyak_ng_tiyanak": {
		"card_name": "Iyak ng Tiyanak",
		"type": "spell",
		"cost": 3,
		"image_path": "res://cards/assets/iyak.png",
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
		"image_path": "res://cards/assets/pitik.png",
		"property": "debuff",
		"effects": [
			["confuse", 0.50]
		],
		"exhaust": false
	}
}
