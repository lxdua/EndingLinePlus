extends Node
class_name GameScene

@onready var scene_layer: CanvasLayer = $SceneLayer
@onready var ui_layer: CanvasLayer = $UILayer
@onready var map_layer: CanvasLayer = $MapLayer
@onready var secondary_ui_layer: CanvasLayer = $SecondaryUILayer

@onready var map_scene: MapScene = $MapLayer/MapScene
@onready var map_scene_ui: Control = $SecondaryUILayer/MapSceneUI
@onready var fitment_ui: Control = $SecondaryUILayer/FitmentUI
@onready var train_stats_ui: Control = $SecondaryUILayer/TrainStatsUI


func _ready() -> void:
	hide_all_secondary_ui()
	load_scene_from_map()

#region 二级界面相关

func hide_all_secondary_ui():
	scene_layer.show()
	map_scene.hide()
	map_scene_ui.hide()
	fitment_ui.hide()
	train_stats_ui.hide()

func _on_under_button_ui_cargo_button_pressed() -> void:
	hide_all_secondary_ui()

func _on_under_button_ui_fitment_button_pressed() -> void:
	hide_all_secondary_ui()
	fitment_ui.show()

func _on_under_button_ui_health_button_pressed() -> void:
	hide_all_secondary_ui()
	train_stats_ui.show()

func _on_under_button_ui_price_button_pressed() -> void:
	hide_all_secondary_ui()

func _on_under_button_ui_map_button_pressed() -> void:
	hide_all_secondary_ui()
	scene_layer.hide()
	map_scene.show()
	map_scene_ui.show()

#endregion


#region 场景相关

func load_scene_from_map():
	var map_node: = map_scene.map_node
	await map_node.ready
	for station: StationOnMap in map_scene.map_node.get_station_list():
		station.station_scene_name

func hide_all_scene():
	for scene in scene_layer.get_children():
		scene.hide()

func get_station_scene_by_id(id: int) -> StationScene:
	for scene in scene_layer.get_children():
		if scene is StationScene:
			if scene.id == id:
				return scene
	return null

func get_road_scene_by_id(id: int) -> RoadScene:
	for scene in scene_layer.get_children():
		if scene is RoadScene:
			if scene.id == id:
				return scene
	return null

func change_scene_to_station(id: int):
	hide_all_scene()
	var station_scene: = get_station_scene_by_id(id)
	station_scene.show()

func change_scene_to_road(id: int):
	hide_all_scene()
	var road_scene: = get_road_scene_by_id(id)
	road_scene.show()

func _on_map_scene_set_out(id: int) -> void:
	await CurtainLayer.fade_in("离开车站")
	await change_scene_to_road(id)
	await get_tree().create_timer(1).timeout
	await CurtainLayer.fade_out()

func _on_map_scene_arrive(id: int) -> void:
	await CurtainLayer.fade_in("到达车站")
	await change_scene_to_station(id)
	await get_tree().create_timer(1).timeout
	await CurtainLayer.fade_out()

#endregion
