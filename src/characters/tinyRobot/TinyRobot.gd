extends "res://characters/BaseEnemy.gd"

signal dead
signal shoot_projectile

export (PackedScene) var PROJECTILE
export (float) var PROJECTILE_COOLDOWN
export var debug : bool = false

var can_shoot = true
var alive = true
var target = null
var thinking = true
var run = true
var move_direction = Vector2()
var m_hit_pos : Array
func _draw() -> void: #for debugging ray_cast
	if target and debug:
		for hit in m_hit_pos:
	        draw_line(Vector2(), (hit - global_position).rotated(-rotation), Color.red)
	        draw_circle((hit - global_position).rotated(-rotation), 5, Color.red)	

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
	if debug:
		update() #for debugging ray_cast
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		move_direction = target_dir
		_aim(delta, target_dir)
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
		emit_signal("shoot_projectile", PROJECTILE, projectileSpawn, direction, damage)
	pass


func _aim(delta, target_dir)->void:
	m_hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_radius = target.get_node('Hitbox/HitboxCollsion').shape.radius - 1
	var target_height = target.get_node('Hitbox/HitboxCollsion').shape.height - 1
	var n = target.global_position - Vector2(0,(target_height/2))
	var s = target.global_position + Vector2(0,(target_height/2))
	var e = target.global_position + Vector2(target_radius, 0)
	var w = target.global_position - Vector2(target_radius, 0)
	for pos in [target.global_position, n, e, s, w]:
		var result = space_state.intersect_ray(global_position, pos, [self], $Vision.collision_mask)
		if result:
			m_hit_pos.append(result.position)
			if result.collider.name == "PlayerCharacter":
				shoot(target_dir)


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
