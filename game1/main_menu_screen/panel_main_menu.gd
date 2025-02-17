extends MenuWindow

func _ready() -> void:
	for obj in %container_menu.get_children():
		obj.focus_entered.connect(AudioplayerAutoload.sfx_hover)
		obj.mouse_entered.connect(AudioplayerAutoload.sfx_hover)
		obj.button_down.connect(AudioplayerAutoload.sfx_confirm)

func _on_btn_continue_button_down() -> void:
	main_node.c_continue()
	pass # Replace with function body.


func _on_btn_new_game_button_down() -> void:
	main_node.c_new_game()
	pass # Replace with function body.


func _on_btn_load_button_down() -> void:
	main_node.c_load()
	pass # Replace with function body.


func _on_btn_option_button_down() -> void:
	main_node.c_option()
	pass # Replace with function body.


func _on_btn_exit_button_down() -> void:
	main_node.c_exit()
	pass # Replace with function body.
