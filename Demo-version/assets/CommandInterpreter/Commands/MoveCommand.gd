extends Reference

func get_name() -> String:
	return "move"

func get_help() -> String:
	return "move <OBJ_NAME> <TO_OBJECT>: moves OBJ_NAME to TO_OBJECT"

func run(args: Array, enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	var root = enviroment._variables["_root"]
	if len(args) == 0:
		ret_val.is_valid = true
		ret_val.result = "Moveables:\n"
		for node in root.get_nodes_in_group("moveable"):
			ret_val.result += "\t%s\n" % node.name
		ret_val.result += "Move targets:\n"		
		for node in root.get_nodes_in_group("move_target"):
			ret_val.result += "\t%s\n" % node.name
		return ret_val
		
	if len(args) != 2:
		ret_val.is_valid = false
		ret_val.result = "move expects 2 arguments"
		return ret_val
	
	var obj = null
	var to = null
	for node in root.get_nodes_in_group("moveable"):
		if obj == null:
			if node.name == args[0]:
				obj = node
		if to == null:
			if node.name == args[1]:
				to = node
	if not to:
		for node in root.get_nodes_in_group("move_target"):
			if node.name == args[1]:
				to = node
				break
	
	if not obj:
		ret_val.is_valid = false
		ret_val.result = "object '%s' doesn't exist" % args[0]
		return ret_val
	
	if not to:
		ret_val.is_valid = false
		ret_val.result = "object '%s' doesn't exist" % args[1]
		return ret_val
	
	obj.global_transform.origin = to.global_transform.origin + Vector3(0, 2, 0)
	ret_val.is_valid = true
	ret_val.result = "moved!"
	return ret_val
