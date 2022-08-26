extends Button

var grow_tween :Tween
var shrink_tween :Tween
var rect_size  = size.x
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	pass
#	pivot_offset = size/2
#	print(pivot_offset)

# we need both size and custom_minimum_size in order for the button to shrink 
# or grow from its center, it a quirck of godot

func _on_my_button_mouse_entered():
	grow_tween  = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	grow_tween.tween_property($".","size",Vector2(100,size.y),0.1)
	grow_tween.parallel().tween_property($".","custom_minimum_size",Vector2(100,size.y),0.1)
	


func _on_my_button_mouse_exited():
	grow_tween.stop() 
	shrink_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	shrink_tween.tween_property($".","size",Vector2(rect_size,size.y),0.1)
	shrink_tween.parallel().tween_property($".","custom_minimum_size",Vector2(rect_size,size.y),0.1)
