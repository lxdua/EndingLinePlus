extends TextureRect

@onready var load_progress_bar: ProgressBar = $LoadProgressBar
@onready var power_progress_bar: ProgressBar = $PowerProgressBar
@onready var speed_label: Label = $SpeedLabel
@onready var money_label: Label = $MoneyLabel

@export var game_stats_manager: GameStatsManager

func _on_train_stats_manager_load_update() -> void:
	load_progress_bar.value = game_stats_manager.current_train_load / game_stats_manager.max_train_load

func _on_train_stats_manager_power_update() -> void:
	power_progress_bar.value = game_stats_manager.current_power / game_stats_manager.max_power

func _on_train_stats_manager_speed_update() -> void:
	speed_label.text = str(game_stats_manager.current_speed*10)

func _on_train_stats_manager_money_update() -> void:
	money_label.text = str(game_stats_manager.current_money)
