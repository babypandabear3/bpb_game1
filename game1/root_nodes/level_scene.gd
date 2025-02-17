@tool
class_name Level_Scene
extends NavigationRegion3D
@export var bake : bool = false :
	set(value):
		if Engine.is_editor_hint():
			do_bake()
@export var default_door_out_path : NodePath
@export var level_name : String = ""
var default_door_out
var skip_nav_objs = {}
var skip_nav_obj_parents = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	add_to_group("LevelScene")
	default_door_out = get_node_or_null(default_door_out_path)
	GlobalAutoload.current_level = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func get_data_to_save():
	var data = {}
	data["level_file"] = scene_file_path
	data["level_name"] = level_name
	return data
	
func get_default_door():
	default_door_out = get_node_or_null(default_door_out_path)
	return default_door_out

func recursive_find_skip_bake(parent_node):
	for child in parent_node.get_children():
		recursive_find_skip_bake(child)
		if child.is_in_group("skip_bake"):
			skip_nav_objs[child.global_transform] = child
			skip_nav_obj_parents[child.global_transform] = child.get_parent()
			
func do_bake():
	skip_nav_objs = {}
	skip_nav_obj_parents = {}
	recursive_find_skip_bake(self)
	for child in skip_nav_objs.values():
		child.get_parent().remove_child(child)
	await get_tree().physics_frame
	bake_navigation_mesh()
	await get_tree().physics_frame
	for transf in skip_nav_objs.keys():
		skip_nav_obj_parents[transf].add_child(skip_nav_objs[transf])
		skip_nav_objs[transf].global_transform = transf
		skip_nav_objs[transf].owner = self
	
