extends Control

@export_file("*.tscn") var prison_scene: String


func _on_start_pressed() -> void:
	CurtainLayer.curtain_change_scene(prison_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
