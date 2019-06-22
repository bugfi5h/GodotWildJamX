extends Position2D
class_name GlorbSpawner

var GLORB = preload("res://items/glorbs/Glorb.tscn")
var can_spawn = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn():
	$SpawnTime.start()
	$AnimatedSprite.play("Spawn")
	can_spawn = true

	pass

func default():
	$AnimatedSprite.play("Default")
	pass

func _on_AnimatedSprite_animation_finished():
	if can_spawn:
		var glorb = GLORB.instance()
		get_parent().add_child(glorb)
		glorb.global_position = global_position
		can_spawn = false
	pass

func stop():
	$SpawnTime.stop()
	pass