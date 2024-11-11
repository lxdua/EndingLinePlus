extends Node
class_name Buff

@export var buff_name: String
@export var icon: Texture
@export_multiline var buff_content: String

## 获得这个buff时
func activate():
	pass

## 丢失这个buff时
func deactivate():
	pass

func _ready() -> void:
	activate()
