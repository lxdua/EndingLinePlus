extends Node3D

@export_file("*.tscn") var game_scene: String



func _on_set_out_interaction_interact_signal() -> void:
	CurtainLayer.curtain_change_scene(game_scene, "少女祈祷中。。。")
