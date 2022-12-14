extends CharacterBody2D
class_name Player

signal died 
signal a_dashing_kill

enum State {NORMAL,DASHING}
enum ENEMY_IS {ON_GROUND,FLYING,A_SPIKE}

var curent_state = State.NORMAL
var just_entered_state = false

var FootSteps_Scene = preload("res://scenes/foot_steps.tscn")

#preload my custom recource
@export  var Move_Player_Profile : Resource 
@onready var max_dashing_speed =  Move_Player_Profile.max_dashing_speed
@onready var gravity  =  Move_Player_Profile.gravity
@onready var max_horizontal_speed = Move_Player_Profile.max_horizontal_speed
@onready var horizontal_acceleration  = Move_Player_Profile.horizontal_acceleration
@onready var jump_speed  = Move_Player_Profile.jump_speed
var global_delta :float
var velocity_dashing = Vector2.ZERO 
var jump_terminal_multiplier = 3
var has_double_jump = false
var can_dash_again = true
var game_camera :Node

# this is used to ensure that player will
# not emmit the die signal two times eg if it falls
# in the middle of two spikes meaning in their overlaping
# hazards areas
var player_already_died = false

# Called when the node enters the scene tree for the first time.
func _ready():
	################# GRAB THE CAMERA FROM THE SCENE TREE ######################
	var cameras = get_tree().get_nodes_in_group("cameras")
	if cameras.size() > 0:
		game_camera = cameras[0]
	
	
	
func _physics_process(delta):
	global_delta = delta
	match curent_state:
		State.NORMAL:
			if just_entered_state:
				#setup something
				$DashingParticles.emitting = false
				just_entered_state = false
			_physics_process_normal(delta)
		State.DASHING:
			if just_entered_state:
				set_up_dashing_state(delta)
				just_entered_state = false	
			_physics_process_dashing(delta)
			

func set_up_dashing_state(delta):
	$DashingParticles.emitting = true
	if $AnimatedSprite.flip_h:
		var direction_to_dash = 1
		velocity_dashing= Vector2(direction_to_dash * max_dashing_speed,0)
	else:
		var direction_to_dash = -1
		velocity_dashing= Vector2(direction_to_dash * max_dashing_speed,0)
	game_camera.shake_the_camera(1.0,delta,0.5)
			
func _physics_process_dashing(delta):
	########## CHECK FOR STATE CHANGE ######################################
	# i finish the state only when dashing is finished which satisfies the condition bellow
	# which is that the dashing speed is too low or it has dashed on a wall
	if (velocity_dashing.x > 100 || velocity_dashing.x < -100) && !is_on_wall(): #keep dashing
		velocity_dashing.x= lerpf(0,velocity_dashing.x,pow(2,-5*delta)) 
		velocity = Vector2(velocity_dashing.x,0.0)
		move_and_slide()
	else:# return to normal state
		#print("normal")
		curent_state = State.NORMAL
		just_entered_state = true
		can_dash_again = false # dashing is disabled until is landed again
	
func _physics_process_normal(delta):
	
	####### GET THE INPUT ##################################################	
	var move_vector= getMovementVector()
	
	########## CHECK FOR STATE CHANGE ######################################
	if Input.is_action_just_pressed("dash") && can_dash_again:
		curent_state = State.DASHING
		just_entered_state = true
	
	######### APPLY HORIZONTAL MOVEMENT ######################################
	velocity.x = clamp (velocity.x, -max_horizontal_speed,max_horizontal_speed)
	# accelarating horizontal
	velocity.x +=  move_vector.x * horizontal_acceleration * delta
#	print(velocity.x)
	# decelarating to zero
	if move_vector.x == 0:
		velocity.x= lerpf(0,velocity.x,pow(2,-30*delta)) 
	#########################################################################
	
	######### APPLY VERTICAL MOVEMENT ######################################
	if move_vector.y <0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || has_double_jump):
		velocity.y = move_vector.y * jump_speed # APPLY JUMP **************************	
#		game_camera.shake_the_camera(1.0,delta,0.5)
		if (!is_on_floor() && $CoyoteTimer.is_stopped()) : # if both wer true means we used our double jump
			game_camera.shake_the_camera(0.75,delta,0.5)
			has_double_jump = false
		$CoyoteTimer.stop()	
	# de-accelarating vertical
	if velocity.y < 0 && !Input.is_action_pressed("jump"):# variable height AND APPLY GRAVITY ***************
		apply_gravity(delta, jump_terminal_multiplier) # enhanced gravity	
	else:		
		apply_gravity(delta, 1) # normal gravity
		
	#########################################################################
	
	################### BEFORE THE MOVE IS APPLIED ###########################
	var was_on_floor = is_on_floor()
	###################  MOVE APPLIED #######################################
	move_and_slide()
	################### AFTER THE MOVE IS APPLIED ###########################
	if (!was_on_floor && is_on_floor()):
		var foot_steps = FootSteps_Scene.instantiate()
		foot_steps.global_position = global_position 
		foot_steps.get_node("FootStepsParticles").amount=5
#		foot_steps.get_node("FootStepsParticles").process_material.set("emission_sphere_radius", 20)
		get_parent().add_child(foot_steps)
	
	if (was_on_floor && !is_on_floor()):
		$CoyoteTimer.start()
	if (is_on_floor()): 
		has_double_jump = true
		can_dash_again = true # make as much dashind when is in the ground but only one dashing when in air
	#############################################################################
	
	# animated sprite stuff
	if  (move_vector.x!=0):
		if (move_vector.x > 0):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	if (!is_on_floor()): 
		$AnimatedSprite.play("jump")
			
	elif  (move_vector.x!=0):
		$AnimatedSprite.play("run")
		var foot_steps = FootSteps_Scene.instantiate()
		foot_steps.global_position = global_position 
		foot_steps.get_node("FootStepsParticles").amount=1
#		foot_steps.get_node("FootStepsParticles").process_material.set("emission_sphere_radius", 10)
		get_parent().add_child(foot_steps)
	else:
		$AnimatedSprite.play("idle")	
		

func getMovementVector():
	var move_vector= Vector2.ZERO
#	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.x = Input.get_axis("move_left","move_right")
	move_vector.x = sign(move_vector.x)*1 # i do this n case we plug a game controler which will make the above values of move_vector.x not tobe whole 1 or -1 
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0	
	return  move_vector

func apply_gravity(delta:float, gravity_multiplier:float):
	velocity.y +=  gravity * gravity_multiplier * delta 

func _on_AreaValnurableToHazzards_area_entered(_area):
	if  player_already_died:
		return
	if curent_state == State.DASHING &&  _area.get_parent() is Enemy:
		# i emit the dashing direection
		a_dashing_kill.emit(sign(velocity.x)*1, _area.get_parent()) 
#		_area.get_parent().queue_free()
		return	
	player_already_died=true
	game_camera.shake_the_camera(1.5,global_delta,0.5)
		#print(_area.get_parent().direction.x)
	if _area.get_parent() is Enemy:
		died.emit(_area.get_parent().direction.x,ENEMY_IS.ON_GROUND)
#		print("enemy")
	elif _area.get_parent() is Flying_Enemy:
		died.emit(0,ENEMY_IS.FLYING)
#		print("flying enemy")
	elif _area.get_parent() is Spike:
		died.emit(0,ENEMY_IS.A_SPIKE)
#		print("spike")
	return
#	_area.get_parent().get_node("chase_area").monitoring=false
#	_area.get_parent().get_node("deadly_area").monitoring=false
#	_area.get_parent().turn_around()
#	_area.get_parent().move_and_slide()
	
#		$CollisionShape2D.disabled = true 
#		$AreaValnurableToHazzards/CollisionShape2D.disable_mode = true 
#		$AreaValnurableToHazzards.monitorable= false
#		$CollisionShape2D.set_deferred("disabled",true)
#		$AreaValnurableToHazzards.set_deferred("monitorable",false)
#		$AreaValnurableToHazzards.set_deferred("disabled",true)
#		set_deferred("disable_mode",DISABLE_MODE_REMOVE)
#		set_deferred("set_collision_layer",12)
#		$AreaValnurableToHazzards.set_deferred("set_collision_layer",12)
#		$AreaValnurableToHazzards.set_deferred("disable_mode",DISABLE_MODE_REMOVE)
#	$AnimationPlayer.play("death")
	
		



		





func _on_animated_sprite_frame_changed():
	pass # Replace with function body.
#	if ($AnimatedSprite.animation == "run" && $AnimatedSprite.frame == 0):
#		var foot_steps = FootSteps_Scene.instantiate()
#		foot_steps.global_position = global_position 
#		get_parent().add_child(foot_steps)
		
