extends Node2D
class_name StationOnMap

@export var id: int
@export var adjacent_road_list: Array[RoadOnMap]

@onready var map_scene: = get_tree().get_first_node_in_group("MapScene")

func expand_horizons():
	show()
	for road in adjacent_road_list:
		road.expand_horizons(self)

func hide_self_and_road():
	hide()
	for road in adjacent_road_list:
		road.hide()

func _on_station_texture_button_pressed() -> void:
	map_scene.destination_id = id

func _ready() -> void:
	hide_self_and_road()
