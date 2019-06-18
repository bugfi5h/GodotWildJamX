extends "res://characters/BaseCharacter.gd"


var m_velocity : Vector2
var m_look_direction : Vector2 = Vector2(1,0)
var m_is_attacking  : bool = false
var m_parent : Node2D

func _ready() -> void:
	add_to_group("player")
	max_health = GameState.get_player_max_health()
	current_health = GameState.get_player_health()
	current_glorb_meter = GameState.get_player_glorb_meter()
	max_glorb_meter = GameState.get_player_max_glorb_meter()
	m_default_collision_mask = collision_mask
	m_parent = get_parent()
	

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

func change_glorb_meter(change:int) -> void:
	.change_glorb_meter(change)
	GameState.set_player_glorb_meter(current_glorb_meter)

func die() -> void:
	# GAME OVER
	.die()

func _physics_process(delta) -> void:
	if !m_is_glitching:
		_process_normal_movement(delta)
	else:
		_process_glitch_movement(delta)

func set_glitch_mode(on:bool) -> void:
	.set_glitch_mode(on)
	if m_is_glitching:
		$AnimationPlayer.play("glitching")
	else:
		$AnimationPlayer.play("idle")
		
func _process_normal_movement(delta):
	m_velocity = Vector2()
	var direction = Vector2()
	if !m_is_attacking:
		if Input.is_action_pressed('ui_up'):
			direction += Vector2(0,-1)
			m_look_direction = Vector2(0,-1)
		if Input.is_action_pressed('ui_down'):
			m_look_direction = Vector2(0,1)
			direction += Vector2(0,1)
		if Input.is_action_pressed('ui_left'):
			direction += Vector2(-1,0)
			m_look_direction = Vector2(-1,0)
			$Sprite.scale.x = -1	#Spiegeln durch anpassen des scales, da so auch Kinder des Sprites geflipt werden
		if Input.is_action_pressed('ui_right'):
			direction += Vector2(1,0)
			m_look_direction = Vector2(1,0)
			$Sprite.scale.x = 1	
		if direction == Vector2.ZERO:
			$AnimationPlayer.play("idle")
		if Input.is_action_just_pressed("attack"):
			m_is_attacking = true
			$AnimationPlayer.play("attack")
			direction = Vector2()
		if Input.is_action_pressed("glitch"):
			if has_enough_glorb_meter(wall_glorb_cost):
				change_glorb_meter(-wall_glorb_cost)
				set_glitch_mode(true)
	m_velocity = direction.normalized()*speed
	move_and_slide(m_velocity)
	
func _process_glitch_movement(delta) -> void:
	move_and_slide(m_look_direction.normalized()*glitch_speed)
	if m_parent.has_method("get_stage_dimensions"):
		var stage_dimensions = m_parent.get_stage_dimensions()
		var test = $Sprite.texture.get_size().x
		if position.x < -$Sprite.texture.get_size().x /2:
			position.x = stage_dimensions.x
		if position.x > stage_dimensions.x+$Sprite.texture.get_size().x/2:
			position.x = 0
		if position.y < -$Sprite.texture.get_size().y/2:
			position.y = stage_dimensions.y
		if position.y > stage_dimensions.y+$Sprite.texture.get_size().y/2:
			position.y = 0

func _on_PunchHit_area_entered(area) -> void:
	if area.is_in_group("hitbox"):
		area.take_damage(damage)


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "attack":
		m_is_attacking = false
