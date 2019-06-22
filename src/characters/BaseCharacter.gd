extends KinematicBody2D

const GLITCH_LAYER : int = 16
const GLITCH_MASK : int = 0

export var current_health : int = 6
export var max_health : int = 6
export var current_glorb_meter : float = 100
export var glorb_meter_regeneration_rate : float = 1
export var max_glorb_meter : float = 100
export var wall_glorb_cost : int = 50
var m_default_collision_mask : int
var m_default_collision_layer : int

export var damage : int = 1
export var speed : int = 150
export var glitch_speed : int = 150

var m_is_glitching : bool = false

func is_glitching() -> bool:
	return m_is_glitching
	
func set_glitch_mode(on:bool) -> void:
	m_is_glitching = on
	if m_is_glitching:
		collision_mask = GLITCH_MASK
		collision_layer = GLITCH_LAYER
		$Hitbox.monitorable = false
	else:
		collision_mask = m_default_collision_mask
		collision_layer = m_default_collision_layer
		$Hitbox.monitorable = true

func change_health(change:int) -> void:
	if change < 0:
		$DamageAnimation.play("damage")
	current_health = Helper.limit(0, max_health, current_health + change)
	if current_health == 0:
		die()
		
func die() -> void:
	#Überschriebene Funktionen hätten hier Sterbeanimationen oder GameOver Screens
	queue_free()
		
func change_glorb_meter(change:float) -> void:
	current_glorb_meter = Helper.limit(0, max_glorb_meter, change + current_glorb_meter)
		
func has_enough_glorb_meter(needed_meter : float) -> bool:
	return current_glorb_meter - needed_meter >= 0

func _physics_process(delta):
	change_glorb_meter(delta * glorb_meter_regeneration_rate)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_default_collision_mask = collision_mask
	m_default_collision_layer = collision_layer
	
func collect_glorb(glorb : Glorb) -> bool:
	change_glorb_meter(glorb.glitch_amount)
	return true

