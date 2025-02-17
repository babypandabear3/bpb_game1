extends MenuWindow

const ROW_SAVEFILE = preload("res://main_menu_screen/row_savefile.tscn")

var savedata : Res_Generic
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	savedata = GlobalAutoload.savedata
		
func popup():
	super()
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
	load_save(slot)
	
func load_save(slot):
	get_tree().paused = false
	GlobalAutoload.load_save_game(savedata.data[slot])
	pass


func _on_btn_close_button_down() -> void:
	if main_node is MainMenu:
		main_node.c_main_menu()
	else:
		main_node.c_option()
