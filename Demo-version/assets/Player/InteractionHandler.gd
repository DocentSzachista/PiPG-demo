extends Spatial

export var drop_distance := 1.5
export var max_grab_mass := 2.0
export var velocity_mult := 1.0

onready var _raycast := $InteractionRayCast
onready var _interaction_label = get_node("/root/Main/Control/InteractionLabel")

var _picked_object : RigidBody
var _last_interact_obj = null
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_text(null) # Replace with function body.

func _physics_process(_delta : float):
	if _picked_object == null:
		_check_interactions()
	else:
		_update_held_rb()
	

# check for items that can be interacted with 
func _check_interactions()->void:

	if  _raycast.is_colliding() :
		#print("colide")
		var collider = _raycast.get_collider()
		if   collider is RigidBody:
			_picked_object = _raycast.get_collider() as RigidBody
			_raycast.enabled = false
		elif collider.is_in_group("interactibles")  && collider.has_method("interact") :
			_set_text(collider.interactible_text)
			if Input.is_action_just_pressed("interact"):
				collider.interact()
	else:
		print("Not coliding")
		_set_text(null)



# Updates the held rigidbody velocity and held state
func _update_held_rb() -> void:
	var direction := global_transform.origin - _picked_object.global_transform.origin
	if direction.length() > drop_distance:
		_drop_rb()
	else:
		_picked_object.linear_velocity =  direction * velocity_mult  

# Drops the held rigidbody
func _drop_rb() -> void:
	_picked_object = null
	_raycast.enabled = true


func _set_text(text)->void:
	if text == null:
		_interaction_label.set_text("")
		_interaction_label.set_visible(false)
	else:
		_interaction_label.set_text("Press E to interact with %s" % text)  
		_interaction_label.set_visible(true)

