extends Node


var Player_Scene = preload ("res://scenes/player.tscn")
var spawned_pos = Vector2.ZERO
var player_node = null

func _ready():
	create_player()
#	spawned_pos = $player.global_position
#	register_player($player) 

func register_player(player) :
	player_node = player
	player_node.connect("died",self,"on_player_died")

	

func create_player():
	var player_instance = Player_Scene.instance()
	player_instance.global_position = spawned_pos
	
	call_deferred("add_child_below_node",$"%Hazards",player_instance)
	
	register_player(player_instance)
	
	
func on_player_died():
#	player_node.queue_free()
	get_tree().reload_current_scene()
	create_player()
	
func on_player_died_by_enemy():
	print("received died from enemy")
	get_tree().reload_current_scene()
#	player_node.queue_free()
	create_player()
	
