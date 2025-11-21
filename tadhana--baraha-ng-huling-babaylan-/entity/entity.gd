extends Node
class_name Entity

var entity_name: String = "Entity"
var deck = []
var hp: int = 0
var mana: int = 0
var block: int = 0

var statuses := {}

func apply_damage(amount: int) -> void:
	var damage = max(0,amount-block)
	block = max(0,block - amount)
	hp = max(0,hp-damage)
	print(name, "takes", damage, "damage → HP:", hp, " Block:", block)


func gain_block(amount: int) -> void:
	block += amount
	print(name, "gains", amount, "block → Block:", block)
	
	
func apply_status(status_name: String, stacks: int) -> void:
	statuses[status_name] = statuses.get(status_name, 0) + stacks
	print(name, "gains", stacks, status_name, "(total:", statuses[status_name], ")")


func has_status(status_name: String) -> bool:
	return statuses.has(status_name)


func remove_status(status_name: String) -> void:
	statuses.erase(status_name)


func is_dead() -> bool:
	return hp <= 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
