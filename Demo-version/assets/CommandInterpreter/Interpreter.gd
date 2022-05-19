class_name Interpreter
extends Reference

const ARG_REGEX_TEXT = "[^\\s'\"]+|\"[^\"]*\"|'[^']*'"

var _commands := {} # Registered commands
var _enviroment : CommandEnviroment # The interpreter's enviroment (eg. the terminal)
var _arg_regex : RegEx

var _error := false # Was threre a runtime error

# Class that stores the result of a line parsing operation
class ParseResult:
	var valid : bool
	var error_text : String
	var command_name : String
	var arguments : Array

#
# PRIVATE METHODS
#

# Trims the argument form ' and " characters if required
func _trim_arg(word: String) -> String:
	return word.trim_prefix("'").trim_suffix("'").trim_prefix('"').trim_suffix('"')

# Parses the line as a command
func _parse_line(line: String) -> ParseResult:
	var res := ParseResult.new()
	var matches := _arg_regex.search_all(line)
	var command_name := _trim_arg(matches[0].get_string())
	
	if not _commands.has(command_name):
		res.valid = false
		res.error_text = "'%s' is not a valid command" % command_name
		return res
	
	res.command_name = command_name
	var args := []
	var skip_first = true
	for argument in matches:
		if skip_first:
			skip_first = false
			continue
		var arg_text = _trim_arg(argument.get_string())
		# Allow for comment chaining
		if arg_text.begins_with("$"):
			args.append(_execute_line(arg_text.trim_prefix("$")))
		else:
			args.append(arg_text)
	res.arguments = args
	res.valid = true
	return res

# Preprocesses the script
# Returns the logical lines
func _preprocess(text: String) -> Array:
	var comment_regex := RegEx.new()
	#warning-ignore: RETURN_VALUE_DISCARDED
	comment_regex.compile("#.*")
	# Remove comments
	text = comment_regex.sub(text, "", true)
	# Split to lines
	var lines := text.split(";", false)
	var result := []
	for line in lines:
		result.append(line.strip_edges())
	return result

# Executes a single logical script line
# Can have nested commands resolved as arguments by adding '$' before the inner command
func _execute_line(line: String) -> String:
	line = line.strip_edges()
	var result : ParseResult
	var ret_val := ""
	if _arg_regex.compile(ARG_REGEX_TEXT) == OK:
		result = _parse_line(line)
	else:
		result.valid = false
		result.error_text = "Parser error"
	if result.valid:
		var command = _commands[result.command_name]
		var command_result : CommandReturnValue = command.run(result.arguments, _enviroment)
		if command_result.is_valid:
			ret_val = command_result.result
		else:
			_enviroment.display_text("ERROR (in '%s'): %s" % [result.command_name, command_result.result])
			_error = true
	else:
		assert(_enviroment, "The interpreter has no set enviroment")
		_enviroment.display_text("ERROR: %s" % result.error_text)
		_error = true
	return ret_val

#
# PUBLIC METHODS
#

# Loads commands from an array of objects. They have to have:
# A 'run' method that accepts an Array of arguments and a optional enviroment and returs a CommandReturnValue
# A 'get_name' method that returns the command's name
# Objects can use duck typing
func load_commands(command_array: Array) -> void:
	for command in command_array:
		assert(command.has_method("get_name"), "Command has to have a 'get_name' method")
		assert(command.has_method("run"), "Command '%s' has to have a 'run' method" % command.get_name())
		assert(command.has_method("get_help"), "Command '%s' has to have a 'get_help' method" % command.get_name())
		_commands[command.get_name()] = command

# Sets the current enviroment on which the commands will be executed on
func set_enviroment(enviroment: CommandEnviroment) -> void:
	_enviroment = enviroment

# Executes a string as a single command
# Returns a string as the command return value
func execute(script: String) -> void:
	_arg_regex = RegEx.new()
	_error = false
	var lines := _preprocess(script)
	for line in lines:
		if _error:
			break;
		var res := _execute_line(line)
		if res != "":
			_enviroment.display_text(res)






