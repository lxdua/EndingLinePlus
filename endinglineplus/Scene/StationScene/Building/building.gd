extends Node3D
class_name Building

func press_building():
	pass

func _on_building_area_mouse_entered() -> void:
	pass # Replace with function body.

func _on_building_area_mouse_exited() -> void:
	pass # Replace with function body.

func _on_building_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				press_building()
