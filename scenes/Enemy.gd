extends CharacterBody2D
class_name Enemy


var direction = Vector2.RIGHT
var max_speed = 20
var gravity = 300
var init_direction = ["RIGHT", "LEFT"]


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO
	var item = randi() % init_direction.size()
	if init_direction[item] == "RIGHT":
		direction = Vector2.RIGHT
	elif init_direction[item] == "LEFT":
		turn_around()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_on_floor():
		apply_gravity(delta,2)

func apply_gravity(delta:float,gravity_mult:float):
	velocity.y += gravity * delta * gravity_mult
	
func turn_around():
	direction.x *=-1
	$CheckFall.position.x *=-1
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
#	$CheckIfcollideWithPlayer.position.x *=-1
#	$CheckIfcollideWithPlayer.rotate(PI)
	
func patroling(my_delta):
	if is_on_wall() || !get_node("CheckFall").is_colliding():
		turn_around()
	velocity.x= lerp( direction.x * max_speed,velocity.x,pow(2,-40* my_delta)) 	
	#actor.velocity.x = actor.direction.x * actor.max_speed
	move_and_slide()
func move_towards_target(body):
		var direction_towards_player = position.direction_to(body.position)
		# normalize coordinate x 
		var direction_towards_player_x = direction_towards_player.x/abs(direction_towards_player.x)	
		if (direction_towards_player_x != direction.x):
			turn_around()
		velocity.x =direction.x * max_speed *4
		move_and_slide()


func _on_VisibilityNotifier2D_screen_exited():
	if !is_on_floor():
		queue_free()
#		print(self.name," died")
