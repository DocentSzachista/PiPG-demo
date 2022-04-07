extends VBoxContainer

onready var console := $RichTextLabel

var _interpreter := Interpreter.new()
var _env := CommandEnviroment.new()
var _commands := [
	preload("res://assets/CommandInterpreter/Commands/EchoCommand.gd").new(),
	preload("res://assets/CommandInterpreter/Commands/SetCommand.gd").new(),
	preload("res://assets/CommandInterpreter/Commands/GetCommand.gd").new(),
	preload("res://assets/CommandInterpreter/Commands/CalcCommand.gd").new(),
]

func _display_text(text: String) -> void:
	console.text += "%s\n" % text

func _ready() -> void:
	_interpreter.load_commands(_commands)
	_env.set_display_callback(funcref(self, "_display_text"))
	_interpreter.set_enviroment(_env)

func _on_LineEdit_text_entered(new_text: String) -> void:
	$LineEdit.text = ""
	console.text += "-> %s\n" % new_text
	_interpreter.execute(new_text)
