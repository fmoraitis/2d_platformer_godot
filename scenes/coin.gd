extends Node2D



func _on_Area2D_area_entered(_area):
	$AnimationPlayer.play("picked")
	#area.get_parent().scale *= 1.1
	#print("picked")
	#queue_free()
