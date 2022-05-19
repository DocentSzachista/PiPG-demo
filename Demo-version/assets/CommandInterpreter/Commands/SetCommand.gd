extends Reference

func get_name() -> String:
	return "set"

func get_help() -> String:
	return "set <NAME> <VALUE>: sets the variable"

func run(args: Array, enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	if len(args) < 2:
		ret_val.is_valid = false
		ret_val.result = "set requires 2 arguments, the name and the value of the variable"
	else:
		if args[0].begins_with("_"):
			ret_val.is_valid = false
			ret_val.result = "variable names can't start with the underscore '_'"
		else:
			enviroment.set_variable(args[0], args[1])
			ret_val.is_valid = true
	return ret_val
