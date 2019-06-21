extends "res://characters/BaseEnemy.gd"

export var eye_rotation_speed : float = 1.0 
export var bullet : PackedScene = null

var m_can_shoot : bool = true
var m_move : bool = true
signal shoot(bullet, pos, dir)

var m_velocity : Vector2 = Vector2()

func _ready() -> void:
	randomize()
	var parent = get_parent()
	if parent != null and parent.has_method("_on_enemy_shooting"):
		self.connect("shoot", parent, "_on_enemy_shooting")
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
	if m_target:
		var target_dir = (m_target.global_position - global_position).normalized()
		var current_dir = Vector2(1,0).rotated($EyeContainer.global_rotation)
		$EyeContainer.global_rotation = current_dir.linear_interpolate(target_dir, eye_rotation_speed * delta).angle()
		$Eye.global_position = $EyeContainer/Position2D.global_position
		if target_dir.dot(current_dir) > 0.8:
			_shoot()
	_move(delta)

func _move(delta) -> void:
	var collision = move_and_collide(m_velocity * speed * delta)
	if collision:
		_get_new_direction()
		$DirectionChangeTimer.start()
			
func _shoot() -> void:
	if m_can_shoot:
		m_can_shoot = false
		$DelayTimer.start()
		var dir = Vector2(1,0).rotated($EyeContainer.global_rotation)
		emit_signal('shoot', bullet, $EyeContainer/Position2D.global_position, dir)
		

func _on_DelayTimer_timeout() -> void:
	m_can_shoot = true


func _on_DirectionChangeTimer_timeout():
	if m_move:
		_get_new_direction()
		m_move = false
	else:
		m_velocity = Vector2.ZERO
		m_move = true
