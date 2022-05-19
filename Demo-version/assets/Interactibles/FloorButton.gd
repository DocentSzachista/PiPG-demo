extends Spatial

const ON_MATERIAL := preload("res://prototype-graphics/FloorButtonOn.tres")
const OFF_MATERIAL := preload("res://prototype-graphics/FloorButtonOff.tres")

signal toggled(state)

export(float) var min_mass := 1

onready var area := $Area
onready var button_mesh := $GFX/MeshInstance2

var state := false

func _check_state() -> void:
	var current_mass := 0
	for body in area.get_overlapping_bodies():
		if body is RigidBody:
			current_mass += body.mass
		elif body is KinematicBody:
			current_mass = min_mass + 1
	if current_mass >= min_mass:
		if not state:
			state = true
			button_mesh.material_override = ON_MATERIAL
			emit_signal("toggled", state)
	else:
		if state:
			state = false
			button_mesh.material_override = OFF_MATERIAL
			emit_signal("toggled", state)

func _on_Area_body_entered(_body: Node) -> void:
	_check_state()

func _on_Area_body_exited(_body: Node) -> void:
	_check_state()
