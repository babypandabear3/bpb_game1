extends MenuWindow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_lbl_player_damage()
	update_lbl_enemy_damage()
	update_lbl_aggressiveness()
	update_label_mouse()
	update_label_gamepad()
	
func update_lbl_player_damage():
	%lbl_player_damage.text = "Player Damage : " + str(%HSlider_player_damage.value) + " %"

func update_lbl_enemy_damage():
	%lbl_enemy_damage.text = "Player Damage : " + str(%HSlider_enemy_damage.value) + " %"
	
func update_lbl_aggressiveness():
	%lbl_aggressiveness.text = "Player Damage : " + str(%HSlider_aggressiveness.value) + " %"

func update_label_mouse():
	%lbl_mouse.text = "Mouse Sensitivity : " + str(%HSlider_mouse.value)

func update_label_gamepad():
	%lbl_gamepad.text = "Gamepad Camera Sensitivity : " + str(%HSlider_gamepad.value)
	
func _on_h_slider_player_damage_value_changed(_value: float) -> void:
	update_lbl_player_damage()
	pass # Replace with function body.


func _on_h_slider_player_damage_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()
	GlobalAutoload.player_damage = %HSlider_player_damage.value
	pass # Replace with function body.


func _on_h_slider_enemy_damage_value_changed(_value: float) -> void:
	update_lbl_enemy_damage()
	pass # Replace with function body.


func _on_h_slider_enemy_damage_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()
	GlobalAutoload.enemy_damage = %HSlider_enemy_damage.value
	pass # Replace with function body.


func _on_h_slider_aggressiveness_value_changed(_value: float) -> void:
	update_lbl_aggressiveness()
	pass # Replace with function body.


func _on_h_slider_aggressiveness_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()
	GlobalAutoload.aggressiveness = %HSlider_aggressiveness.value
	pass # Replace with function body.


func _on_btn_close_button_down() -> void:
	main_node.c_option()
	pass # Replace with function body.

func get_data_to_save():
	var ret = {}
	ret["player_damage"] = %HSlider_player_damage.value
	ret["enemy_damage"] = %HSlider_enemy_damage.value
	ret["aggressiveness"] = %HSlider_aggressiveness.value
	ret["mouse_sensitivity"] = %HSlider_mouse.value
	ret["gamepad_camera_sensitivity"] = %HSlider_gamepad.value
	return ret
	
func set_data_from_save(data):
	%HSlider_player_damage.value = data["player_damage"]
	%HSlider_enemy_damage.value = data["enemy_damage"] 
	%HSlider_aggressiveness.value = data["aggressiveness"] 
	%HSlider_mouse.value = data["mouse_sensitivity"] 
	%HSlider_gamepad.value = data["gamepad_camera_sensitivity"] 
	GlobalAutoload.player_damage = %HSlider_player_damage.value
	GlobalAutoload.enemy_damage = %HSlider_enemy_damage.value
	GlobalAutoload.aggressiveness = %HSlider_aggressiveness.value
	InputAutoload.mouse_sensitivity = %HSlider_mouse.value
	InputAutoload.gamepad_camera_sensitivity = %HSlider_gamepad.value

func _on_h_slider_mouse_value_changed(_value: float) -> void:
	update_label_mouse()
	pass # Replace with function body.


func _on_h_slider_mouse_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()
	InputAutoload.mouse_sensitivity = %HSlider_mouse.value
	pass # Replace with function body.


func _on_h_slider_gamepad_value_changed(_value: float) -> void:
	update_label_gamepad()
	pass # Replace with function body.


func _on_h_slider_gamepad_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()
	InputAutoload.gamepad_camera_sensitivity = %HSlider_gamepad.value
	pass # Replace with function body.
