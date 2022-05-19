extends VBoxContainer

onready var console := $RichTextLabel

var _interpreter := Interpreter.new()
var _env := CommandEnviroment.new()
export(Array, Script) var _commands := []

func _display_text(text: String) -> void:
	console.text += "%s\n" % text

func _ready() -> void:
	for i in len(_commands):
		_commands[i] = _commands[i].new()
	
	_commands.push_front(preload("res://assets/CommandInterpreter/Commands/HelpCommand.gd").new())
	_commands[0].commands = _commands
	_interpreter.load_commands(_commands)
	_env._variables["_root"] = get_tree()
	_env.set_display_callback(funcref(self, "_display_text"))
	_interpreter.set_enviroment(_env)

func _on_LineEdit_text_entered(new_text: String) -> void:
	$LineEdit.text = ""
	console.text += "-> %s\n" % new_text
	_interpreter.execute(new_text)
