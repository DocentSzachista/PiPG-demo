extends Spatial

export var drop_distance := 1.5
export var max_grab_mass := 2.0
export var velocity_mult := 1.0
export(NodePath) var player_path

onready var _raycast := $InteractionRayCast
#onready var _interaction_label = get_node("/root/Main/Control/InteractionLabel")

var _picked_object : RigidBody
var _last_interact_obj = null
var _intract_pressed := false
onready var _player := get_node(player_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_text(null) # Replace with function body.

func _input(event: InputEvent) -> void:
	if _player._has_input:
		_intract_pressed = event.is_action_pressed("interact")

func _physics_process(_delta : float):
	if _picked_object == null:
		_check_interactions()
	else:
		_update_held_rb()
	

# check for items that can be interacted with 
func _check_interactions()->void:
	if  _raycast.is_colliding() :
		var collider = _raycast.get_collider()
		if   collider is RigidBody:
			
			if collider.mass <= max_grab_mass:
				_set_text("Press E to pickup box")
				if _intract_pressed:
					_picked_object = collider as RigidBody
					_raycast.enabled = false
			else :
				_set_text("Too heavy")
		elif collider.is_in_group("interactibles")  && collider.has_method("interact") :
			_set_text("Press E to interact with %s" %collider.interactible_text)
			if _intract_pressed:
				collider.interact(_player)
	else:
		_set_text(null)
	_intract_pressed = false



# Updates the held rigidbody velocity and held state
func _update_held_rb() -> void:
	var direction := global_transform.origin - _picked_object.global_transform.origin
	if direction.length() > drop_distance or _intract_pressed:
		_drop_rb()
	else:
		_picked_object.linear_velocity =  direction * velocity_mult / 2
	_intract_pressed = false

# Drops the held rigidbody
func _drop_rb() -> void:
	_picked_object = null
	_raycast.enabled = true


func _set_text(text)->void:
	pass
#	if text == null:
#		_interaction_label.set_text("")
#		_interaction_label.set_visible(false)
#	else:
#		_interaction_label.set_text(text)  
#		_interaction_label.set_visible(true)

