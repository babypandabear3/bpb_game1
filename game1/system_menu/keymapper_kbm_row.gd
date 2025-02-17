extends PanelContainer

signal inputmap_updated

var action := ""
var action_event
var original_event

@onready var lbl_action = $HBoxContainer/lbl_action
@onready var btn_event = $HBoxContainer/btn_event
@onready var timer_input = $timer_input
@onready var lbl_input:= $HBoxContainer/lbl_input

var reading_input := false

func _ready():
	lbl_input.hide()
	pass # Replace with function body.

func set_action(_action):
	action = _action
	lbl_action.text = action
	var events = InputMap.action_get_events(action)
	for e in events:
		original_event = e
		var event_as_text = e.as_text()
		
		if "Mouse Button" in event_as_text:
			btn_event.text = event_as_text
			action_event = e
		elif e is InputEventKey:
			btn_event.text = OS.get_keycode_string(e.physical_keycode)
			action_event = e
		
			
func set_event(_event):
	btn_event.text = _event.as_text()
	if _event is InputEventKey:
		btn_event.text = OS.get_keycode_string(_event.physical_keycode)
	InputMap.action_erase_event(action, action_event)
	action_event = _event
	InputMap.action_add_event(action, action_event)
	inputmap_updated.emit()

func _on_timer_input_timeout():
	stop_reading_input()
	
func start_reading_input():
	for obj in get_tree().get_nodes_in_group("keymapper"):
		obj.disabled = true
	timer_input.start()
	
	lbl_input.show()
	lbl_input.grab_focus()
	lbl_input.grab_click_focus()
	btn_event.hide()
	await get_tree().create_timer(0.2).timeout
	reading_input = true
	
func stop_reading_input():
	timer_input.stop()
	reading_input = false
	for obj in get_tree().get_nodes_in_group("keymapper"):
		obj.disabled = false
	await get_tree().create_timer(0.2).timeout
	lbl_input.hide()
	btn_event.show()
	btn_event.grab_focus()
	btn_event.grab_click_focus()

func _input(event):
	if not reading_input:
		return
		
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		set_event(event)
		stop_reading_input()
		return

	
func _on_btn_event_button_down() -> void:
	start_reading_input()
