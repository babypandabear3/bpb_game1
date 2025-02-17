@tool
class_name Bpb_Menu_Tabs
extends MenuButton

var plugin : EditorPlugin

var tabs

func _ready() -> void:
	var popup = get_popup()
	popup.index_pressed.connect(_popup_index_pressed)
	pass # Replace with function body.

func _popup_index_pressed(index):
	var popup = get_popup()
	var path = popup.get_item_text(index)
	EditorInterface.open_scene_from_path(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tmp_tab := EditorInterface.get_open_scenes()
	if tabs != tmp_tab:
		tabs = tmp_tab
		update_tabs()
	pass

func update_tabs():
	var popup : PopupMenu = get_popup()
	popup.clear()
	for t in tabs:
		popup.add_item(t)
	
