extends "res://characters/BaseEnemy.gd"

var m_can_shoot : bool = true
export var bullet : PackedScene = null
export (float) var projectile_cooldown


signal shoot(bullet, pos, dir)

func _ready():
	var parent = get_parent()
	if parent != null and parent.has_method("_on_enemy_shooting"):
		self.connect("shoot", parent, "_on_enemy_shooting")
	$ProjectileTimer.wait_time = projectile_cooldown

func _shoot(start_pos:Vector2, dir : Vector2) -> void:
	if m_can_shoot:
		m_can_shoot = false
		$ProjectileTimer.start()
		emit_signal('shoot', bullet, start_pos, dir, damage)

func _on_ProjectileTimer_timeout():
	m_can_shoot = true
