extends CanvasLayer


func _on_button_pressed():
	# LevelManager is a singleton
	LevelManager.next_level()
#	$"/root/LevelManager".next_level()
