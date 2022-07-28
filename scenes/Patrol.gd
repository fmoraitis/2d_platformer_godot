extends ActionLeaf


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func tick(actor, blackboard):
	actor.get_node("AnimatedSprite").play("run")
	actor.patroling(blackboard.get("delta"))
	return SUCCESS
