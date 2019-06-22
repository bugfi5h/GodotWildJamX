extends "res://characters/BaseShootingEnemy.gd"

var thinking = true
var run = true
var move_direction = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	._physics_process(delta)
	if m_target:
		var target_dir = (m_target.global_position - global_position).normalized()
		move_direction = target_dir
		_aim(delta, target_dir)
		if(m_target.global_position.x - global_position.x < 0):
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	elif thinking == true:
		thinking = false
		$ThinkTimer.start()
		randomize()
		
		var rand_x = rand_range(-10,10)
		var rand_y = rand_range(-10,10)
		move_direction = Vector2(rand_x, rand_y).normalized()
	else:
		if(move_direction.x  < 0):
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	
	if run:
		$AnimationPlayer.play("run")
		move_and_slide(move_direction * speed)
	else:
		$AnimationPlayer.play("idle")
		

func _aim(delta, target_dir)->void:
	if _is_target_visible():
		var projectileSpawn = $ProjectileSpawn.global_position
		_shoot(projectileSpawn, target_dir)

func _on_ThinkTimer_timeout():
	move_direction = Vector2()
	thinking = true


func _on_Minimum_Distance_body_entered(body):
	if body == m_target:
		run = false


func _on_Minimum_Distance_body_exited(body):
	if body == m_target:
		run = true
