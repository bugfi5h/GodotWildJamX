extends "res://characters/BaseEnemy.gd"
class_name Asteroid


export var split_count : int = 2 # wie oft er sich nach einem Treffer aufteilt
export var split_amount : int = 2 # in wie viele er sich aufteilt
export var scale_reduction : float = 0.75 # wie viel kleiner die neuen sind
export var should_generate_random_start_direction : bool = true

var m_packed_self :PackedScene = null
var m_velocity : Vector2 = Vector2()

func _ready() -> void:
	m_packed_self = load("res://characters/Asteroid.tscn")
	if should_generate_random_start_direction:
		generate_random_start_direction()

func generate_random_start_direction() -> void:		
	randomize()
	var rand_x = pow(-1, randi() % 2)
	var rand_y = pow(-1, randi() % 2)
	m_velocity = Vector2(rand_x, rand_y).normalized()

func _physics_process(delta):
	$Sprite.rotation_degrees += 180 * delta
	var collision = move_and_collide(m_velocity * speed * delta)
	if collision:
		m_velocity = m_velocity.bounce(collision.normal)
		
func die():
	set_physics_process(false)
	if split_count > 0:
		split_count -= 1
		for i in range(split_amount):
			var new_asteroid = m_packed_self.instance()
			new_asteroid.position = position
			new_asteroid.should_generate_random_start_direction = false
			new_asteroid.split_amount = split_amount
			new_asteroid.split_count = split_count
			new_asteroid.scale = scale * scale_reduction
			if i % 2 == 0:
				new_asteroid.m_velocity = m_velocity.rotated(Vector2(1,1).normalized().x)
			else:
				new_asteroid.m_velocity = m_velocity.rotated(-Vector2(1,1).normalized().x)
			get_parent().add_child(new_asteroid)
	else:
		#glorbs!
		pass
	.die()

func _on_damage_area_entered(area) -> void:
	if area.is_in_group("hitbox"):
		area.take_damage(damage)
