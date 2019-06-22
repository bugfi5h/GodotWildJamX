extends Area2D

export var speed : int = 750
export var damage : int = 1

var m_velocity = Vector2()

func start(_position : Vector2, _direction : Vector2):
	global_position = _position
	rotation = _direction.angle()
	m_velocity = _direction * speed

func _physics_process(delta):
	position += m_velocity * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_Laser_body_entered(body):
	if body is StaticBody2D:
		queue_free()

func _on_Laser_area_entered(area):
	if area.is_in_group("hitbox"):
		area.take_damage(damage)
		queue_free()
