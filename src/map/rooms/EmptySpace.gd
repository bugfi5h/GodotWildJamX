extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var x = randi() % 2
	var y = randi() % 2
	$Sprite.flip_h = x
	$Sprite.flip_v = y

