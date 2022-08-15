extends ActionLeaf

var player_body = null
var body_exited = true
var player_death = false 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func tick(actor, blackboard):
	if (player_body!=null) && !body_exited:			
		if player_death:
			player_death = false 
			return SUCCESS		
		actor.move_towards_target(player_body)	
		actor.get_node("AnimatedSprite").play("chase")
		blackboard.get("dashing_particles").emitting = true
		#print("still chasing")
		return RUNNING
	return FAILURE



func _on_chase_area_body_exited(body):
	body_exited = true
	player_body = null


func _on_chase_area_body_entered(body):
	player_body =  body
	body_exited = false
#	#print("body emtered ",player_body.name)


func _on_deadly_area_area_entered(area):
	player_death = true
