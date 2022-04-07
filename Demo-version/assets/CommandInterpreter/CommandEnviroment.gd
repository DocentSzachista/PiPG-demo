class_name CommandEnviroment
extends Reference

var _display_callback : FuncRef

# Sets the display callback that will be used to display results
func set_display_callback(function: FuncRef) -> void:
	_display_callback = function

# Displays the required text using the set callback
func display_text(text: String) -> void:
	assert(_display_callback, "Display callback was not set and is required")
	_display_callback.call_func(text)




