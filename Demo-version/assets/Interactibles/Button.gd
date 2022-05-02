extends Area

export var interactible_text : String
export var interactible_path : NodePath
var interactible_obj

func _ready():
	add_to_group("interactibles")
	interactible_obj = get_node(interactible_path)
	assert(interactible_obj.has_method("accept_interaction") == true, "Object %s has no 'accept_interaction()' method" % interactible_obj.name)

	
func interact()->void:
	_perform_interaction()


func _perform_interaction()->void:
	interactible_obj.accept_interaction()

