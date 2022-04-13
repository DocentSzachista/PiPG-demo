extends Reference

func get_name() -> String:
	return "calc"

func run(args: Array, enviroment: CommandEnviroment) -> CommandReturnValue:
	var ret_val := CommandReturnValue.new()
	if len(args) == 0:
		ret_val.is_valid = false
		ret_val.result = "No expression was provided"
	else:
		var expression_text := ""
		for arg in args:
			if arg != "":
				expression_text += "%s " % arg
		
		var expr := Expression.new()
		var keys := enviroment._variables.keys()
		if expr.parse(expression_text, keys) != OK:
			ret_val.is_valid = false
			ret_val.result = expr.get_error_text()
		else:
			var inputs := [];
			for key in keys:
				var key_val := enviroment.get_variable(key)
				inputs.append(float(key_val) if key_val.is_valid_float() else key_val)
			var expr_result = expr.execute(inputs)
			if expr.has_execute_failed():
				ret_val.is_valid = false
				ret_val.result = expr.get_error_text()
			else:
				ret_val.is_valid = true
				ret_val.result = String(expr_result)
	return ret_val
