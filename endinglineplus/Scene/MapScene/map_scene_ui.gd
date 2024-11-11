extends Control

@onready var map_content_container: PanelContainer = $MapContentContainer

@onready var title_label: Label = $MapContentContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var content_label: Label = $MapContentContainer/MarginContainer/VBoxContainer/ContentLabel

@onready var map_scene: Node2D = $"../../MapLayer/MapScene"
@onready var map_node: MapNode = map_scene.map_node

func show_content(title: String, content: String):
	title_label.text = title
	content_label.text = content
	map_content_container.show()

func _on_wait_button_pressed() -> void:
	map_content_container.hide()

signal set_out_button_pressed
func _on_set_out_button_pressed() -> void:
	map_content_container.hide()
	set_out_button_pressed.emit()

func _on_map_scene_destination_id_update(id: int) -> void:
	var station: StationOnMap = map_node.get_station(id)
	show_content(station.name, "666")
