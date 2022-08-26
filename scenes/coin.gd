extends Node2D

class_name Coin


func _on_Area2D_area_entered(_area):
	$AnimationPlayer.play("picked")
#	$AnimationPlayer.play("free_coin")
	var base_level= get_tree().get_nodes_in_group("base_level")[0]
	base_level.coins_collected()
	queue_free()
#	call_deferred("queue_free")
	#area.get_parent().scale *= 1.1 
	#print("picked")
	#queue_free()
