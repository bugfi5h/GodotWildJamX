extends BaseRoom
class_name SecretRoom

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func start_spawner(body):
	print("spawner start")	
	var children = get_children()
	for child in children:
		if "GlorbSpawner" in child.name:
			child.spawn()
	pass # Replace with function body.

func stop_spawner(body):
	var children = get_children()
	for child in children:
		if "GlorbSpawner" in child.name:
			print("stop")
			child.stop()
	pass