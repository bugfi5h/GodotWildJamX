extends Area2D

var m_main_map : Node2D = null setget set_main_map

func _ready() -> void:
	add_to_group("mega_glorb")

func _on_MegaGlorb_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player"):
		if m_main_map != null:
			m_main_map.add_mega_glorb();
		queue_free()

func set_main_map(map : Node2D)-> void:
	m_main_map = map