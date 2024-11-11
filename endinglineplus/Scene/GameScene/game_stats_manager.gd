extends Node
class_name GameStatsManager

enum GameMode { ESCAPE, BUILD }

var game_mode: GameMode

var current_train_speed: float


func _ready() -> void:
	choose_game_mode()

func choose_game_mode():
	var game_mode_arr: Array[GameMode] = [
		GameMode.ESCAPE,
		GameMode.BUILD,
		]
	game_mode = game_mode_arr.pick_random()
