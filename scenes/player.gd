extends KinematicBody2D
class_name Player

signal died 


enum State {NORMAL,DASHING}
var curent_state = State.NORMAL
#preload my custom recource
export (Resource) var Move_Player_Profile = preload ("res://scenes/PlayerMovementProfile_Default.tres")

var max_dashing_speed =  Move_Player_Profile.max_dashing_speed
var velocity_dashing = Vector2.ZERO 
var just_entered_state = false
var can_dash_again = true

var gravity =  Move_Player_Profile.gravity
var velocity = Vector2.ZERO 
var max_horizontal_speed = Move_Player_Profile.max_horizontal_speed
var horizontal_acceleration = Move_Player_Profile.horizontal_acceleration
var jump_speed = Move_Player_Profile.jump_speed
var jump_terminal_multiplier = 3
var has_double_jump = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	match curent_state:
		State.NORMAL:
			if just_entered_state:
				#do something
				just_entered_state = false
			_physics_process_normal(delta)
		State.DASHING:
			if just_entered_state:
				set_up_dashing_state()
				just_entered_state = false
		
			# i finish the state only when dashing is finished
			if velocity_dashing.x > 100 || velocity_dashing.x < -100:
				_physics_process_dashing(delta)
			else:
				#print("normal")
				curent_state = State.NORMAL
				just_entered_state = true
				can_dash_again = false # dashing is disabled until is landed again

func set_up_dashing_state():
	#set up dashing vrlocity
	#print("just entered dashing")
	var direction_to_dash = 0
	if $AnimatedSprite.flip_h:
		direction_to_dash = 1
	else:
		direction_to_dash = -1
		
	velocity_dashing= Vector2(direction_to_dash * max_dashing_speed,0)
	
	
		
		
func _physics_process_dashing(delta):
	
	velocity_dashing.x= lerp(0,velocity_dashing.x,pow(2,-5*delta)) 
	#print("lerp velocity ", velocity_dashing.x)
	velocity_dashing= move_and_slide(velocity_dashing,Vector2.UP)
	
func _physics_process_normal(delta):
		
	var move_vector= getMovementVector()
	# accelarating horizontal
	velocity.x +=  move_vector.x* horizontal_acceleration * delta
	# decelarating to zero
	if move_vector.x == 0:
		velocity.x= lerp(0,velocity.x,pow(2,-40*delta)) 
	
	velocity.x = clamp (velocity.x, -max_horizontal_speed,max_horizontal_speed)
	
	
	if move_vector.y <0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || has_double_jump):
		velocity.y = move_vector.y * jump_speed
		if (!is_on_floor() && $CoyoteTimer.is_stopped()) : # if both wer true means we used our double jump
			has_double_jump = false
		$CoyoteTimer.stop()	
	# accelarating vertical
	if velocity.y < 0 && !Input.is_action_pressed("jump"):# variable height 
		velocity.y +=  gravity * jump_terminal_multiplier * delta 
	else:		
		velocity.y +=  gravity * delta 
	
	
	var was_on_floor = is_on_floor()
	
	################### BEFORE THE MOVE IS APPLIED ###########################
	velocity = move_and_slide(velocity,Vector2.UP)
	################### AFTER THE MOVE IS APPLIED ###########################
	if (was_on_floor && !is_on_floor()):
		$CoyoteTimer.start()
	if (is_on_floor()): 
		has_double_jump = true
		can_dash_again = true # make as much dashind when is in the ground but only one dashing when in air
	
	# animated sprite stuff
	if (!is_on_floor()): 
		$AnimatedSprite.play("jump")
	elif  (move_vector.x!=0):

		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		
	if  (move_vector.x!=0):
		if (move_vector.x > 0):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	
	if Input.is_action_just_pressed("dash") && can_dash_again:
		curent_state = State.DASHING
		just_entered_state = true
		

func getMovementVector():
	var move_vector= Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.x = sign(move_vector.x)*1 # i do this n case we plug a game controler which will make the above values of move_vector.x not tobe whole 1 or -1 
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return  move_vector

	
func getVelocityVector() -> Vector2:
	return velocity


func _on_AreaValnurableToHazzards_area_entered(_area):
		#print("just died")
		emit_signal("died")



		



