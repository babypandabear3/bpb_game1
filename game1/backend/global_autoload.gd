class_name AutoloadGlobal
extends Node

const SAVEFILE = "user://saves.res"

var savedata : Res_Generic

var debugging := false
const first_level = "level_1"
var is_load_level := false
var load_level_name := ""
var load_level_data := {}

var player_damage := 0.0
var enemy_damage := 0.0
var aggressiveness := 0.0

var levels = {}
var dict_door_out = {}

var camera_gameplay : Camera_Gameplay
var camera_cutscene

var current_level_name := ""
var last_door := ""
var last_level_resource
var current_level : Level_Scene

var main_game
var player_gui
var system_menu
var gameplay_menu
var menu_death

var point_of_interest = []
var data_to_save = {}

const MAIN_GAME = preload("res://main_game.tscn")
const MAIN_MENU = preload("res://main_menu_screen/main_menu.tscn")

#gameplay timer
var hh := 0
var mm := 0
var ss := 0
var ms := 0.0

func _enter_tree() -> void:
	request_ready()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(SAVEFILE):
		savedata = ResourceLoader.load(SAVEFILE)
	else:
		savedata = Res_Generic.new()

	process_mode = PROCESS_MODE_ALWAYS
	call_deferred("late_ready")
	
func late_ready():
	pass
	
func append_data_to_save_resource(res):
	data_to_save[res.unique_id] = res
	
func update_point_of_interest():
	point_of_interest = []
	for obj in get_tree().get_nodes_in_group("point_of_interest"):
		point_of_interest.append(obj.global_position)
		if get_tree().current_scene.get("debug"):
			obj.queue_free()
		
func register_door_out(_name, _door):
	dict_door_out[_name] = _door
	
		
func find_key_in_dict(dict : Dictionary, key : Variant):
	var ret = null
	for k in dict.keys():
		if key == k:
			ret = dict[key]
	return ret

func start_new_game():
	is_load_level = false
	gameplay_timer_restart()
	get_tree().change_scene_to_file("res://main_game.tscn")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	gameplay_timer(_delta)
	
		
func gameplay_timer_restart():
	hh = 0
	mm = 0
	ss = 0
	ms = 0
	
func gameplay_timer(_delta):
	ms += _delta
	if ms >= 1.0:
		ss += 1
		ms -= 1.0
	if ss == 60:
		mm += 1
		ss = 0
	if mm == 60:
		hh += 1
		mm = 0

func get_gameplay_time():
	var data = {}
	data["hh"] = hh
	data["mm"] = mm
	data["ss"] = ss
	data["ms"] = ms
	return data
	
func get_gameplay_time_str():
	return str(hh) + ":" + str(mm) + ":" + str(ss)


func load_threaded_level(level_name):
	ResourceLoader.load_threaded_request("res://levels/" + level_name + ".tscn")
	
func change_level_to(level_name:String = "", door:String = ""):
	current_level_name = level_name
	last_door = door
	var level_scene = ResourceLoader.load_threaded_get("res://levels/" + level_name + ".tscn")
	last_level_resource = level_scene
	var new_level = level_scene.instantiate()
	var level_root = get_tree().get_first_node_in_group("level_root")
	for c in level_root.get_children():
		c.queue_free()
	await get_tree().physics_frame
	level_root.add_child(new_level)
	await get_tree().physics_frame
	var door_out = new_level.get_default_door()
	current_level = new_level
	if door != "":
		door_out = dict_door_out.get(door)
		
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.global_position = door_out.global_position
		player.global_position.y += 1.0
		player.model.global_basis = door_out.global_basis
	camera_gameplay.axis_y_direction(-player.model.global_basis.z)
	InputAutoload.ignore_input = true
	await get_tree().create_timer(1.0).timeout
	InputAutoload.ignore_input = false
	
func camera_gameplay_screen_shake():
	camera_gameplay.apply_shake()

func load_save_game(data):
	load_level_data = data
	var level_file : String = data["level_file"]
	var level_name = level_file.substr(13, level_file.length())
	level_name = level_name.substr(0, level_name.length() - 5)
	load_level_name = level_name
	is_load_level = true
	gameplay_timer_restart()
	get_tree().change_scene_to_file("res://main_game.tscn")
	

func restore_load_data():
	var time = load_level_data["time"]
	hh = time.hh
	mm = time.mm
	ss = time.ss
	ms = time.ms
	
	var instance_data = load_level_data["instance_data"]
	var idkeys = instance_data.keys()
	for obj in get_tree().get_nodes_in_group("has_uniqueID"):
		if obj.uniqueID in idkeys:
			obj.restore_savedata(instance_data[obj.uniqueID])
		
func try_continue():
	var most_recent_slot = savedata.data.get("most_recent_slot")
	if most_recent_slot:
		get_tree().paused = false
		load_save_game(savedata.data[most_recent_slot])

func savegame():
	ResourceSaver.save(savedata, SAVEFILE)
