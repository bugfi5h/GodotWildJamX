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
	

func change_max_glorb_meter(change:float) -> void:
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

func change_glorb_meter(change:float) -> void:
	.change_glorb_meter(change)
	GameState.set_player_glorb_meter(current_glorb_meter)

func die() -> void:
	# GAME OVER
	.die()
	SceneLoader.goto_menu_scene("res://ui/GameOver.tscn")

func _physics_process(delta) -> void:
	._physics_process(delta)
	_move_arrow(delta)
	if !m_is_glitching:
		_process_normal_movement(delta)
	else:
		_process_glitch_movement(delta)

func _move_arrow(delta):
	var mega_glorbs = get_tree().get_nodes_in_group("mega_glorb")
	if mega_glorbs.size() > 0:
		var nearest = mega_glorbs[0]
		for glorb in mega_glorbs:
			if nearest != glorb:
				if global_position.distance_to(glorb.global_position) < global_position.distance_to(nearest.global_position):
					nearest = glorb
		var arrow = $ArrowContainer
		var target_dir = (nearest.global_position - arrow.global_position).normalized()
		var current_dir = Vector2(1, 0).rotated(arrow.global_rotation)
		arrow.global_rotation = current_dir.linear_interpolate(target_dir, 1).angle()			

func set_glitch_mode(on:bool) -> void:
	.set_glitch_mode(on)
	if m_is_glitching:
		$AnimationPlayer.play("glitching")
	else:
		$AnimationPlayer.play("idle")

func play_walk_animation() -> void:
	if !m_is_glitching && !m_is_attacking:
		if m_velocity == Vector2.ZERO:
			$AnimationPlayer.play("idle")
		elif m_look_direction == Vector2(0,-1):
			$AnimationPlayer.play("walk_up")
		elif m_look_direction == Vector2(0,1):
			$AnimationPlayer.play("walk_down")
		elif m_look_direction == Vector2(-1,0):
			$Sprite.scale.x = -1
			$AnimationPlayer.play("walk_sideways")
		elif m_look_direction == Vector2(1,0):
			$Sprite.scale.x = 1
			$AnimationPlayer.play("walk_sideways")

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
		if Input.is_action_just_pressed("attack"):
			m_is_attacking = true
			$AnimationPlayer.play("attack")
			direction = Vector2()
		if Input.is_action_pressed("glitch"):
			if has_enough_glorb_meter(wall_glorb_cost):
				change_glorb_meter(-wall_glorb_cost)
				set_glitch_mode(true)
	m_velocity = direction.normalized()*speed
	play_walk_animation()
	move_and_slide(m_velocity)
	
func _process_glitch_movement(delta) -> void:
	move_and_slide(m_look_direction.normalized()*glitch_speed)
	if m_parent.has_method("get_stage_dimensions"):
		var stage_dimensions = m_parent.get_stage_dimensions()
		var test = $Sprite.texture.get_size().x
		var pos_changed = false
		if position.x < -$Sprite.texture.get_size().x /2:
			position.x = stage_dimensions.x
			pos_changed = true
		if position.x > stage_dimensions.x+$Sprite.texture.get_size().x/2:
			position.x = 0
			pos_changed = true
		if position.y < -$Sprite.texture.get_size().y/2:
			position.y = stage_dimensions.y
			pos_changed = true
		if position.y > stage_dimensions.y+$Sprite.texture.get_size().y/2:
			position.y = 0
			pos_changed = true
		if pos_changed:
			m_parent.disable_camera_smoothing_for_frame()

func _on_PunchHit_area_entered(area) -> void:
	if area.is_in_group("hitbox"):
		area.take_damage(damage)


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "attack":
		m_is_attacking = false
