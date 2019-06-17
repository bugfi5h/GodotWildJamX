extends "res://characters/BaseCharacter.gd"

var m_velocity : Vector2

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta) -> void:
	m_velocity = Vector2()
	var direction = Vector2()

	if Input.is_action_pressed('ui_up'):
		direction += Vector2(0,-1)
	if Input.is_action_pressed('ui_down'):
		direction += Vector2(0,1)
	if Input.is_action_pressed('ui_left'):
		direction += Vector2(-1,0)
		$Sprite.scale.x = -1	#Spiegeln durch anpassen des scales, da so auch Kinder des Sprites geflipt werden
	if Input.is_action_pressed('ui_right'):
		direction += Vector2(1,0)
		$Sprite.scale.x = 1
	if Input.is_action_pressed("attack"):
		$AnimationPlayer.play("attack")
		direction = Vector2() # Keine Bewegung beim Angriff. Könnte noch angepasst werden je nach Animation
	m_velocity = direction.normalized()*speed
	move_and_slide(m_velocity)

func _on_PunchHit_area_entered(area) -> void:
	if area.is_in_group("hitbox"):
		area.take_damage(damage)
