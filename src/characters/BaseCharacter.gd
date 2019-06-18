extends KinematicBody2D

export var current_health : int = 6
export var max_health : int = 6
export var current_glorb_meter : int = 100
export var max_glorb_meter : int = 100
export var wall_glorb_cost : int = 50
var m_default_collision_mask : int

export var damage : int = 1
export var speed : int = 150
export var glitch_speed : int = 150

var m_is_glitching : bool = false

func is_glitching() -> bool:
	return m_is_glitching
	
func set_glitch_mode(on:bool) -> void:
	m_is_glitching = on
	if m_is_glitching:
		collision_mask = 0
	else:
		collision_mask = m_default_collision_mask

func change_health(change:int) -> void:
	current_health = Helper.limit(0, max_health, current_health + change)
	if current_health == 0:
		die()
		
func die() -> void:
	#Überschriebene Funktionen hätten hier Sterbeanimationen oder GameOver Screens
	queue_free()
		
func change_glorb_meter(change:int) -> void:
	current_glorb_meter = Helper.limit(0, max_glorb_meter, change + current_glorb_meter)
		
func has_enough_glorb_meter(needed_meter : int) -> bool:
	return current_glorb_meter - needed_meter >= 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_default_collision_mask = collision_mask
	
func collect_glorb(glorb : Glorb) -> bool:
	change_glorb_meter(glorb.glitch_amount)
	return true

