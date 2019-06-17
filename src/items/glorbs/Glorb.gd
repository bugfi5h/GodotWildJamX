extends Area2D
class_name Glorb

export var speed : float = 1;
export var glitch_amount : float = 10;

var m_player : Node2D;


func _ready():
	m_player = Helper.get_player()
	$AnimationPlayer.play("Glorb")

func _physics_process(delta):
	var direction = Helper.get_direction(global_position, m_player.global_position)
	var distance = global_position.distance_to(m_player.global_position)
	var speed_multiplier = (50 / pow(Helper.limit(5, 200, abs(distance)), 2)) * 100
	speed_multiplier = Helper.limit(1, 10, speed_multiplier)
	print(str(speed_multiplier))
	translate(direction * speed * speed_multiplier * delta)

func _on_Glorb_body_entered(body):
	var success = false
	if (body.has_method("collect_glorb")):
		success = body.collect_glorb(self)
	
	if(success):
		queue_free()

