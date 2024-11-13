extends Node2D
class_name MapScene

@onready var time_manager: TimeManager = get_tree().get_first_node_in_group("TimeManager")
@onready var game_stats_manager: GameStatsManager = get_tree().get_first_node_in_group("GameStatsManager")

@export var train_on_map: Node2D

@export var map_pool: Array[PackedScene]

var map_node: MapNode

func _ready() -> void:
	add_map()
	floyd()
	initialize_train()

func _process(delta: float) -> void:
	drag_carema()

func _unhandled_input(event: InputEvent) -> void:
	camera_zoom(event)
	drag_camera(event)

func add_map():
	map_node = map_pool.pick_random().instantiate()
	train_on_map.add_sibling(map_node)

#region 最短路相关

## 邻接矩阵
var matrix: Array[Array]
## 最短路途径点
var mid_station: Array[Array]
## 最短路
var shortest_path: Array[int]

func floyd():
	# 初始化
	matrix.clear()
	mid_station.clear()
	var station_num: int = map_node.get_station_list().size()
	for i in range(station_num):
		matrix.append([])
		mid_station.append([])
		for j in range(station_num):
			matrix[i].append(INF)
			mid_station[i].append(-1)
	for i in range(station_num):
		matrix[i][i] = 0
	# 导入原路径
	for road in map_node.get_road_list():
		matrix[road.station_u.id][road.station_v.id] = road.length
		matrix[road.station_v.id][road.station_u.id] = road.length
	# 计算最短路
	for k in range(station_num):
		for x in range(station_num):
			for y in range(station_num):
				if matrix[x][y] > matrix[x][k] + matrix[k][y]:
					matrix[x][y] = matrix[x][k] + matrix[k][y]
					mid_station[x][y] = k

func update_shortest_path(start_station_id: int, end_station_id: int):
	shortest_path.clear()
	calc_mid(start_station_id, end_station_id)

func calc_mid(x: int, y: int):
	if x == y:
		return
	var k = mid_station[x][y]
	if k == -1:
		shortest_path.append(y)
	else:
		calc_mid(x, k)
		calc_mid(k, y)

#endregion

#region 行驶相关

signal destination_id_update(id: int)
var destination_id: int:
	set(v):
		destination_id = v
		destination_id_update.emit(v)
		print("新终点为", v)

signal set_out(id: int)
signal arrive(id: int)

var current_station_id: int
var next_station_id: int

## 下一站清单
var route_list: Array[int]

var is_driving: bool

var drive_tween: Tween

func drive():
	if matrix[current_station_id][destination_id] == INF:
		print("无法到达！")
		return
	update_shortest_path(next_station_id, destination_id)
	route_list = shortest_path
	if is_driving:
		print("更换目的地！")
	elif destination_id == current_station_id:
		print("已经到达！")
	else:
		print("出发！", route_list)
		is_driving = true
		set_out.emit(current_station_id)
		while not route_list.is_empty():
			next_station_id = route_list.pop_front()
			print("正在前往", next_station_id)
			drive_tween = train_on_map.create_tween()
			drive_tween.set_speed_scale(time_manager.time_scale)
			drive_tween.tween_property(
				train_on_map,
				"global_position",
				map_node.get_station(next_station_id).global_position,
				matrix[current_station_id][next_station_id] / game_stats_manager.current_train_speed,
				)
			await drive_tween.finished
			current_station_id = next_station_id
		is_driving = false
		arrive_station()

func arrive_station():
	map_node.get_station(current_station_id).expand_horizons()
	arrive.emit(current_station_id)

func initialize_train():
	train_on_map.global_position = map_node.get_station(current_station_id).global_position
	arrive_station()

func _on_map_scene_ui_set_out_button_pressed() -> void:
	print("set out!")
	drive()


#endregion

#region 摄像机相关

@onready var camera: Camera2D = $Camera

var is_following: bool = true
var is_draging: bool = false

var mouse_pos: Vector2

func camera_follow_train(delta: float):
	if is_following:
		camera.global_position = lerp(camera.global_position, train_on_map.global_position, delta)

func drag_camera(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_following = false
		mouse_pos = get_viewport().get_mouse_position()
		if event.is_pressed():
			is_draging = true
		else:
			is_draging = false

func drag_carema():
	if is_draging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		camera.position -= (get_viewport().get_mouse_position() - mouse_pos) / ((camera.zoom.x + camera.zoom.y) / 2.0)
		mouse_pos = get_viewport().get_mouse_position()
		camera.position_smoothing_enabled = false

func _on_follow_button_pressed() -> void:
	camera.global_position = train_on_map.global_position
	camera.position_smoothing_enabled = true
	is_following = true

func camera_zoom(event: InputEvent):
	if not is_visible_in_tree():
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if camera.zoom * 1.1 > Vector2(2.0,2.0):
				return
			camera.zoom *= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if camera.zoom / 1.1 < Vector2(0.5,0.5):
				return
			camera.zoom /= 1.1

#endregion
