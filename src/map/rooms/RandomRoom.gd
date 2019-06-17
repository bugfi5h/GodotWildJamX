extends BaseRoom

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_deco(5)
	pass # Replace with function body.

func generate_deco(amount : int) -> void:
	for i in range(amount):
		var x = (randi() % 28 + 1)
		var y = (randi() % 14 + 1)
		$Deco.set_cell(x, y, 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
