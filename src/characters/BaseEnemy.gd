extends "res://characters/BaseCharacter.gd"

export var detect_radius : int = 400
export var has_detect_radius : bool = false
export var glorb_spawn_amount : int = 2
export var debug : bool = false

var m_target : PhysicsBody2D = null
var m_hit_pos : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	if has_detect_radius:
		var circle = CircleShape2D.new()
		$DetectRadius/CollisionShape2D.shape = circle
		$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _on_DetectRadius_body_entered(body) -> void:
	if body.is_in_group("player"):
		m_target = body

func _on_DetectRadius_body_exited(body) -> void:
	if body == m_target:
		m_target = null

func _physics_process(delta) -> void:
	if debug:
		update() #for debugging ray_cast

func _draw() -> void:
	if m_target and debug:
		for hit in m_hit_pos:
	        draw_line(Vector2(), (hit - global_position).rotated(-rotation), Color.red)
	        draw_circle((hit - global_position).rotated(-rotation), 5, Color.red)	

func _is_target_visible() -> bool:
	var player_visible = false
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
				player_visible = true
	return player_visible

func spawn_glorbs() -> void:
	var glorbType = load("res://items/glorbs/Glorb.tscn")
	for i in range(glorb_spawn_amount):
		var glorb : Glorb = glorbType.instance()
		get_parent().add_child(glorb)
		var pos = Vector2(global_position.x + randi() % 10, global_position.y + randi() % 10)
		glorb.global_position = pos

func die():
	spawn_glorbs()
	.die()