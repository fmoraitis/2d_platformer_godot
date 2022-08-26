extends CanvasLayer

# i manually conect the button just to remember the syntax
@onready var quit = $PanelContainer/MarginContainer/VBoxContainer/quit


# Called when the node enters the scene tree for the first time.
func _ready():
	quit.pressed.connect(_on_quit_pressed)

func _on_try_again_pressed():
	# LevelManager is a singleton
	LevelManager.reload_level()


func _on_quit_pressed():
	LevelManager.quit_game()
