extends MenuWindow

func _ready() -> void:
	for obj in %container_menu.get_children():
		obj.focus_entered.connect(AudioplayerAutoload.sfx_hover)
		obj.mouse_entered.connect(AudioplayerAutoload.sfx_hover)
		obj.button_down.connect(AudioplayerAutoload.sfx_confirm)
		
func _on_btn_setting_button_down() -> void:
	main_node.c_opt_setting()
	pass # Replace with function body.

func _on_btn_gameplay_button_down() -> void:
	main_node.c_opt_gameplay()
	pass # Replace with function body.


func _on_btn_keymap_button_down() -> void:
	main_node.c_opt_keymapper()
	pass


func _on_btn_graphic_button_down() -> void:
	main_node.c_opt_graphic()
	pass # Replace with function body.


func _on_btn_audio_button_down() -> void:
	main_node.c_opt_audio()
	pass # Replace with function body.


func _on_btn_close_button_down() -> void:
	main_node.c_main_menu()
	pass # Replace with function body.
