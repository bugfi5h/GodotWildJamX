extends Node

var m_player_health : int = 6
var m_player_max_health : int = 6
var m_player_glorb_meter : int = 100
var m_player_max_glorb_meter : int = 100

var highscore : int = 0

func reset_game():
	set_player_max_health(6)
	set_player_health(6)
	set_player_glorb_meter(100)
	highscore = 0
	

signal player_health_changed(health)
signal player_max_health_changed(health)
signal player_glorb_meter_changed(meter)
signal player_max_glorb_meter_changed(meter)

func get_player_health()->int:
	return m_player_health
	
func set_player_health(health: int) -> void:
	if m_player_health != health:
		m_player_health = health
		emit_signal("player_health_changed", health)
	
func get_player_glorb_meter()->int:
	return m_player_glorb_meter
	
func set_player_glorb_meter(meter: int) -> void:
	if m_player_glorb_meter != meter:
		m_player_glorb_meter = meter
		emit_signal("player_glorb_meter_changed", meter)

func get_player_max_health()->int:
	return m_player_max_health
	
func set_player_max_health(health : int) -> void:
	if m_player_max_health != health:
		m_player_max_health = health
		emit_signal("player_max_health_changed", health)
		
func get_player_max_glorb_meter()->int:
	return m_player_max_glorb_meter
	
func set_player_max_glorb_meter(meter: int) -> void:
	if m_player_max_glorb_meter != meter:
		m_player_max_glorb_meter = meter
		emit_signal("player_max_glorb_meter_changed", meter)