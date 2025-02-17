class_name ResBehavior
extends Resource

var node : Node

func setup(_node:Node, physic_ticks :bool = false):
	node = _node
	if physic_ticks:
		node.get_tree().physics_frame.connect(_physics_ticks)
	ready()
	
func ready():
	pass
	
func _physics_ticks():
	if node.is_inside_tree():
		_physics_process(node.get_physics_process_delta_time())
		
func _physics_process(_delta):
	pass
