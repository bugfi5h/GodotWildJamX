extends KinematicBody2D

export var current_health : int = 6
export var max_health : int = 6
export var current_glorb_meter : int = 100
export var max_glorb_meter : int = 100
export var wall_glorb_cost : int = 50

export var damage : int = 1
export var speed : int = 150

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
	pass # Replace with function body.
	
func collect_glorb(glorb : Glorb) -> bool:
	change_glorb_meter(glorb.glitch_amount)
	return true

