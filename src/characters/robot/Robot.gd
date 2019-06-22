extends "res://characters/BaseShootingEnemy.gd"

export var eye_rotation_speed : float = 1.0 
var m_move : bool = true
var m_velocity : Vector2 = Vector2()

func _ready() -> void:
	randomize()
	_get_new_direction()
	$DirectionChangeTimer.start()

func _get_new_direction() -> void:
	var x = randi() % 3 -1
	var y = randi() % 3 -1
	while (x == 0 and y == 0):
		x = randi() % 3 -1
		y = randi() % 3 -1
	m_velocity = Vector2(x, y).normalized()

func _physics_process(delta) -> void:
	._physics_process(delta)
	if m_target:
		_aim(delta)
	_move(delta)

func _move(delta) -> void:
	var collision = move_and_collide(m_velocity * speed * delta)
	if collision:
		_get_new_direction()
		$DirectionChangeTimer.start()

func _aim(delta) -> void:
	var target_dir = (m_target.global_position - global_position).normalized()
	var current_dir = Vector2(1,0).rotated($EyeContainer.global_rotation)
	$EyeContainer.global_rotation = current_dir.linear_interpolate(target_dir, eye_rotation_speed * delta).angle()
	$Eye.global_position = $EyeContainer/Position2D.global_position
	if target_dir.dot(current_dir) > 0.8:
		if _is_target_visible():
				var dir = Vector2(1,0).rotated($EyeContainer.global_rotation)
				_shoot($EyeContainer/Position2D.global_position, dir)
			

func _on_DirectionChangeTimer_timeout():
	if m_move:
		_get_new_direction()
		m_move = false
	else:
		m_velocity = Vector2.ZERO
		m_move = true
