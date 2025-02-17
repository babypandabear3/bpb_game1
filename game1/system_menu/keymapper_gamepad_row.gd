extends PanelContainer

signal inputmap_updated

var action := ""
var action_event
var original_event

@onready var lbl_action = $HBoxContainer/lbl_action
@onready var btn_event = $HBoxContainer/btn_event
@onready var timer_input = $timer_input
@onready var lbl_input: Label = $HBoxContainer/lbl_input

var reading_input := false
var wait_to_start := false

func _ready():
	lbl_input.hide()
	pass # Replace with function body.

func set_action(_action):
	action = _action
	lbl_action.text = action
	var events = InputMap.action_get_events(action)
	for e in events:
		var event_as_text = e.as_text()
		if "Joypad" in event_as_text:
			btn_event.text = get_humanized_event(e)
			action_event = e
			original_event = e
		
			
func set_event(_event):
	if _event is InputEventJoypadMotion:
		if _event.axis == 0:
			if _event.axis_value > 0.0:
				_event.axis_value = 1.0
			else:
				_event.axis_value = -1.0
		elif _event.axis == 1:
			if _event.axis_value > 0.0:
				_event.axis_value = 1.0
			else:
				_event.axis_value = -1.0
		if _event.axis == 2:
			if _event.axis_value > 0.0:
				_event.axis_value = 1.0
			else:
				_event.axis_value = -1.0
		elif _event.axis == 3:
			if _event.axis_value > 0.0:
				_event.axis_value = 1.0
			else:
				_event.axis_value = -1.0
				
	btn_event.text = get_humanized_event(_event)
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
		
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		set_event(event)
		stop_reading_input()
		return

				
func get_humanized_event(_event):
	var ret = ""
	var keymaps = {}
	var text = _event.as_text()
	
	keymaps["Nintendo Y"] = "XBOX X / Nintendo Y"
	keymaps["Nintendo X"] = "XBOX Y / Nintendo X"
	keymaps["Nintendo B"] = "XBOX A / Nintendo B"
	keymaps["Nintendo A"] = "XBOX B / Nintendo A"
	keymaps["Sony L1"] = "L1 / Left Shoulder"
	keymaps["Sony R1"] = "R1 / Right Shoulder"
	keymaps["Sony L2"] = "L2 / XBOX LT"
	keymaps["Sony R2"] = "R2 / XBOX RT"
	keymaps["Xbox Menu"] = "Start / XBOX Menu"
	keymaps["Xbox Back"] = "Select / XBOX Back"
	keymaps["D-pad Left"] = "D-pad Left"
	keymaps["D-pad Right"] = "D-pad Right"
	keymaps["D-pad Up"] = "D-pad Up"
	keymaps["D-pad Down"] = "D-pad Down"
		
	for k in keymaps.keys():
		if text.contains(k):
			ret = keymaps[k]
			
	if _event is InputEventJoypadMotion:
		if _event.axis == 0:
			if _event.axis_value > 0.0:
				ret = "Left Stick - Right"
			else:
				ret = "Left Stick - Left"
		elif _event.axis == 1:
			if _event.axis_value > 0.0:
				ret = "Left Stick - Down"
			else:
				ret = "Left Stick - Up"
		if _event.axis == 2:
			if _event.axis_value > 0.0:
				ret = "Right Stick - Right"
			else:
				ret = "Right Stick - Left"
		elif _event.axis == 3:
			if _event.axis_value > 0.0:
				ret = "Right Stick - Down"
			else:
				ret = "Right Stick - Up"
				
	if ret == "":
		print(text)
		ret = text
	return ret


func _on_btn_event_button_down() -> void:
	start_reading_input()
