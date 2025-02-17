extends MenuWindow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().gui_snap_controls_to_pixels = true
	%label_scaling3d.text = "Scaling 3D : " + str(%HSlider_scaling3d.value)

func _on_chk_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	main_node.c_save_options()

func _on_h_slider_scaling_3d_drag_ended(_value_changed: bool) -> void:
	get_viewport().scaling_3d_scale = %HSlider_scaling3d.value
	main_node.c_save_options()


func _on_h_slider_scaling_3d_value_changed(value: float) -> void:
	%label_scaling3d.text = "Scaling 3D : " + str(value)
	pass # Replace with function body.


func _on_opt_scaling_3d_mode_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		1:
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		2:
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
	main_node.c_save_options()


func _on_opt_msaa_3d_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_3d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_3d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_3d = Viewport.MSAA_8X
	main_node.c_save_options()


func _on_chk_fxaa_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	else:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	main_node.c_save_options()

func _on_opt_msaa_2d_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().msaa_2d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_2d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_2d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_2d = Viewport.MSAA_8X
	main_node.c_save_options()


func _on_btn_close_button_down() -> void:
	main_node.c_option()
	

func get_data_to_save():
	var ret = {}
	ret["fullscreen"] = %chk_fullscreen.button_pressed
	ret["scaling3d_mode"] = %opt_scaling3d_mode.selected
	ret["scaling3d"] = %HSlider_scaling3d.value
	ret["msaa3d"] = %opt_msaa3d.selected
	ret["fxaa"] = %chk_fxaa.button_pressed
	ret["msaa2d"] = %opt_msaa2d.selected
	return ret
	
func set_data_from_save(data):
	%chk_fullscreen.button_pressed = data["fullscreen"]
	%opt_scaling3d_mode.selected = data["scaling3d_mode"] 
	%HSlider_scaling3d.value = data["scaling3d"] 
	%opt_msaa3d.selected = data["msaa3d"] 
	%chk_fxaa.button_pressed = data["fxaa"] 
	%opt_msaa2d.selected = data["msaa2d"]

	if data["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	match data["scaling3d_mode"]:
		0:
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		1:
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		2:
			get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
			
	get_viewport().scaling_3d_scale = data["scaling3d"] 
	
	match data["msaa3d"] :
		0:
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_3d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_3d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_3d = Viewport.MSAA_8X
			
	if data["fxaa"] :
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	else:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		
	match data["msaa2d"]:
		0:
			get_viewport().msaa_2d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_2d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_2d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_2d = Viewport.MSAA_8X
