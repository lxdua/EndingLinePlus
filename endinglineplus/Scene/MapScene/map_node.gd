extends Node2D
class_name MapNode

@export var road_root: Node2D
@export var station_root: Node2D

func get_road(id: int):
	return road_root.get_node("R"+str(id))

func get_road_list():
	return road_root.get_children()

func get_station(id: int):
	return station_root.get_node("S"+str(id))

func get_station_list():
	return station_root.get_children()
