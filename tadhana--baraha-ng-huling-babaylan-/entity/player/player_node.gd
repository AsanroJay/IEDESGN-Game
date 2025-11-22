extends Node2D
class_name PlayerNode

var entity
@onready var anim = $Sprite   

func set_entity(e):
	entity = e
	anim.play("idle")
