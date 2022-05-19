extends Reference

func get_name() -> String:
	return "echo"

func get_help() -> String:
	return "echo [ARGS...]: prints the arguments to the screen"

func run(args: Array, _enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	if len(args) == 0:
		ret_val.is_valid = false
		ret_val.result = "No arguments were passed"
	else:
		ret_val.is_valid = true
		for arg in args:
			if arg != "":
				ret_val.result += "%s " % arg
	return ret_val


