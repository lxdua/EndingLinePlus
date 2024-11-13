extends Node
class_name StationDeployer

static var station_scene_dict: Dictionary[String, PackedScene] = {
	"": null,
}

static func get_station_by_name(station_name: String) -> PackedScene:
	return station_scene_dict[station_name]
