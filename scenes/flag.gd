extends Node

signal won_level

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Flag_Area_body_entered(body: Node) -> void:
	if body  is Player:
		print("body entred flag")
		won_level.emit()
