extends Camera2D
var target_position = Vector2.ZERO
@export var shake_noise :Noise
var x_noise_sample_vector = Vector2.RIGHT
var y_noise_sample_vector = Vector2.DOWN 
var x_noise_sample_possition = Vector2.ZERO
var y_noise_sample_possition = Vector2.ZERO
const NOISE_SAMPLE_TRAVEL_SPEED := 500
const MAX_SHAKE_OFFSET := 3 # -3 TO 3 PIXELS the noise function gices us range -1 .. 1
var current_shake_percentage : float = 0.0
var tween :Tween # for shake decay

#func _ready():
#	pass
##	self.VisualServer.set_default_clear_color(background_color)
#	# offeset the camera to look nicer
##	offset.y = 0

func _physics_process(delta):	
	aquireTargetPosition()
	lerp_to_target_position(delta)	
	
		
func lerp_to_target_position(delta):	
	global_position=global_position.lerp(target_position,pow(2,-35*delta) )	
#
func aquireTargetPosition():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		target_position= player.global_position

func apply_shake(percentage,delta):
	
#	current_shake_percentage = clampf(current_shake_percentage + percentage,0.0,1.0)
	current_shake_percentage = percentage #percentage is the variable that is being tweened 
#	print(current_shake_percentage)
#	print(percentage)
	if current_shake_percentage > 0 :
		x_noise_sample_possition += x_noise_sample_vector * NOISE_SAMPLE_TRAVEL_SPEED *delta
		y_noise_sample_possition += y_noise_sample_vector * NOISE_SAMPLE_TRAVEL_SPEED *delta
		var x_sample_noise = shake_noise.get_noise_2d(x_noise_sample_possition.x,x_noise_sample_possition.y)
		var y_sample_noise = shake_noise.get_noise_2d(y_noise_sample_possition.x,y_noise_sample_possition.y)
		offset = Vector2(x_sample_noise,y_sample_noise)*MAX_SHAKE_OFFSET * current_shake_percentage # current_shake_percentage goes from 1 to zero with the tween

func shake_the_camera(percentage,delta,seconds:float):
		tween = create_tween()
		tween.tween_method(apply_shake.bind(delta),percentage,0.0,seconds) # decay shake when jumping in 0.5 secs
