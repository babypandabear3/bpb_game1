class_name AutoloadInput
extends Node

signal system_menu_show

@export_range(1, 1000, 1) var mouse_sensitivity: int = 200
@export_range(1, 1000, 1) var gamepad_camera_sensitivity: int = 200
@export var max_pitch : float = 80
@export var min_pitch : float = -80

var axis_y : Node3D
var axis_x : Node3D
# Called when the node enters the scene tree for the first time.
var action1_pressed := false
var action1_just_pressed := false
var action1_just_released := false
var action1_hold_time := 0.0

var action2_pressed := false
var action2_just_pressed := false
var action2_just_released := false
var action2_hold_time := 0.0

var jump_pressed := false
var jump_just_pressed := false
var jump_just_released := false
var jump_hold_time := 0.0

var interact_pressed := false
var interact_just_pressed := false
var interact_just_released := false
var interact_hold_time := 0.0

var evade_pressed := false
var evade_just_pressed := false
var evade_just_released := false
var evade_hold_time := 0.0

var guard_pressed := false
var guard_just_pressed := false
var guard_just_released := false
var guard_hold_time := 0.0

var start_pressed := false
var start_just_pressed := false
var start_just_released := false
var start_hold_time := 0.0

var select_pressed := false
var select_just_pressed := false
var select_just_released := false
var select_hold_time := 0.0

var skill1_pressed := false
var skill1_just_pressed := false
var skill1_just_released := false
var skill1_hold_time := 0.0

var skill2_pressed := false
var skill2_just_pressed := false
var skill2_just_released := false
var skill2_hold_time := 0.0

var actions = ["action1", "action2", "jump", "interact", "evade", "guard", "skill1", "skill2", "start", "select"]
var kbm_actions = ["move_left", "move_right", "move_up", "move_down", "action1", "action2", "jump", "interact", "evade", "guard", "skill1", "skill2", "start", "select"]
var gamepad_actions = ["move_left", "move_right", "move_up", "move_down", "action1", "action2", "jump", "interact", "evade", "guard", "skill1", "skill2", "start", "select"]
var input_dir := Vector2.ZERO
var camera_dir := Vector2.ZERO
var mouse_motion := Vector2.ZERO

var ignore_input := false
var in_game := false

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Input.set_use_accumulated_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		if is_equal_approx(Engine.time_scale, 1.0):
			Engine.time_scale = 0.5
		else:
			Engine.time_scale = 1.0
			
	if Input.is_action_just_pressed("debug2"):
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player.attribute.time_scale_immune = not player.attribute.time_scale_immune
	
	if Input.is_action_just_pressed("debug3"):
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player.apply_central_impulse(Vector3.RIGHT * 10.0)
	
	if Input.is_action_just_pressed("debug4"):
		var player = get_tree().get_first_node_in_group("Player")
		if player:
			player.attribute.restore_stats()
			
	if ignore_input:
		get_empty_input()
	else:
		get_inputs(_delta)
	
	if in_game:
		if Input.is_action_just_pressed("select"):
			if not get_tree().paused:
				system_menu_show.emit()
				
	if not camera_dir.is_zero_approx() and is_instance_valid(axis_x) and is_instance_valid(axis_y):
		camera_dir *= float(gamepad_camera_sensitivity) / 100
		axis_y.rotate_object_local(Vector3.DOWN, deg_to_rad(camera_dir.x))
		axis_y.orthonormalize()
		axis_x.rotate_object_local(Vector3.LEFT, deg_to_rad(camera_dir.y))
		axis_x.orthonormalize()
		if axis_x.rotation.x > deg_to_rad(min_pitch) and axis_x.rotation.x < deg_to_rad(max_pitch):
			return
	
		axis_x.rotation.x = clamp(axis_x.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		axis_x.orthonormalize()
				
func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		if not ignore_input:
			aim_look(_event)
	pass
	
func set_aim_axis(_x, _y):
	axis_x = _x
	axis_y = _y
	
func aim_look(event: InputEventMouseMotion)-> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.001
	
	motion *= mouse_sensitivity
	motion *= degrees_per_unit
	mouse_motion = motion
	if is_instance_valid(axis_x) and is_instance_valid(axis_y):
		add_yaw(motion.x)
		add_pitch(motion.y)
		clamp_pitch()
	
#Rotates the character around the local Y axis by a given amount (In degrees) to achieve yaw.
func add_yaw(amount)->void:
	if is_zero_approx(amount):
		return
	axis_y.rotate_object_local(Vector3.DOWN, deg_to_rad(amount))
	axis_y.orthonormalize()

#Rotates the head around the local x axis by a given amount (In degrees) to achieve pitch.
func add_pitch(amount)->void:
	if is_zero_approx(amount):
		return
	axis_x.rotate_object_local(Vector3.LEFT, deg_to_rad(amount))
	axis_x.orthonormalize()


#Clamps the pitch between min_pitch and max_pitch.
func clamp_pitch()->void:
	if axis_x.rotation.x > deg_to_rad(min_pitch) and axis_x.rotation.x < deg_to_rad(max_pitch):
		return
	
	axis_x.rotation.x = clamp(axis_x.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	axis_x.orthonormalize()
		
func get_empty_input():
	input_dir = Vector2.ZERO
	camera_dir = Vector2.ZERO
	
	for act in actions:
		set(act + "_pressed", false)
		set(act + "_just_pressed", false)
		set(act + "_just_released", false)
		
	start_just_pressed = Input.is_action_just_pressed("start")
	select_just_pressed = Input.is_action_just_pressed("select")
	
func get_inputs(delta):
	input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	camera_dir = Vector2.ZERO
	camera_dir.x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	camera_dir.y = Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	
	for act in actions:
		if Input.is_action_pressed(act):
			set(act + "_pressed", true)
			set(act + "_hold_time", get(act + "_hold_time") + delta)
		else:
			set(act + "_pressed", false)
			
		if Input.is_action_just_pressed(act):
			set(act + "_just_pressed", true)
			set(act + "_hold_time", 0.0)
		else:
			set(act + "_just_pressed", false)
			
		if Input.is_action_just_released(act):
			set(act + "_just_released", true)
		else:
			set(act + "_just_released", false)
	
