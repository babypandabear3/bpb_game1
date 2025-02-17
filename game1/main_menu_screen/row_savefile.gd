extends PanelContainer

var main_node
var slot : int = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%btn_slot.focus_entered.connect(AudioplayerAutoload.sfx_hover)
	%btn_slot.mouse_entered.connect(AudioplayerAutoload.sfx_hover)
	%btn_slot.button_down.connect(AudioplayerAutoload.sfx_confirm)
	

func set_data(data):
	slot = data["slot"]
	%btn_slot.text = "Slot " + str(data["slot"])
	%lbl_level_name.text = data["level_name"]
	%lbl_time.text = data["time_str"]

func _on_btn_slot_button_down() -> void:
	main_node.row_button_action(slot)
