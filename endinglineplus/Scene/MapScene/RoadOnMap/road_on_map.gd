extends Node2D
class_name RoadOnMap

@export var road_line: Line2D

@export var id: int
@export var station_u: StationOnMap
@export var station_v: StationOnMap
@export var length: float

var can_pass: bool

func expand_horizons(station: StationOnMap):
	show()
	if station == station_u:
		station_v.show()
	else:
		station_u.show()

func _ready() -> void:
	if station_u == null and station_v == null:
		queue_free()
	road_line.clear_points()
	road_line.add_point(station_u.global_position)
	road_line.add_point(station_v.global_position)
	length = (station_u.global_position - station_v.global_position).length()
	hide()
