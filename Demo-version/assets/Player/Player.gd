extends KinematicBody
# EXPORT VARIABLES #
export var speed := 10.0
export var move_acceleration := 10.0
export var in_air_acceleration = 1.0
export var jump_height := 2.5
export var gravity := 20.0
export var sensitivity := 1.0
export var push_strength = 2.0
# SCRIPT VARIABLES
var _velocity = Vector3.ZERO

var _jumped = false
var lookSensitivity = 10.0
var sensivity_factor = 0.35
onready var _head := $Head

# SYSTEM VARIABLES

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * sensitivity * sensivity_factor))
		_head.rotate_x(deg2rad(-event.relative.y * sensitivity * sensivity_factor) )
		_head.rotation.x = clamp(_head.rotation.x, deg2rad(-90), deg2rad(90))
	if event.is_action_pressed("jump"):
		_jumped = true


func _physics_process(delta) -> void:
	
	var snap = Vector3.ZERO	
	var acc = in_air_acceleration
	var curr_y = _velocity.y
	_velocity.y = 0
	
	
	if is_on_floor():
		acc = move_acceleration
		if _jumped :
			curr_y = sqrt(2 * jump_height * gravity)
			_jumped = false
	else:
			curr_y -= gravity * delta
	
	#	
	_velocity = _velocity.linear_interpolate( _get_move_dir() * speed, acc * delta)
	_velocity.y = curr_y 	
	_velocity = move_and_slide_with_snap(_velocity, snap, Vector3.UP,  false, 4, PI/4, false)
	_push_rigid_bodies()
	
##
#   PRIVATE SECTION
##	

# function to process user movement direction
func _get_move_dir() -> Vector3:
	var move_direction = Vector3()
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_foward")
	return move_direction.rotated(Vector3.UP,  global_transform.basis.get_euler().y).normalized()

func _push_rigid_bodies() -> void:
	var push_force = _velocity * push_strength
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		if collision.collider is RigidBody:
			var rb : RigidBody = collision.collider
			if is_on_floor() and collision.normal.is_equal_approx(get_floor_normal()) or rb.mode != RigidBody.MODE_RIGID:
				continue
			rb.add_force(push_force, collision.normal)
