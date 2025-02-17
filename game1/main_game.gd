class_name MainGame
extends Node3D

@export var debug_level : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAutoload.main_game = self
	InputAutoload.in_game = true
	GlobalAutoload.load_threaded_level("level_1")
	GlobalAutoload.camera_gameplay.black()
	%panel_save.hide()
	
	if GlobalAutoload.debugging:
		GlobalAutoload.load_threaded_level(debug_level)
		await get_tree().create_timer(1.0).timeout
		GlobalAutoload.change_level_to(debug_level)
		GlobalAutoload.camera_gameplay.fade_in()
	else:
		if not GlobalAutoload.is_load_level:
			GlobalAutoload.load_threaded_level(GlobalAutoload.first_level)
			await get_tree().create_timer(1.0).timeout
			GlobalAutoload.change_level_to(GlobalAutoload.first_level)
			GlobalAutoload.camera_gameplay.fade_in()
		else:
			GlobalAutoload.load_threaded_level(GlobalAutoload.load_level_name)
			await get_tree().create_timer(1.0).timeout
			GlobalAutoload.change_level_to(GlobalAutoload.load_level_name)
			await get_tree().create_timer(0.5).timeout
			GlobalAutoload.restore_load_data()
			await get_tree().create_timer(0.2).timeout
			GlobalAutoload.camera_gameplay.fade_in()
	
	
func popup_save_window():
	%panel_save.popup()
