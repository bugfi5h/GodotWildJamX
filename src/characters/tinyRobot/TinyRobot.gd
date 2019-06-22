extends "res://characters/BaseEnemy.gd"

signal dead
signal shoot_projectile

export (PackedScene) var PROJECTILE
export (float) var PROJECTILE_COOLDOWN

var can_shoot = true
var alive = true
var target = null
var thinking = true
var run = true
var move_direction = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	var parent = get_parent()
	if parent != null and parent.has_method("_on_enemy_shooting"):
		self.connect("shoot_projectile", parent, "_on_enemy_shooting")
	$ProjectileTimer.wait_time = PROJECTILE_COOLDOWN
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		move_direction = target_dir
		shoot(target_dir)
		if(target.global_position.x - global_position.x < 0):
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
		
func shoot(direction):
	if can_shoot:
		can_shoot = false
		$ProjectileTimer.start()
		var projectileSpawn = $ProjectileSpawn.global_position
		emit_signal("shoot_projectile", PROJECTILE, projectileSpawn, direction)
	pass

func _on_ProjectileTimer_timeout():
	can_shoot = true
	pass # Replace with function body.

func _on_Vision_body_entered(body):
	if body.name == "PlayerCharacter":
		target = body
	pass # Replace with function body.

func _on_ThinkTimer_timeout():
	move_direction = Vector2()
	thinking = true
	pass # Replace with function body.


func _on_Minimum_Distance_body_entered(body):
	if body == target:
		run = false
	pass # Replace with function body.


func _on_Minimum_Distance_body_exited(body):
	if body == target:
		run = true
	pass # Replace with function body.
