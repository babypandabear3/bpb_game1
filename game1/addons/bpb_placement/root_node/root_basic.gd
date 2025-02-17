@tool
class_name BPB_Root_Basic
extends Node3D

@export var grid_size : Vector3i = Vector3i(50,50,50)
@export var make_multimeshes : bool = false #:
	#set(value):
	#	make_multimeshes = false
	#	do_make_multimeshes()
		
var chunk = {}

var cutable = []
var cutable_area : Area3D
var cutable_data = []
var item_scene = []
var cut_count : int = 0
var cut_mod : int = 0
var cut_mod_max : int = 6

#@onready var grass_cut_particle_i = preload("res://effects/grass_cut_particle.tscn")

class Data:
	var poskey : Vector3i
	var meshdata : Mesh
	var mtransform : Transform3D
	var id : String
	var multimesh_node : MultiMeshInstance3D
	var multimesh : MultiMesh
	var instance_count : int
	var local_transform : Transform3D
	
	func _init(p_poskey: Vector3i, p_meshdata: Mesh, p_mtransform : Transform3D) -> void:
		poskey = p_poskey
		meshdata = p_meshdata
		mtransform = p_mtransform
		id = str(poskey) + str(meshdata.get_rid())
		
class CutableData:
	var id : String
	var node : Node3D
	var transf : Transform3D
	var cutted : bool
	var filepath : String
	
	func _init(p_id : String, p_node: Node3D, p_filepath:String):
		id = p_id
		node = p_node
		transf = p_node.global_transform
		cutted = false
		filepath = p_filepath
		
		
func _init() -> void:
	cut_mod = randi_range(0, cut_mod_max)
	
	#cutable.append("grass_common_short.glb")
	#cutable.append("grass_common_tall.glb")
	#cutable.append("grass_wispy_short.glb")
	#cutable.append("grass_wispy_tall.glb")
	#
	#item_scene.append(preload("res://inventory/money/gold1_.tscn"))
	#item_scene.append(preload("res://inventory/money/gold5_.tscn"))
	#item_scene.append(preload("res://inventory/money/gold10_.tscn"))
	#
func _ready():
	if Engine.is_editor_hint():
		return
	await get_tree().process_frame
	
	if make_multimeshes:
		do_make_multimeshes()
		await get_tree().process_frame
		await get_tree().process_frame
	
	#make_cutable()
	
	var meshes = find_children("*", "MeshInstance3D")
	for m in meshes:
		m.show()
		#m.queue_free()
	#for mm in get_parent().find_children("*", "MultiMeshInstance3D"):
	#	mm.queue_free()
	pass # Replace with function body.
	await get_tree().process_frame
	fill_chunk()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.

func do_make_multimeshes():
	var meshes = find_children("*", "MeshInstance3D")
	var data = []
	var multimesh_node_data = {}
	
	#gathering data
	for m in meshes:
		var poskey = Vector3i( m.global_position.snapped(grid_size) )
		var d = Data.new(poskey, m.mesh, m.global_transform)
		data.append(d)
		
	#create multimesh instance node
	for d in data:
		var mm = find_key_in_dict(multimesh_node_data, d.id)
		if not find_key_in_dict(multimesh_node_data, d.id):
			mm = MultiMeshInstance3D.new()
			get_parent().add_child(mm)
			mm.global_position = Vector3(d.poskey)
			mm.owner = owner
			var mmmultimesh = MultiMesh.new()
			mmmultimesh.transform_format = MultiMesh.TRANSFORM_3D
			mm.multimesh = mmmultimesh
			mmmultimesh.mesh = d.meshdata
			multimesh_node_data[d.id] = mm
			
			
		var mmm : MultiMesh = mm.multimesh 
		mmm.instance_count += 1
		var transf = d.mtransform
		transf.origin -= Vector3(d.poskey)
			
		d.multimesh_node = mm
		d.multimesh = mmm
		d.instance_count = mmm.instance_count-1
		d.local_transform = transf
		
	await get_tree().process_frame
	
	#set multimesh transform
	for d in data:
		d.multimesh.set_instance_transform(d.instance_count, d.local_transform)

	for m in meshes:
		m.hide()

func find_key_in_dict(dict : Dictionary, key : Variant):
	var ret = null
	for k in dict.keys():
		if key == k:
			ret = dict[key]
			
	return ret

func fill_chunk():
	chunk = {}
	for m in find_children("*", "MeshInstance3D"):
		if not m.is_in_group("impostor"):
			var poskey = Vector3i(m.global_position).snapped(grid_size)
			var chunk_part = find_key_in_dict(chunk, poskey)
			if not chunk_part:
				chunk[poskey] = []
			chunk[poskey].append(m)
			
	for m in get_parent().find_children("*", "MultiMeshInstance3D"):
		if not m.is_in_group("impostor"):
			var poskey = Vector3i(m.global_position).snapped(grid_size)
			var chunk_part = find_key_in_dict(chunk, poskey)
			if not chunk_part:
				chunk[poskey] = []
			chunk[poskey].append(m)
	
func _timer_timeout():
	var camera_key = Vector3i(get_viewport().get_camera_3d().global_position).snapped(grid_size)
	var key = camera_key
	key.x -= grid_size.x 
	key.y -= grid_size.y
	key.z -= grid_size.z
	
	var key_check = []
	for x in 3:
		for y in 3:
			for z in 3:
				var tmp = key
				tmp.x += x * grid_size.x
				tmp.y += y * grid_size.y
				tmp.z += z * grid_size.z
				key_check.append(tmp)
				
#
#func make_cutable():
	#
	#var id :int = 0
	#for obj in get_children():
		#var filepath = obj.scene_file_path.get_file()
		#
		#if cutable.find(filepath) != -1:
			#var cd = CutableData.new(str(id), obj, filepath)
			#cutable_data.append(cd)
			#id += 1
	#
	#if cutable_data.size() > 0:
		#cutable_area = Area3D.new()
		#cutable_area.set_collision_layer_value(1, false)
		#cutable_area.set_collision_layer_value(3, true)
		#cutable_area.set_collision_mask_value(1, false)
		#cutable_area.set_collision_mask_value(5, true)
		#add_child(cutable_area)
		#var shape = CapsuleShape3D.new()
		#shape.radius = 0.4
		#shape.height = 2.0
		#for cd in cutable_data:
			#var colshape = CollisionShape3D.new()
			#colshape.shape = shape
			#cutable_area.add_child(colshape)
			#colshape.name = cd.id
			#colshape.global_transform = cd.transf
			#
		#cutable_area.area_shape_entered.connect(_cutable_area_area_shape_entered)
		#
#func _cutable_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int):
	#var cutter_shape_owner = area.shape_find_owner(area_shape_index)
	#var cutter_shape_node = area.shape_owner_get_owner(cutter_shape_owner)
	#
	#var local_shape_owner = cutable_area.shape_find_owner(local_shape_index)
	#var local_shape_node = cutable_area.shape_owner_get_owner(local_shape_owner)
	#
	#if cutter_shape_node.is_in_group("sharp"):
		#for cd in cutable_data:
			#if cd.id == local_shape_node.name and cd.cutted == false:
				#cd.cutted = true
				#var bas = cd.transf.basis
				#bas.y *= -1
				#bas.z *= -1
				#cd.node.global_basis = bas
				#var particle = grass_cut_particle_i.instantiate()
				#add_child(particle)
				#particle.global_transform = cd.transf
				#particle.prepare(cd.filepath)
				#
				#cut_count = wrapi(cut_count + 1, 0, cut_mod_max)
				#if cut_count == 0:
					#cut_mod = randi_range(0, cut_mod_max)
				#if cut_count == cut_mod:
					#var idx = randi_range(0, item_scene.size()-1)
					#var item = item_scene[idx].instantiate()
					#add_child(item)
					#item.global_transform = cd.transf
					#item.owner = owner
					#if item is RigidBody3D:
						#item.apply_central_impulse(cd.transf.basis.y * 5.0)
					#
	#
