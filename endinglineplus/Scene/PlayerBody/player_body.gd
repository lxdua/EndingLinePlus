extends CharacterBody3D
class_name PlayerBody

const ACCELERATION: = 100.0

@export var speed: = 1.0

@onready var player_body_sprite: AnimatedSprite3D = $PlayerBodySprite
@onready var key_sprite: AnimatedSprite3D = $KeySprite


var direction: Vector3:
	set(v):
		if direction == v:
			return
		direction = v
		if v:
			player_body_sprite.play("run")
			if v.x != 0:
				player_body_sprite.flip_h = v.x < 0
		else:
			player_body_sprite.play("idle")

var target: Array[Interaction]

var can_move: bool = true:
	set(v):
		can_move = v
		velocity.x = 0
		velocity.z = 0
		player_body_sprite.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not target.is_empty():
			target.back().interact(self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 5
	if can_move:
		player_move(delta)
	move_and_slide()

func player_move(delta: float):
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)

func _on_player_body_area_area_entered(area: Area3D) -> void:
	if area is Interaction:
		target.append(area)
		show_key("E")

func _on_player_body_area_area_exited(area: Area3D) -> void:
	if area is Interaction:
		target.erase(area)
		if target.is_empty():
			key_sprite.hide()

func show_key(key: String):
	key_sprite.play("key "+key)
	key_sprite.show()
