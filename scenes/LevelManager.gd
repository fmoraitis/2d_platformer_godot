extends Node


@export var levels : Array[PackedScene]

@onready var current_level_index :int = 0
@onready var screen_transition_scene = preload("res://scenes/screen_transition.tscn")
#func _ready() -> void:
##	level_scenes[0] = level_scene_1
##	level_scenes[1] = level_scene_2
#	change_level(current_level_index)


func change_level (level_index):
	
	current_level_index = level_index
	if current_level_index >= levels.size():
		current_level_index = 0
	trransition_to_level(levels[current_level_index].resource_path)

func next_level():
	change_level (current_level_index +1)

func reload_level():
	change_level (current_level_index)

func quit_game():
	get_tree().quit()

func trransition_to_level(level: String):
	# here i insatiate the screen transition
	var screen_transition = screen_transition_scene.instantiate()
	add_child(screen_transition)
	await screen_transition.change_scene_now
	get_tree().change_scene(level)
