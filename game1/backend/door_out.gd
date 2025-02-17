class_name Door_Out
extends Marker3D

@export var door_name : String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAutoload.register_door_out(door_name, self)
