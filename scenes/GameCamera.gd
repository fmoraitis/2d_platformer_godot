extends Camera2D
var target_position = Vector2.ZERO
export (Color, RGB) var background_color

func _ready():
	VisualServer.set_default_clear_color(background_color)

func _physics_process(delta):
	aquireTargetPosition()
	global_position= lerp(target_position,global_position,pow(2,-35*delta)) 
 
func aquireTargetPosition():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		target_position= player.global_position
