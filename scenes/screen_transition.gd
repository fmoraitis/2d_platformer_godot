#####IMPORTANT###################
### In the ScreenTransition which is of CanvasLayer 
### i set the layer property of the node to 10 (eg a nuber large 
####  that ensusres that is renderd above other CanvasLayers)
extends CanvasLayer

signal change_scene_now

func change_scene():
	change_scene_now.emit()
