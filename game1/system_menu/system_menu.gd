class_name SystemMenu
extends MenuWindow

const RESFILE = "user://options.res"

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	hide()
	for obj in get_children():
		obj.main_node = self
	
	InputAutoload.system_menu_show.connect(_system_menu_show)
#	
	if FileAccess.file_exists(RESFILE):
		print("Option file exists : ", RESFILE)
		restore_options()
	else:
		print("Option file doesn't exist : ", RESFILE)
	
func restore_options():
	var res = ResourceLoader.load(RESFILE)
	%option_graphic.set_data_from_save(res.data["graphic"])
	%option_audio.set_data_from_save(res.data["audio"])
	%option_gameplay.set_data_from_save(res.data["gameplay"])
	print("Option file restored : ", RESFILE)
	
func _system_menu_show():
	get_tree().paused = true
	popup()
	InputAutoload.ignore_input = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%panel_system_menu.popup()
	
func _system_menu_hide():
	get_tree().paused = false
	hide()
	InputAutoload.ignore_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func hide_all():
	for obj in get_children():
		obj.hide()

func c_resume() -> void:
	_system_menu_hide()
		
func c_main_menu():
	_system_menu_hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://main_menu_screen/main_menu.tscn")
	
func c_load():
	hide_all()
	%option_load.popup()
	
func c_quit():
	get_tree().quit()
		
func c_opt_keymapper():
	hide_all()
	%option_KeyMapper.popup()

func c_option():
	hide_all()
	%panel_system_menu.popup()

func c_opt_graphic():
	hide_all()
	%option_graphic.popup()
	
func c_opt_audio():
	hide_all()
	%option_audio.popup()
	
func c_opt_gameplay():
	hide_all()
	%option_gameplay.popup()
	
func c_save_options():
	var res = Res_Generic.new()
	res.data["graphic"] = %option_graphic.get_data_to_save()
	res.data["audio"] = %option_audio.get_data_to_save()
	res.data["gameplay"] = %option_gameplay.get_data_to_save()
	
	if ResourceSaver.save(res, RESFILE) == OK:
		print("save options to ", RESFILE)
	else:
		print("fail to save options to ", RESFILE)
