extends Node

class_name BaseLevel

signal total_coin_changed
enum ENEMY_IS {ON_GROUND,FLYING,A_SPIKE}

var Player_Scene = preload ("res://scenes/player.tscn")
var Player_Death_Scene= preload ("res://scenes/player_death_scene.tscn")
var Enemy_Death_Scene= preload ("res://scenes/enemy_death_scene.tscn")


@export var level_complete_screen : PackedScene
@export var level_game_over_screen : PackedScene
var spawned_pos = Vector2.ZERO
var player_instance :Node
var player_death_scene_node :Node
var enemy_death_scene_node :Node

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
	player_instance.a_dashing_kill.connect(on_players_dashing_kill)
	$PlayerRoot.add_child(player_instance)
#	add_child(player_instance)
#	call_deferred("add_child",player_instance)

func on_players_dashing_kill(dashing_direction:int, enemy:CharacterBody2D):
	# here i init the enemy death scene
	#and i free the enemy
	enemy_death_scene_create(dashing_direction, enemy)
	enemy.queue_free()
	
func enemy_death_scene_create(dashing_direction:int, enemy:CharacterBody2D):	
	enemy_death_scene_node =  Enemy_Death_Scene.instantiate()
	enemy_death_scene_node.global_position = enemy.global_position
	enemy_death_scene_node.get_node("Visuals/Sprite").flip_h = enemy.get_node("AnimatedSprite").flip_h
	enemy_death_scene_node.velocity.x = 1.5 * player_instance.velocity.x
	# with this  i ensure that the death animation complies with the direction of the  dasing speed
	enemy_death_scene_node.get_node("Visuals").scale.x =  dashing_direction
	call_deferred("add_child",enemy_death_scene_node)
	
	
func on_player_died(enemy_direction,type_of_enemy:ENEMY_IS):
	player_death_scene_create(enemy_direction,type_of_enemy)
	player_instance.queue_free()
	await get_tree().create_timer(2.5).timeout
	add_child(level_game_over_screen.instantiate())

func player_death_scene_create(enemy_type_or_direction:int, type_of_enemy:ENEMY_IS):
	
	player_death_scene_node =  Player_Death_Scene.instantiate()
	player_death_scene_node.global_position = player_instance.global_position
	player_death_scene_node.get_node("Visuals/AnimatedSprite").flip_h = player_instance.get_node("AnimatedSprite").flip_h
	
	match typeof( type_of_enemy):
		ENEMY_IS.A_SPIKE:
			player_death_scene_node.velocity.x = 0
			player_death_scene_node.velocity.y = -100
		ENEMY_IS.FLYING:
			player_death_scene_node.velocity = -1 * player_instance.velocity
		ENEMY_IS.ON_GROUND:
			player_death_scene_node.velocity.x = -1*  player_instance.velocity.x
			player_death_scene_node.velocity.y = -100	
		# with this  i ensure that the death animation complies with the direction of the enemy
			player_death_scene_node.get_node("Visuals").scale.x =  enemy_type_or_direction
	
	call_deferred("add_child",player_death_scene_node)
	
	
	
#	if type_of_enemy == ENEMY_IS.A_SPIKE:
#		player_death_scene_node.velocity.x = 0
#		player_death_scene_node.velocity.y = -100
#	if type_of_enemy == ENEMY_IS.FLYING:
#		player_death_scene_node.velocity = -1 * player_instance.velocity	
#	if  type_of_enemy == ENEMY_IS.ON_GROUND:
#		player_death_scene_node.velocity.x = -1*  player_instance.velocity.x
#		player_death_scene_node.velocity.y = -100	
#		# with this  i ensure that the death animation complies with the direction of the enemy
#		player_death_scene_node.get_node("Visuals").scale.x =  enemy_type_or_direction
##	player_death_instance.get_node("CollisionShape2D").disabled=true
#	call_deferred("add_child",player_death_scene_node)

func on_won_level():
#	print("won")
	add_child(level_complete_screen.instantiate())
	player_instance.queue_free()
#
