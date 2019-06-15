extends KinematicBody2D

export var m_current_health : int = 6
export var m_max_health : int = 6
export var m_current_glitch_meter : int = 100
export var m_max_glitch_meter : int = 100
export var m_wall_glitch_cost : int = 50

func change_health(change:int) -> void:
	if change <= 0:
		m_current_health += max(0, change)
	else:
		m_current_health += min(change, m_max_health)
	if m_current_health == 0:
		die()
		
func die():
	#Überschriebene Funktionen hätten hier Sterbeanimationen oder GameOver Screens
	queue_free()
		
func change_glitch_meter(change:int) -> void:
	if change <=0:
		m_current_glitch_meter += max(0, change)
	else:
		m_current_glitch_meter += min(change, m_max_glitch_meter)
		
func has_enough_glitch_meter(needed_meter : int) -> bool:
	return m_current_glitch_meter - needed_meter >= 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
