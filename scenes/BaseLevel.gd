extends Node

class_name BaseLevel

signal total_coin_changed

var Player_Scene = preload ("res://scenes/player.tscn")
var Player_Death_Scene= preload ("res://scenes/player_death_scene.tscn")
@export var level_complete_screen : PackedScene
@export var level_game_over_screen : PackedScene
var spawned_pos = Vector2.ZERO
var player_instance :Node
var player_death_scene_node :Node
var total_coins:int = 0
var collected_coins :int = 0

func _ready():
	$flag.won_level.connect(on_won_level)
	create_player()
	collected_coins = 0
#	spawned_pos = $player.global_position
#	register_player($player) 
	coin_total_changed(get_tree().get_nodes_in_group("coins").size())
	#print("total coins", total_coins)


func coins_collected() -> void:
	collected_coins += 1	
	total_coin_changed.emit(total_coins,collected_coins)
#	emit_signal("total_coin_changed",total_coins,collected_coins)
#	print(total_coins, " ",collected_coins)
	
func coin_total_changed(new_total: int):
	total_coins = new_total
	total_coin_changed.emit(total_coins,collected_coins)
#	emit_signal("total_coin_changed",total_coins,collected_coins)



func create_player():
	player_instance = Player_Scene.instantiate()
	player_instance.global_position = spawned_pos
	player_instance.died.connect(on_player_died)
	$PlayerRoot.add_child(player_instance)
#	add_child(player_instance)
#	call_deferred("add_child",player_instance)

	
	
func on_player_died(enemy_direction):
	player_death_scene_init(enemy_direction)
	player_instance.queue_free()
	await get_tree().create_timer(2.5).timeout
	add_child(level_game_over_screen.instantiate())

func player_death_scene_init(enemy_type_or_direction:int):
	# 2 is a flying enemy, 0 is a spike , -1 or 1 is a regular enemy
	player_death_scene_node =  Player_Death_Scene.instantiate()
	player_death_scene_node.global_position = player_instance.global_position
	player_death_scene_node.get_node("Visuals/AnimatedSprite").flip_h = player_instance.get_node("AnimatedSprite").flip_h
	if enemy_type_or_direction == 0:
		player_death_scene_node.velocity.x = 0
		player_death_scene_node.velocity.y = -100
	if enemy_type_or_direction == 2:
		player_death_scene_node.velocity = -1 * player_instance.velocity	
	if enemy_type_or_direction == 1 || enemy_type_or_direction== -1 :
		player_death_scene_node.velocity.x = -1*  player_instance.velocity.x
		player_death_scene_node.velocity.y = -100	
		# with this  i ensure that the death animation complies with the direction of the enemy
		player_death_scene_node.get_node("Visuals").scale.x =  enemy_type_or_direction
#	player_death_instance.get_node("CollisionShape2D").disabled=true
	call_deferred("add_child",player_death_scene_node)

func on_won_level():
#	print("won")
	add_child(level_complete_screen.instantiate())
	player_instance.queue_free()
#
