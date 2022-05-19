extends RigidBody

export(float) var reset_height := -10

onready var reset_point := global_transform.origin

func _physics_process(delta: float) -> void:
	if global_transform.origin.y <= reset_height:
		global_transform.origin = reset_point
		linear_velocity = Vector3.ZERO

