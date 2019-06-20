extends Control

var m_hearts : Array = []

var m_animated_texture : PackedScene = preload("res://ui/custom_elements/AnimatedTextureRect.tscn")
var m_sprite_frames : Resource = preload("res://assets/images/ui/icons/heart_animation_sprite_frames.tres")

var m_glorb_meter : Node2D

func _ready() -> void:
	_on_max_healt_changed(GameState.get_player_max_health())
	m_glorb_meter = $VBoxContainer/NinePatchRect/Glorbmeter
	m_glorb_meter.max_value = GameState.get_player_max_glorb_meter()
	m_glorb_meter.value = GameState.get_player_glorb_meter()
	GameState.connect("player_glorb_meter_changed", self, "_on_glorb_meter_changed")
	GameState.connect("player_max_glorb_meter_changed", self, "_on_max_glorb_meter_changed")
	GameState.connect("player_health_changed", self, "_on_health_changed")
	GameState.connect("player_max_health_changed", self, "_on_max_health_changed")
	
	
func _on_health_changed(health : int) -> void:
	var wait = 0
	while(m_hearts.size() == 0):
		wait += 1
		if wait > 100:
			print("Error: no hearts available")
			return
	var full_hearts = health / 2
	var half_hearts = health % 2
	for i in range(m_hearts.size()):
		if i < full_hearts:
			m_hearts[i].play("full")
		elif i < (full_hearts + half_hearts):
			m_hearts[i].play("half")
		else:
			m_hearts[i].play("empty")
		
	
func _on_max_healt_changed(health : int) -> void:
	_clear_hearts()
	m_hearts.clear()
	if health != 0:
		var full_hearts = health / 2
		var half_hearts = health % 2
		for i in range(full_hearts + half_hearts):
			_add_heart()
		_on_health_changed(GameState.get_player_health())

func _clear_hearts():
	for heart in m_hearts:
		heart.queue_free()
	
func _add_heart() -> void:
	var container = $VBoxContainer/MarginContainer/Hearts/Row
	var heart = m_animated_texture.instance()
	heart.sprites = m_sprite_frames
	m_hearts.append(heart)
	container.add_child(heart)
	
func _on_glorb_meter_changed(value : int) -> void:
	m_glorb_meter.value = value
	
func _on_max_glorb_meter_changed(value : int) -> void:
	m_glorb_meter.max_value = value

