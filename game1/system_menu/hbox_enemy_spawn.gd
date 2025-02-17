class_name HBox_Enemy_Spawn
extends HBoxContainer


var enemy_type := ""
@onready var lbl_name: Label = $lbl_name
@onready var sb_qty: SpinBox = $sb_qty
@onready var lbl_count: Label = $lbl_count


func _ready() -> void:
	pass # Replace with function body.

func setup(_enemy_type):
	lbl_name.text = _enemy_type
	enemy_type = _enemy_type

func get_number():
	#return int(sb_qty.value)
	return int(lbl_count.text)
	
func get_type():
	return enemy_type


func _on_btn_up_button_up() -> void:
	update_count(1)
	pass # Replace with function body.


func _on_btn_down_button_up() -> void:
	update_count(-1)
	pass # Replace with function body.

func update_count(_par):
	var count = 0
	if lbl_count.text != "":
		count = int(lbl_count.text)
			
	count += _par
	lbl_count.text = str(count)
		
	
	
