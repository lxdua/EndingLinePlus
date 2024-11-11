@tool
extends Node2D

const STATION_ON_MAP = preload("res://Scene/MapScene/StationOnMap/station_on_map.tscn")
const ROAD_ON_MAP = preload("res://Scene/MapScene/RoadOnMap/road_on_map.tscn")

@export_subgroup("默认")
@export_color_no_alpha var color: Color
@export var map_node: MapNode
@export var road_root: Node2D
@export var station_root: Node2D
@export var marker: Marker2D
@export var station_idx: int = 0
@export var road_idx: int = 0


@export_subgroup("保存")
@export var scene_name: String = "地图名"
@export_tool_button("保存地图", "Node2D")
var save_map: = func():
	change_owner(map_node)
	var scene: = PackedScene.new()
	scene.pack(map_node)
	var path = "res://Resource/Map/"+scene_name+".tscn"
	if ResourceSaver.save(scene, path) == OK:
		prints("\n", scene, "保存成功:", path, "\n")
	else:
		prints("\n", scene, "保存失败", "\n")
	change_owner(get_tree().edited_scene_root)


@export_subgroup("车站")
@export_tool_button("添加车站", "Node2D")
var add_station: = func():
	var new_station: = STATION_ON_MAP.instantiate()
	station_root.add_child(new_station)
	new_station.owner = get_tree().edited_scene_root
	new_station.global_position = marker.global_position
	new_station.name = "S"+str(station_idx)
	new_station.id = station_idx
	station_idx += 1
	prints("在", marker.global_position, "添加了车站")

@export_subgroup("道路")
@export var station_u_id: int
@export var station_v_id: int

@export_tool_button("添加道路", "Node2D")
var add_road: = func():
	if station_u_id == station_v_id:
		return
	var new_road: = ROAD_ON_MAP.instantiate()
	road_root.add_child(new_road)
	new_road.owner = get_tree().edited_scene_root
	new_road.station_u = station_root.get_node("S"+str(station_u_id))
	new_road.station_v = station_root.get_node("S"+str(station_v_id))
	update_road_stats(new_road)
	new_road.name = "R"+str(road_idx)
	new_road.id = road_idx
	road_idx += 1
	if not new_road.station_u.adjacent_road_list.has(new_road):
		new_road.station_u.adjacent_road_list.append(new_road)
	if not new_road.station_v.adjacent_road_list.has(new_road):
		new_road.station_v.adjacent_road_list.append(new_road)
	prints("在", str(new_road.station_u), "和", str(new_road.station_v), "之间添加了道路")


@export_subgroup("一键")
@export_tool_button("清除所有", "Callable")
var clear_node: = func():
	for node in station_root.get_children():
		node.free()
	for node in road_root.get_children():
		node.free()
	station_idx = 0
	road_idx = 0

@export_tool_button("清除非法道路", "Callable")
var clear_illegal_road: = func():
	for road: RoadOnMap in road_root.get_children():
		if road.station_u.is_inside_tree() and road.station_v.is_inside_tree():
			continue
		road.queue_free()

@export_tool_button("重新编号", "Callable")
var renumber_all: = func():
	station_idx = station_root.get_child_count()
	for i in station_idx:
		var station: = station_root.get_child(i)
		var old_name: String = station.name
		station.name = old_name[0]+str(i)
	road_idx = road_root.get_child_count()
	for i in road_idx:
		var road: = road_root.get_child(i)
		var old_name: String = road.name
		road.name = old_name[0]+str(i)


func change_owner(new_owner: Node):
	station_root.owner = new_owner
	for child in station_root.get_children():
		child.owner = new_owner
	road_root.owner = new_owner
	for child in road_root.get_children():
		child.owner = new_owner

func update_road_stats(road: Node2D):
	var station_u: = station_root.get_node("S"+str(station_u_id))
	var station_v: = station_root.get_node("S"+str(station_v_id))
	if station_u == null and station_v == null:
		return
	road.road_line.clear_points()
	road.road_line.add_point(station_u.global_position)
	road.road_line.add_point(station_v.global_position)
