extends Node
class_name EnemyAttacks

var ATTACKS := {
	"default_attack": {
		"name": "Strike",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 6],
			
		]
	},
	
	"aswang_attack": {
		"name": "Aswang Strike",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 6],
			
		]
	},
	
	"aswang_lifesteal": {
		"name": "Aswang Bite",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 5],
			["lifesteal_unblocked"]
			
		]
	},
	
	"aswang_block": {
		"name": "Aswang Block",
		"type": "buff",
		"property": "physical",
		"effects": [
			["block",5]
		]
	},

	"kapre_club": {
		"name": "Kapre Club Smash",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 8]
		]
	},

	"kapre_block": {
		"name": "Fist Guard",
		"type": "defend",
		"effects": [
			["block", 5]
		]
	},
	
	
	"kapre_heavy_block": {
		"name": "Tree Bark Guard",
		"type": "defend",
		"effects": [
			["block", 12]
		]
	},

	"sigbin_charge": {
		"name": "Sigbin Charge",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 6],
			["pierce_armor"]
		]
	},
	
	"sigbin_scratch": {
		"name": "Sigbin scratch",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 7]
		]
	},

	"manananggal_bite": {
		"name": "Bloody Bite",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 4],
			["bleed", 2]
		]
	},
	
	
	"rupture": {
		"name": "Rupture",
		"type": "spell",
		"property": "physical",
		"effects": [
			["bleed", 4]
		]
	},

	"white_lady_attack": {
		"name": "Shriek",
		"type": "attack",
		"property": "magic",
		"effects": [
			["damage", 8], 
		
		]
	},
	
	"white_lady_curse": {
		"name": "Haunt",
		"type": "spell",
		"property": "magic",
		"effects": [
			["apply_damage_taken_mult", 0.20],  # take +20 percent dmg
		]
	},
	
	"white_lady_heal": {
		"name": "Healing Magic",
		"type": "spell",
		"property": "magic",
		"effects": [
			["heal", 4]
		]
	},

	"mangkukulam_hex": {
		"name": "Hex of Agony",
		"type": "spell",
		"property": "magic",
		"effects": [
			["damage", 5],
			["bleed", 1],
			["apply_damage_taken_mult", 0.20],
			["confuse",0.5]
		]
	},
	
	"mangkukulam_bleed": {
		"name": "Tears of Blood",
		"type": "spell",
		"property": "magic",
		"effects": [
			["bleed", 4]
		]
	},
	
	"mangkukulam_attack": {
		"name": "Scratches",
		"type": "attack",
		"property": "physical",
		"effects": [
			["damage", 4]
		]
	},
	
	"mangkukulam_gaze": {
		"name": "Gayuma ng Mangkukulam",
		"type": "spell",
		"property": "debuff",
		"effects": [
			["confuse",0.5]
		]
	},
	
	"mangkukulam_heal": {
		"name": "Gayuma ng Pagpapagaling",
		"type": "spell",
		"property": "buff",
		"effects": [
			["heal", 8]
		]
	},
	
	"mangkukulam_minor_heal": {
		"name": "Maliit na Gayuma ng Pagpapagaling",
		"type": "spell",
		"property": "buff",
		"effects": [
			["heal", 3]
		]
	},
}
