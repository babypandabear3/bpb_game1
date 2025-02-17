class_name Model
extends Node3D

signal animation_finished(anim)

var animplayer : AnimationPlayer
var direction = Vector3.FORWARD
var last_anim = ""
var body : CharBody

func _ready() -> void:
	for obj in get_children():
		if obj is AnimationPlayer:
			animplayer = obj
			animplayer.animation_finished.connect(_animation_finished)
			animplayer.playback_default_blend_time = 0.2
	
func set_charbody(value):
	body = value
	if is_instance_valid(body):
#			if not body.jumped.is_connected(_jumped):
		body.jumped.connect(_jumped)
#			if not body.airborne_entered.is_connected(_airborne_entered):
		body.airborne_entered.connect(_airborne_entered)
#			if body.landing_entered.is_connected(_landing_entered):
		body.landing_entered.connect(_landing_entered)
#			if body.run_entered.is_connected(_run_entered):
		body.run_entered.connect(_run_entered)
#			if body.stop_entered.is_connected(_stop_entered):
		body.stop_entered.connect(_stop_entered)
	
func register_looped_animations(anim):
	var animres = animplayer.get_animation(anim)
	animres.loop_mode = Animation.LOOP_LINEAR
	
func play_anim(anim : String = ""):
	if animplayer and anim != "":
		if animplayer.has_animation(anim) and last_anim != anim:
			animplayer.play(anim)
			last_anim = anim
			
func restart_anim(anim:String =""):
	if anim != "":
		last_anim = ""
		play_anim(anim)

func seek_anim(time:float = 0.0):
	if is_instance_valid(animplayer):
		animplayer.seek(time)
	
func queue_anim(anim:String = ""):
	if is_instance_valid(animplayer) and anim != "":
		animplayer.queue(anim)
		
func _process(_delta: float) -> void:
	if body:
		direction = body.last_major_direction
	var bas = Basis.looking_at(-direction)
	global_basis = global_basis.slerp(bas, 0.5)
	
func _animation_finished(anim : String):
	animation_finished.emit(anim)
		
func _jumped():
	restart_anim("Jump")
	queue_anim("Jump_Idle")

func _airborne_entered():
	play_anim("Jump_Idle")

func _landing_entered():
	play_anim("Jump_Land")

func _run_entered():
	if animplayer.current_animation == "Jump_Land":
		queue_anim("Run")
	else:
		play_anim("Run")
	
func _stop_entered():
	if animplayer.current_animation == "Jump_Land":
		queue_anim("Idle")
	else:
		play_anim("Idle")
