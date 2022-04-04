extends KinematicBody
# EXPORT VARIABLES #
export var speed := 10.0
export var fall_acceleration := 75
export var jump_strenght := 5.0
export var gravity := 50
# SCRIPT VARIABLES
var _velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN

onready var _head: Spatial = $Head

# SYSTEM VARIABLES

func _ready():
	pass # Replace with function body.


# lets proccess basic physics
func _physics_process(delta) -> void:
	
	_count_move(delta)
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	
	
##
#   PRIVATE SECTION
##	
	
func _move_dir() -> Vector3:
	var move_direction = Vector3()
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_foward")
	return move_direction.rotated(Vector3.UP,  global_transform.basis.get_euler().y).normalized()

func _count_move(delta) ->void:
	var direction = _move_dir()
	_velocity.x = direction.x * speed
	_velocity.z = direction.z * speed
	_velocity.y -= 	gravity * delta
	
