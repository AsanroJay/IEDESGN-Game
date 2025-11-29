extends Control

@onready var count = $ManaCount

var current_mana := 0
var max_mana := 0

func set_mana(current: int, maxv: int) -> void:
	current_mana = current
	max_mana = maxv
	count.text = "%d / %d" % [current_mana, max_mana]
