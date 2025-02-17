extends MenuWindow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%lbl_music_volume.text = "Music Volume : " + str(%HSlider_music_volume.value)
	%lbl_interface_volume.text = "Interface Volume : " + str(%HSlider_interface_volume.value)
	%lbl_player_volume.text = "Player Volume : " + str(%HSlider_player_volume.value)
	%lbl_ambient_volume.text = "Ambient Volume : " + str(%HSlider_ambient_volume.value)

func _on_h_slider_music_volume_value_changed(value: float) -> void:
	SodaAudioManager.musicVolume = value
	%lbl_music_volume.text = "Music Volume : " + str(%HSlider_music_volume.value)

func _on_h_slider_interface_volume_value_changed(value: float) -> void:
	SodaAudioManager.sfxInterfaceVolume = value
	%lbl_interface_volume.text = "Interface Volume : " + str(%HSlider_interface_volume.value)

func _on_h_slider_player_volume_value_changed(value: float) -> void:
	SodaAudioManager.sfxPlayerVolume = value
	%lbl_player_volume.text = "Player Volume : " + str(%HSlider_player_volume.value)

func _on_h_slider_ambient_volume_value_changed(value: float) -> void:
	SodaAudioManager.sfxAmbientVolume = value
	%lbl_ambient_volume.text = "Ambient Volume : " + str(%HSlider_ambient_volume.value)
	
func _on_btn_close_button_down() -> void:
	main_node.c_option()
	

func get_data_to_save():
	var ret = {}
	ret["music_volume"] = %HSlider_music_volume.value
	ret["interface_volume"] = %HSlider_interface_volume.value
	ret["player_volume"] = %HSlider_player_volume.value
	ret["ambient_volume"] = %HSlider_ambient_volume.value
	return ret
	
func set_data_from_save(data):
	%HSlider_music_volume.value = data["music_volume"]
	%HSlider_interface_volume.value = data["interface_volume"] 
	%HSlider_player_volume.value = data["player_volume"] 
	%HSlider_ambient_volume.value = data["ambient_volume"] 


func _on_h_slider_music_volume_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()


func _on_h_slider_interface_volume_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()


func _on_h_slider_player_volume_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()


func _on_h_slider_ambient_volume_drag_ended(_value_changed: bool) -> void:
	main_node.c_save_options()
