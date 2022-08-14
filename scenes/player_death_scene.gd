extends CharacterBody2D
#
var gravity = 900
func _physics_process(delta):
	apply_gravity(delta,1)
	move_and_slide()
#	print(velocity.y )
	if is_on_floor():
		velocity.x= lerpf(0,velocity.x,pow(2,-10*delta)) 
	
func apply_gravity(delta:float, gravity_multiplier:float):
	velocity.y +=  gravity * gravity_multiplier * delta 

