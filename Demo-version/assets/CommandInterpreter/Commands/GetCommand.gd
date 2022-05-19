extends Reference

func get_name() -> String:
	return "get"

func run(args: Array, enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	if len(args) == 0:
		ret_val.is_valid = false
		ret_val.result = "get requires one argument with the variable name"
	else:
		ret_val.is_valid = true
		ret_val.result = enviroment.get_variable(args[0])
	return ret_val
