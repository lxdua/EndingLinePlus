extends Node2D
class_name StationOnMap

@export var id: int

@onready var map_scene: = get_tree().get_first_node_in_group("MapScene")
@onready var map_node: MapNode = map_scene.map_node

var can_arrive: bool

func expand_horizons():
	show()
	for road: RoadOnMap in map_node.get_road_list():
		if road.station_u == self:
			road.expand_horizons(self)

func hide_self_and_road():
	hide()
	for road: RoadOnMap in map_node.get_road_list():
		if road.station_u == self:
			road.hide()

func _on_station_texture_button_pressed() -> void:
	map_scene.destination_id = id

func _ready() -> void:
	hide_self_and_road()
