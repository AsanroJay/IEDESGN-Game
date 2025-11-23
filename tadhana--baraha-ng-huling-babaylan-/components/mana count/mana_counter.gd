extends Control

@onready var count = $ManaCount

var default_mana 
var current_mana

func set_mana(mana) -> void:
	default_mana = mana
	current_mana = default_mana
	count.text = str(current_mana) + " / " + str(default_mana)
	
