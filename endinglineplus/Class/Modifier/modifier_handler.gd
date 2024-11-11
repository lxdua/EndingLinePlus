extends Node
class_name ModifierHandler

## 方便用的 给变量和变量改变信号
func get_modifier_result_intelligently(modifier_name: String, base: float, update_signal: Signal = Signal()):
	var modifier: ModifierRoot = get_modifier(modifier_name)
	if modifier == null:
		modifier = create_modifier(modifier_name)
	modifier.update_signal = update_signal
	return get_modifier_result(modifier_name, base)

func get_modifier_intelligently(modifier_name: String) -> ModifierRoot:
	var modifier: ModifierRoot = get_modifier(modifier_name)
	if modifier == null:
		modifier = create_modifier(modifier_name)
	return modifier

## 新建修饰器
func create_modifier(modifier_name: String):
	var modifier: ModifierRoot = ModifierRoot.new(modifier_name)
	add_child(modifier)
	return modifier

## 获取修饰器
func get_modifier(modifier_name: String) -> ModifierRoot:
	for modifier: ModifierRoot in get_children():
		if modifier.modifier_name == modifier_name:
			return modifier
	return null

## 使用修饰器
func get_modifier_result(modifier_name: String, base: float) -> float:
	var modifier: ModifierRoot = get_modifier(modifier_name)
	if not modifier:
		return base
	return modifier.get_modifier_value(base)
