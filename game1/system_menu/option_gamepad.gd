extends PanelContainer

var main_scene

@onready var row_container = $ScrollContainer/row_container
@onready var keymapper_gamepad_row = preload("res://system_menu/keymapper_gamepad_row.tscn")

var actions = []

func _ready():
	await owner.ready
	actions = InputAutoload.gamepad_actions
	setup_gamepad_actions()
	
	
func setup_gamepad_actions():
	for action in actions:
		var row = keymapper_gamepad_row.instantiate()
		row_container.add_child(row)
		row.set_action(action)
		row.inputmap_updated.connect(main_scene._inputmap_updated)
		
func get_remap_data(res):
	for obj in row_container.get_children():
		var data = {}
		data["action"] = obj.action
		data["event_original"] = obj.original_event
		data["event_custom"] = obj.action_event
		res.data_gamepad.append(data)
	return res

func reset():
	for obj in row_container.get_children():
		obj.queue_free()
	await get_tree().physics_frame
	setup_gamepad_actions()
