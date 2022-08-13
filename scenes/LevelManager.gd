extends Node


@export var levels : Array[PackedScene]

@onready var current_level_index :int = 0

#func _ready() -> void:
##	level_scenes[0] = level_scene_1
##	level_scenes[1] = level_scene_2
#	change_level(current_level_index)


func change_level (level_index):
	current_level_index = level_index
	if current_level_index >= levels.size():
		current_level_index = 0
	get_tree().change_scene(levels[current_level_index].resource_path)

func next_level():
	change_level (current_level_index +1)

func reload_level():
	change_level (current_level_index)
