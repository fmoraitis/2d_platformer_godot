extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var base_levels= get_tree().get_nodes_in_group("base_level")
	# i just use this check in order to be able to run the
	# scene by itself to check eg the possition of the label
	# against a gray background without a baselevel node to
	# be present
	if base_levels.size()>0:
		base_levels[0].connect("total_coin_changed", self, "on_total_coin_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func on_total_coin_changed(total_coins,collected_coins):
	$MarginContainer/HBoxContainer/Label.text = str(collected_coins,"/",total_coins)
