extends Node
class_name TimeManager

var time_scale: float = 1.0

var current_time: float:
	set(v):
		current_time = v
		date = current_time / 1440
		var clock: int = current_time - date * 1440
		hour = clock / 60
		minute = clock % 60

var start_time: int = 5*60+30 + 24*60

## 第几天
signal date_updated(v: int)
var date: int:
	set(v):
		if v == date: return
		date = v
		date_updated.emit(date)

## 当前小时
signal hour_updated(v: int)
var hour: int:
	set(v):
		if v == hour: return
		hour = v
		hour_updated.emit(hour)

## 当前分钟
signal minute_updated(v: int)
var minute: int:
	set(v):
		if v == minute: return
		minute = v
		minute_updated.emit(minute)

func set_time_scale(v: float):
	time_scale = v

func _ready() -> void:
	current_time = start_time

func _physics_process(delta: float) -> void:
	current_time += delta * time_scale
