extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# i do that here in order to play each scene by its own
	# because before it always called the singlenton first as it suppose to do
	# and starts the game so i could not test each scene separetly
	LevelManager.change_level(LevelManager.current_level_index)



