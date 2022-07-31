extends Node

export (PackedScene) var level_scene_1 = preload ("res://scenes/Level_01.tscn")
export (PackedScene) var level_scene_2 = preload( "res://scenes/Level_02.tscn")
#level_scenes[0]= preload ("res://scenes/Level_01.tscn")
#level_scenes[1]= preload( "res://scenes/Level_02.tscn")
var current_level_index = 0
var level_scenes = [level_scene_1, level_scene_2]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	level_scenes[0] = level_scene_1
#	level_scenes[1] = level_scene_2
	change_level(current_level_index)


func change_level (level_index):
	current_level_index = level_index
	if current_level_index >= level_scenes.size():
		current_level_index = 0
	get_tree().change_scene(level_scenes[current_level_index].resource_path)

func next_level():
	change_level (current_level_index +1)
