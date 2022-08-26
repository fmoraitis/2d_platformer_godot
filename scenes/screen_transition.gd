extends CanvasLayer

signal change_scene_now

func change_scene():
	change_scene_now.emit()
