@tool
class_name CharBody
extends CharacterBody3D

signal airborne_entered
signal landing_entered
signal jumped
signal run_entered
signal stop_entered

@export var include_in_save : bool :
	set(value):
		if value:
			uniqueID = Time.get_datetime_string_from_system()
			savedata = Res_SaveData.new()
			savedata.unique_id = uniqueID
			notify_property_list_changed()
			
@export var uniqueID : String = ""
@export var savedata : Res_SaveData
@export var player_control :bool = true
@export var behavior : ResBehavior

var model : Model
var MAX_SPEED = 10.0
var SPEED = 5.0
var JUMP_VELOCITY = 6.0
var h_velocity := Vector3.ZERO
var v_velocity := Vector3.ZERO
var impulse := Vector3.ZERO
var last_major_direction  := Vector3.FORWARD
var acc := 0.1
var deacc := 0.9
var impulse_deacc := 55.0
var direction := Vector3.ZERO
var jump_timer: = 0.0
var jump_timeout := 0.1
var jump_count := 0
var jump_limit := 2
var airborne := 0.0
var on_floor_prev := false

func _init() -> void:
	add_to_group("skip_bake")
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	for obj in get_children():
		if obj is Model:
			model = obj
			model.set_charbody(self)
			
	if savedata:
		add_to_group("has_uniqueID")
		savedata.resource_local_to_scene = true
		savedata.setup(self)

		
	if behavior:
		player_control = false
		behavior.resource_local_to_scene = true
		behavior.setup(self, true)
		
	if player_control:
		add_to_group("Player")
		
func restore_savedata(loaded_data):
	savedata.restore(loaded_data)
	
	
func _physics_process(delta: float) -> void:
	if player_control:
		read_player_input()
	do_movement(delta)
	
	if on_floor_prev and not is_on_floor():
		airborne_entered.emit()
	if not on_floor_prev and is_on_floor():
		landing_entered.emit()
	
	on_floor_prev = is_on_floor()
	
func get_camera_basis_flattened():
	var bas = get_viewport().get_camera_3d().global_basis
	bas.y = Vector3.UP
	bas.x = bas.x.slide(bas.y)
	bas.z = bas.z.slide(bas.y)
	return bas.orthonormalized()
	
func read_player_input():
	direction = (get_camera_basis_flattened() * Vector3(InputAutoload.input_dir.x, 0, InputAutoload.input_dir.y)).normalized()
	if InputAutoload.jump_just_pressed :
		try_jump()
		
		
func do_movement(delta):
	h_velocity = velocity.slide(Vector3.UP)
	v_velocity = velocity.project(Vector3.UP)
	
	# Add the gravity.
	if is_on_floor():
		jump_count = 0
		airborne = 0.0
		v_velocity = Vector3.DOWN * 0.1
		floor_snap_length = 0.5
	else:
		v_velocity += Vector3.UP * get_gravity() * delta
		floor_snap_length = 0.0
		airborne += delta
		if airborne > jump_timeout and jump_count == 0:
			jump_count += 1
		
		
	# Handle jump.
	if jump_timer > 0.0:
		v_velocity = Vector3.UP * JUMP_VELOCITY
		jump_count += 1
		jump_timer = -1.0
		jumped.emit()
	else:
		jump_timer -= delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		h_velocity += direction * SPEED * acc
		h_velocity = h_velocity.limit_length(MAX_SPEED) #SPEED LIMIT
	else:
		h_velocity *= deacc
		
	velocity = h_velocity + v_velocity + impulse
	
	impulse *= impulse_deacc * delta
	
	var h_velocity_length = h_velocity.length()
	if h_velocity_length > 0.2:
		last_major_direction = h_velocity.normalized()
	
	if is_on_floor():
		if h_velocity_length > 1.0:
			run_entered.emit()
		else:
			stop_entered.emit()
			
	move_and_slide()

func try_jump():
	if jump_timer <= 0.0 and jump_count < jump_limit:
		jump_timer = jump_timeout
