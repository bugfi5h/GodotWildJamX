tool
extends Control

export var sprites : SpriteFrames = null setget set_sprites, get_sprites
export(String) var animation = "default" setget set_animation
export var frame : int = 0 setget _set_current_frame
export var playing : bool = false setget _set_playing
var m_should_loop : bool = true

signal animation_finished(anim_name)
signal frame_changed(frame)

func get_sprites() -> SpriteFrames:
	return sprites

func set_animation(anim_name : String) -> void:
	if sprites != null:
		if anim_name in sprites.get_animation_names():
			animation = anim_name
			var animation_speed = sprites.get_animation_speed(anim_name) 
			if has_node("Timer"):
				if animation_speed != 0:
					$Timer.wait_time = 1 / animation_speed
				else:
					$Timer.wait_time = animation_speed
			m_should_loop = sprites.get_animation_loop(anim_name)
			_set_current_frame(0)

func set_sprites(new_sprites : SpriteFrames) -> void:	
	sprites = new_sprites
	if new_sprites != null:
		var anim_names = sprites.get_animation_names()
		if anim_names.size() > 0:
			set_animation( anim_names[0])
	else:
		reset()
		
func reset() -> void:
	if has_node("TextureRect"):
		$TextureRect.texture = null
	frame = 0
	property_list_changed_notify()
	
		
func _set_current_frame(new_frame : int) -> void:
	if sprites != null && animation != null:
		var frame_count = sprites.get_frame_count(animation)
		if new_frame < frame_count:
			if has_node("TextureRect"):
				$TextureRect.texture = sprites.get_frame(animation, new_frame)
			frame = new_frame
		emit_signal("frame_changed", frame)
		property_list_changed_notify()

func play(anim_name : String) -> void:
	if sprites == null:
		return
	if !(anim_name in sprites.get_animation_names()):
		return
	_set_playing(true)
	
func _set_playing(play : bool):
	if sprites != null && animation != null:
		playing = play
		if playing:
			set_animation(animation)
		
func stop() -> void:
	if playing:
		playing = false
		emit_signal("animation_finished", animation)

func _process(delta) -> void:
	if has_node("Timer"):
		if playing:
			if $Timer.is_stopped():
				$Timer.start()
		else:
			if !$Timer.is_stopped():
				$Timer.stop()

func _on_Timer_timeout() -> void:
	if sprites != null && animation != null:
		var next_frame = frame + 1
		if next_frame >= sprites.get_frame_count(animation):
			if m_should_loop:
				next_frame = 0
			else:
				playing = false
				emit_signal("animation_finished", animation)
				return
		_set_current_frame(next_frame)
		
			
