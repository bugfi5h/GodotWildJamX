extends Area2D

var m_player : Node2D;
var m_main_map : Node2D;

func _ready() -> void:
	m_player = Helper.get_player()
	m_main_map = Helper.get_main_map()

func _on_MegaGlorb_body_entered(body : PhysicsBody2D) -> void:
	if  m_player != null and m_main_map != null:
		if body == m_player:
			m_main_map.add_mega_glorb();
			queue_free()
	else:
		queue_free()
