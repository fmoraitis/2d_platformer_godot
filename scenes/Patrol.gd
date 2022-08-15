extends ActionLeaf


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	dashing_particles.emitting = true
	pass

func tick(actor, blackboard):
	actor.get_node("AnimatedSprite").play("run")
	actor.patroling(blackboard.get("delta"))
	blackboard.get("dashing_particles").emitting = false
	return SUCCESS
