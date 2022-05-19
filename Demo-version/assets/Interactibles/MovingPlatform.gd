extends KinematicBody



onready var _animation_player = $AnimationPlayer
export var animation_name = "move"
var _play_return = false


func _ready():
	add_to_group("interactibles")
	assert(_animation_player.has_animation(animation_name), "Animation: %s doesn't exist" % animation_name)

func accept_interaction()->void:
	 _move_platform() 

func _move_platform():
	if _animation_player.is_playing():
		return 
	elif _play_return:
		_animation_player.play_backwards("move")
	else:
		_animation_player.play("move")
	_play_return = not _play_return
