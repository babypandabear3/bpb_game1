@tool
extends Area3D

@export var level_to_go : String = ""
@export var door_to_go : String = ""

@export var door_size : Vector3 = Vector3(6,6,2):
	set(value):
		set_door_size(value)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		if local_shape_index == 0:
			GlobalAutoload.load_threaded_level(level_to_go)
		else:
			GlobalAutoload.camera_gameplay.crossfade()
			GlobalAutoload.change_level_to(level_to_go, door_to_go)

func set_door_size(value):
	%col_loader.shape.size = value
	%col_loader.position = Vector3(0, value.y /2, value.z / 2)
	%col_door.position = Vector3(0, value.y /2, -value.z / 2)
