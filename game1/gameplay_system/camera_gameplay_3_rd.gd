class_name Camera_Gameplay
extends Node3D

@export var follow : NodePath

var follow_node : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	follow_node = get_node_or_null(follow)
	if not follow_node:
		set_physics_process(false)
	else:
		InputAutoload.set_aim_axis(%axis_x, %axis_y)
	GlobalAutoload.camera_gameplay = self

func _physics_process(_delta: float) -> void:
	global_transform = global_transform.interpolate_with(follow_node.global_transform, 0.5)

func black():
	%screencover.color = Color.BLACK
	
func crossfade():
	var tween = create_tween()
	tween.tween_property(%screencover, "color", Color.BLACK, 0.1)
	tween.tween_property(%screencover, "color", Color.TRANSPARENT, 2.0).set_delay(0.5)
	
	
func fade_in():
	var tween = create_tween()
	tween.tween_property(%screencover, "color", Color.TRANSPARENT, 2.0)
	
func fade_to_white():
	var tween = create_tween()
	tween.tween_property(%screencover, "color", Color.WHITE, 2.0)

func fade_to_black():
	var tween = create_tween()
	tween.tween_property(%screencover, "color", Color.BLACK, 2.0)

func axis_y_direction(dir):
	var bas = Basis.looking_at(dir)
	%axis_y.global_basis = bas
