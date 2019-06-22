extends "res://characters/BaseCharacter.gd"

export var detect_radius : int = 400
export var has_detect_radius : bool = false
export var glorb_spawn_amount : int = 2

var m_target : PhysicsBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	if has_detect_radius:
		var circle = CircleShape2D.new()
		$DetectRadius/CollisionShape2D.shape = circle
		$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"):
		m_target = body

func _on_DetectRadius_body_exited(body):
	if body == m_target:
		m_target = null

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