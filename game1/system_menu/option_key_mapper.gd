extends MenuWindow

const RESFILE = "user://keymap_kbm.res"

var main_scene

var lower_node : Control

@onready var keyboard_mouse: PanelContainer = $VBoxContainer/ScrollContainer/container/Keyboard_Mouse
@onready var gamepad: PanelContainer = $VBoxContainer/ScrollContainer/container/Gamepad


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for obj in %container_menu.get_children():
		if obj is Button:
			obj.focus_entered.connect(AudioplayerAutoload.sfx_hover)
			obj.mouse_entered.connect(AudioplayerAutoload.sfx_hover)
			obj.button_down.connect(AudioplayerAutoload.sfx_confirm)
		
		
	for obj in %container.get_children():
		obj.hide()
		obj.main_scene = self
		
		
	if FileAccess.file_exists(RESFILE):
		print("Remap file exists : ", RESFILE)
		restore_custom_keymap()
	else:
		print("Remap file doesn't exist : ", RESFILE)
	
	_on_btn_kbm_button_down()

func _inputmap_updated():
	var res = Res_Keymap.new()
	keyboard_mouse.get_remap_data(res)
	gamepad.get_remap_data(res)
	
	if ResourceSaver.save(res, RESFILE) == OK:
		print("save keymap to ", RESFILE)
	else:
		print("fail to save keymap to ", RESFILE)

	
func restore_custom_keymap():
	var res = ResourceLoader.load(RESFILE)
	for data in res.data_kbm:
		InputMap.action_erase_event(data["action"], data["event_original"])
		InputMap.action_add_event(data["action"], data["event_custom"])
	for data in res.data_gamepad:
		InputMap.action_erase_event(data["action"], data["event_original"])
		InputMap.action_add_event(data["action"], data["event_custom"])
	print("Remap file restored : ", RESFILE)


func _on_btn_kbm_button_down() -> void:
	keyboard_mouse.show()
	gamepad.hide()
	pass # Replace with function body.


func _on_btn_gamepad_button_down() -> void:
	keyboard_mouse.hide()
	gamepad.show()
	pass # Replace with function body.


func _on_btn_clear_button_down() -> void:
	if FileAccess.file_exists(RESFILE):
		DirAccess.remove_absolute(RESFILE)
	InputMap.load_from_project_settings()
	
	await get_tree().physics_frame
	keyboard_mouse.reset()
	gamepad.reset()
	pass # Replace with function body.


func _on_btn_close_button_down() -> void:
	main_node.c_option()
	pass # Replace with function body.
