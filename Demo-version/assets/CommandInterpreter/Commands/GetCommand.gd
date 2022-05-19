extends Reference

func get_name() -> String:
	return "get"

func get_help() -> String:
	return "get <VARIABLE NAME>: gets the variable value"

func run(args: Array, enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	if len(args) == 0:
		ret_val.is_valid = true
		for v in enviroment._variables:
			ret_val.result += '%s: %s\n' % [v, enviroment.get_variable(v)]
	else:
		ret_val.is_valid = true
		ret_val.result = enviroment.get_variable(args[0])
	return ret_val
