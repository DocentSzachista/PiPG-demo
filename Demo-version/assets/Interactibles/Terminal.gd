extends StaticBody

const interactible_text := "Terminal"

var enabled := false
var player : Player

onready var console := $ColorRect

func _ready() -> void:
	console.visible = false

func _toggle_state(enable: bool) -> void:
	player.toggle_controlls(not enable)
	enabled = enable
	console.visible = enable

func interact(player: Player) -> void:
	self.player = player
	_toggle_state(true)

func _unhandled_input(event: InputEvent) -> void:
	if enabled and event.is_action_pressed("ui_cancel"):
		_toggle_state(false)
