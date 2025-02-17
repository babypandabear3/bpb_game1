@tool
extends EditorPlugin

const MENU_TABS = preload("res://addons/bpb_list_of_scenes/menu_tabs.tscn")
var menu : Bpb_Menu_Tabs
func _enter_tree() -> void:
	menu = MENU_TABS.instantiate()
	menu.plugin = self
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, menu)


func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, menu)
	menu.free()
	# Clean-up of the plugin goes here.
	pass
