class_name MenuWindow
extends Control

@export var focus_on : NodePath
var main_node : Control

func popup():
	show()
	var control = get_node_or_null(focus_on) 
	if control :
		control.grab_focus()
		control.grab_click_focus()
