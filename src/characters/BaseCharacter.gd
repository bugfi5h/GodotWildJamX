extends KinematicBody2D

export var current_health : int = 6
export var max_health : int = 6
export var current_glitch_meter : int = 100
export var max_glitch_meter : int = 100
export var wall_glitch_cost : int = 50

export var damage : int = 1
export var speed : int = 150

func change_health(change:int) -> void:
	if change <= 0:
		current_health += max(0, change)
	else:
		current_health += min(change, max_health)
	if current_health == 0:
		die()
		
func die() -> void:
	#Überschriebene Funktionen hätten hier Sterbeanimationen oder GameOver Screens
	queue_free()
		
func change_glitch_meter(change:int) -> void:
	current_glitch_meter = Helper.limit(0, max_glitch_meter, change + current_glitch_meter)
		
func has_enough_glitch_meter(needed_meter : int) -> bool:
	return current_glitch_meter - needed_meter >= 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func collect_glorb(glorb : Glorb) -> bool:
	change_glitch_meter(glorb.glitch_amount)
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
