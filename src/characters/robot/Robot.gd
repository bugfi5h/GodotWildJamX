extends "res://characters/BaseEnemy.gd"

export var eye_rotation_speed : float = 1.0 
export var bullet : PackedScene = null
export var debug : bool = false

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
	if debug:
		update() #for debugging ray_cast
	if m_target:
		_aim(delta)
	_move(delta)

func _move(delta) -> void:
	var collision = move_and_collide(m_velocity * speed * delta)
	if collision:
		_get_new_direction()
		$DirectionChangeTimer.start()

var m_hit_pos : Array
func _aim(delta) -> void:
	m_hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_radius = m_target.get_node('Hitbox/HitboxCollsion').shape.radius - 1
	var target_height = m_target.get_node('Hitbox/HitboxCollsion').shape.height - 1
	var n = m_target.global_position - Vector2(0,(target_height/2))
	var s = m_target.global_position + Vector2(0,(target_height/2))
	var e = m_target.global_position + Vector2(target_radius, 0)
	var w = m_target.global_position - Vector2(target_radius, 0)
	for pos in [m_target.global_position, n, e, s, w]:
		var result = space_state.intersect_ray(global_position, pos, [self], $DetectRadius.collision_mask)
		if result:
			m_hit_pos.append(result.position)
			if result.collider.name == "PlayerCharacter":	
				var target_dir = (m_target.global_position - global_position).normalized()
				var current_dir = Vector2(1,0).rotated($EyeContainer.global_rotation)
				$EyeContainer.global_rotation = current_dir.linear_interpolate(target_dir, eye_rotation_speed * delta).angle()
				$Eye.global_position = $EyeContainer/Position2D.global_position
				if target_dir.dot(current_dir) > 0.8:
					_shoot()
			
func _shoot() -> void:
	if m_can_shoot:
		m_can_shoot = false
		$DelayTimer.start()
		var dir = Vector2(1,0).rotated($EyeContainer.global_rotation)
		emit_signal('shoot', bullet, $EyeContainer/Position2D.global_position, dir, damage)

func _draw() -> void: #for debugging ray_cast
	if m_target and debug:
		for hit in m_hit_pos:
	        draw_line(Vector2(), (hit - global_position).rotated(-rotation), Color.red)
	        draw_circle((hit - global_position).rotated(-rotation), 5, Color.red)	

func _on_DelayTimer_timeout() -> void:
	m_can_shoot = true


func _on_DirectionChangeTimer_timeout():
	if m_move:
		_get_new_direction()
		m_move = false
	else:
		m_velocity = Vector2.ZERO
		m_move = true
