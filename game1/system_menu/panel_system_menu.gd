extends MenuWindow

func _ready() -> void:
	for obj in %option_list.get_children():
		obj.focus_entered.connect(AudioplayerAutoload.sfx_hover)
		obj.mouse_entered.connect(AudioplayerAutoload.sfx_hover)
		obj.button_down.connect(AudioplayerAutoload.sfx_confirm)
		
func _on_btn_resume_button_down() -> void:
	main_node.c_resume()
	pass # Replace with function body.

func _on_btn_keymap_button_down() -> void:
	main_node.c_opt_keymapper()
	pass # Replace with function body.

func _on_btn_main_menu_button_down() -> void:
	main_node.c_main_menu()
	pass # Replace with function body.


func _on_btn_quit_button_down() -> void:
	main_node.c_quit()
	pass # Replace with function body.


func _on_btn_setting_button_down() -> void:
	main_node.c_opt_setting()
	pass # Replace with function body.


func _on_btn_graphic_button_down() -> void:
	main_node.c_opt_graphic()
	pass # Replace with function body.


func _on_btn_audio_button_down() -> void:
	main_node.c_opt_audio()
	pass # Replace with function body.


func _on_btn_gameplay_button_down() -> void:
	main_node.c_opt_gameplay()
	pass # Replace with function body.


func _on_btn_load_button_down() -> void:
	main_node.c_load()
	pass # Replace with function body.
