extends BaseRoom

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		enemies[0].get_node("Hitbox").take_damage(1)
