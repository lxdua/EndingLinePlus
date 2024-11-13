extends TextureRect


signal health_button_pressed
@export var health_animated_sprite: AnimatedSprite2D
func _on_health_button_pressed() -> void:
	health_button_pressed.emit()
func _on_health_button_mouse_entered() -> void:
	health_animated_sprite.play("normal")
func _on_health_button_mouse_exited() -> void:
	health_animated_sprite.play_backwards("normal")

signal price_button_pressed
@export var price_animated_sprite: AnimatedSprite2D
func _on_price_button_pressed() -> void:
	price_button_pressed.emit()
func _on_price_button_mouse_entered() -> void:
	price_animated_sprite.play("normal")
func _on_price_button_mouse_exited() -> void:
	price_animated_sprite.play_backwards("normal")

signal map_button_pressed
@export var map_animated_sprite: AnimatedSprite2D
func _on_map_button_pressed() -> void:
	map_button_pressed.emit()
func _on_map_button_mouse_entered() -> void:
	map_animated_sprite.play("normal")
func _on_map_button_mouse_exited() -> void:
	map_animated_sprite.play_backwards("normal")

signal cargo_button_pressed
@export var cargo_animated_sprite: AnimatedSprite2D
func _on_cargo_button_pressed() -> void:
	cargo_button_pressed.emit()
func _on_cargo_button_mouse_entered() -> void:
	cargo_animated_sprite.play("normal")
func _on_cargo_button_mouse_exited() -> void:
	cargo_animated_sprite.play_backwards("normal")

signal fitment_button_pressed
@export var fitment_animated_sprite: AnimatedSprite2D
func _on_fitment_button_pressed() -> void:
	fitment_button_pressed.emit()
func _on_fitment_button_mouse_entered() -> void:
	fitment_animated_sprite.play("normal")
func _on_fitment_button_mouse_exited() -> void:
	fitment_animated_sprite.play_backwards("normal")
