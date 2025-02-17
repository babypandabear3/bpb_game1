extends MenuWindow

const ROW_SAVEFILE = preload("res://main_menu_screen/row_savefile.tscn")
var savedata : Res_Generic

func _ready() -> void:
	savedata = GlobalAutoload.savedata
		
func _on_btn_new_save_button_down() -> void:
	save(-1)

func save(slot:int):
	var data = {}
	var leveldata = GlobalAutoload.current_level.get_data_to_save()
	data["level_name"] = leveldata["level_name"]
	data["level_file"] = leveldata["level_file"]
	data["time_str"] = GlobalAutoload.get_gameplay_time_str()
	data["time"] = GlobalAutoload.get_gameplay_time()
	var instance_data = {}
	for obj in get_tree().get_nodes_in_group("has_uniqueID"):
		instance_data[obj.uniqueID] = obj.savedata.get_data_to_save()
	data["instance_data"] = instance_data
	
	var index = slot
	if index == -1:
		var keys = savedata.data.keys().duplicate(true)
		if keys.size() > 0:
			keys.sort()
			index = keys.pop_back() + 1
		else:
			index = 1
		
	data["slot"] = index
	savedata.data["most_recent_slot"] = index
	savedata.data[index] = data
	GlobalAutoload.savegame()

	close_window()
	
func _on_btn_close_button_down() -> void:
	close_window()
	
func close_window():
	await get_tree().create_timer(0.3).timeout
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	InputAutoload.ignore_input = false
	get_tree().paused = false
	hide()
	
func popup():
	super()
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	InputAutoload.ignore_input = true
	get_tree().paused = true
	
	populate_row()
	
func populate_row():
	for obj in %save_slot_Container.get_children():
		obj.queue_free()
	await get_tree().process_frame
	
	var keys = savedata.data.keys()
	if keys.size() > 0:
		keys.sort()
		for key in keys:
			if str(key).is_valid_int():
				var row = ROW_SAVEFILE.instantiate()
				%save_slot_Container.add_child(row)
				row.set_data(savedata.data[key])
				row.main_node = self
			
func row_button_action(slot):
	save(slot)
	
