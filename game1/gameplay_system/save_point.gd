extends Area3D

var player_in := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in = true
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in = false
	
	
func _physics_process(_delta: float) -> void:
	if InputAutoload.interact_just_pressed and player_in:
		GlobalAutoload.main_game.popup_save_window()
