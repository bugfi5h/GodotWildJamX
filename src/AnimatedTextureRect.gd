extends Control

export var sprites : SpriteFrames = null
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play(anim_name : String):
	if sprites == null:
		return
	if !(anim_name in sprites.get_animation_names()):
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
