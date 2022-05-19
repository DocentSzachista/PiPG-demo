extends Reference

var commands := []

func get_name() -> String:
	return "help"

func get_help() -> String:
	return "help [command_name]: print the help information"

func run(args: Array, _enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	if len(args) == 0:
		ret_val.is_valid = true
		for cmd in commands:
			ret_val.result += "%s\n" % cmd.get_help()
	else:
		for cmd in commands:
			if cmd.get_name() == args[0]:
				ret_val.is_valid = true
				ret_val.result = cmd.get_help()
				return ret_val
		ret_val.is_valid = false
		ret_val.result = "'%s' is no a command name"
	return ret_val
