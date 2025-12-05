extends Node2D

func _on_button_pressed() -> void:
	print("Start game clicked")
	self.visible = false  
	GameManager.start_game()
