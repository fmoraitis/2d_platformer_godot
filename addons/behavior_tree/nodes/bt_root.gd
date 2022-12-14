extends BehaviorTree

class_name BehaviorTreeRoot#, "../icons/tree.svg"
@icon("../icons/tree.svg")
const Blackboard = preload("../blackboard.gd")

@export var enabled := true

@onready var blackboard = Blackboard.new()
@onready var dashing_particles = $"../DashingParticles"

func _ready():
	if self.get_child_count() != 1:
		print("Behavior Tree error: Root should have one child")
		disable()
		return

func _physics_process(delta):
	if not enabled:
		return

	blackboard.set("delta", delta)
	blackboard.set("dashing_particles", dashing_particles)
	
	self.get_child(0).tick(get_parent(), blackboard)


func enable():
	self.enabled = true


func disable():
	self.enabled = false
