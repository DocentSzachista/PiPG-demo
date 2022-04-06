extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _raycast := $InteractionRayCast

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if  _raycast.is_colliding():
		print("cos \n 1")
	else:
		print("Not coliding")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
