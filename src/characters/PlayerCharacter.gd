extends "res://characters/BaseCharacter.gd"

var m_velocity : Vector2

func _ready() -> void:
	add_to_group("player")
	max_health = GameState.get_player_max_health()
	current_health = GameState.get_player_health()
	current_glorb_meter = GameState.get_player_max_health()
	max_glorb_meter = GameState.get_player_max_glorb_meter()
	

func change_max_glorb_meter(change:int) -> void:
	max_glorb_meter = max(0,max_glorb_meter + change)
	GameState.set_player_max_glorb_meter(max_glorb_meter)
	if max_glorb_meter - current_glorb_meter <0:
		change_glorb_meter(max_glorb_meter - current_glorb_meter)

func change_max_health(change:int) -> void:
	max_health = max(0, max_health + change)
	GameState.set_player_max_health(max_health)
	if max_health - current_health < 0:
		change_health(max_health - current_health)
	if max_health == 0:
		die()

func change_health(change:int) -> void:
	.change_health(change)
	GameState.set_player_health(current_health)

func change_glitch_meter(change:int) -> void:
	.change_glitch_meter(change)
	GameState.change_glorb_meter(current_glorb_meter)

func die() -> void:
	# GAME OVER
	.die()

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
