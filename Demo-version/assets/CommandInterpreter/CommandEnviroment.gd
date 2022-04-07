class_name CommandEnviroment
extends Reference

var _display_callback : FuncRef
var _variables := {}

# Sets the display callback that will be used to display results
func set_display_callback(function: FuncRef) -> void:
	_display_callback = function

# Displays the required text using the set callback
func display_text(text: String) -> void:
	assert(_display_callback, "Display callback was not set and is required")
	_display_callback.call_func(text)

# Sets a value of a variable (or creates it if it didn't exist)
func set_variable(name: String, value: String) -> void:
	_variables[name] = value

# Returns the value of a variable (or an empty string if it didn't exist)
func get_variable(name: String) -> String:
	return _variables.get(name, "")
