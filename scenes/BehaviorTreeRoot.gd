extends BehaviorTreeRoot

func _physics_process(delta):
	if not enabled:
		return

	blackboard.set("delta", delta)


	self.get_child(0).tick(get_parent(), blackboard)

