extends StaticBody

func _ready() -> void:
	toggle_bridge(false)

func toggle_bridge(state: bool) -> void:
	visible = state
	$CollisionShape.disabled = not state

