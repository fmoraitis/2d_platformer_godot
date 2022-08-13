extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_button_pressed():
	# LevelManager is a singleton
	LevelManager.reload_level()


func _on_quit_pressed():
	get_tree().quit()
