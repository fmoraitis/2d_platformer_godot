extends Button

var grow_tween :Tween
var shrink_tween :Tween
var rect_size  = size.x
# Called when the node enters the scene tree for the first time.
func _ready():
	pivot_offset = size/2
	print(pivot_offset)
#	rect_size = size.x
	#shrink_tween = create_tween()
#"custom_minimum_size"
#"pivot_offset"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_my_button_mouse_entered():
	grow_tween  = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	grow_tween.tween_property($".","size",Vector2(100,size.y),0.1)
	grow_tween.parallel().tween_property($".","custom_minimum_size",Vector2(100,size.y),0.1)
	


func _on_my_button_mouse_exited():
	grow_tween.stop() 
	shrink_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	shrink_tween.tween_property($".","size",Vector2(rect_size,size.y),0.1)
	shrink_tween.parallel().tween_property($".","custom_minimum_size",Vector2(rect_size,size.y),0.1)
