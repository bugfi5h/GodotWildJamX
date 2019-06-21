extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime

var velocity = Vector2()
var direction

func _ready():
	$AnimatedSprite.play("fly")
	$Lifetime.start()
	pass

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	$Lifetime.wait_time = lifetime

func _process(delta):
	position += velocity * delta
	
func impact():
    queue_free()

func _on_Lifetime_timeout():
	impact()

func _on_Projectile_area_entered(area):
	print("hit")
	if area.is_in_group("hitbox"):
		area.take_damage(damage)
	impact()	
	pass # Replace with function body.
