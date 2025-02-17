class_name MainMenu
extends Control

const RESFILE = "user://options.res"
const SAVEFILE = "user://saves.res"

func _ready():
	InputAutoload.in_game = false
	for obj in get_children():
		obj.main_node = self
	c_main_menu()
	
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
	
func hide_all():
	for obj in get_children():
		obj.hide()
			
func c_continue():
	GlobalAutoload.try_continue()
	#if FileAccess.file_exists(SAVEFILE):
		#var savedata = ResourceLoader.load(SAVEFILE)
		#var most_recent_slot = savedata.data.get("most_recent_slot")
		#if most_recent_slot:
			#get_tree().paused = false
			#GlobalAutoload.load_save_game(savedata.data[most_recent_slot])
	#
func c_main_menu():
	hide_all()
	%panel_main_menu.popup()
	
func c_new_game():
	GlobalAutoload.start_new_game()
	pass
	
func c_load():
	hide_all()
	%option_load.popup()
	
func c_option():
	hide_all()
	%panel_option.popup()
	
func c_exit():
	get_tree().quit()
	
func c_opt_keymapper():
	hide_all()
	%option_KeyMapper.popup()
	
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
