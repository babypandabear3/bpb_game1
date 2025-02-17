class_name BehaviorPlayerControl
extends ResBehavior

var body : CharBody
var model : Model

func ready():
	node.add_to_group("Player")
	body = node as CharBody
	if is_instance_valid(body.model):
		model = body.model
		
	if model:
		model.register_looped_animations("Idle")
		model.register_looped_animations("Run")
		model.register_looped_animations("Jump_Idle")
		
		model.animation_finished.connect(_animation_finished)
	
func _physics_process(_delta):
	read_player_input()
	
func read_player_input():
	body.direction = (body.get_camera_basis_flattened() * Vector3(InputAutoload.input_dir.x, 0, InputAutoload.input_dir.y)).normalized()
	if InputAutoload.jump_just_pressed :
		body.try_jump()

func _animation_finished(anim):
	print("anim finished:", anim)
	pass
