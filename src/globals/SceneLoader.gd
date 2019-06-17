extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

func _ready():
	self.modulate = Color(1,1,1,0)
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_menu_scene(path):
    call_deferred("_deferred_goto_menu_scene", path)

func _deferred_goto_menu_scene(path):
    # It is now safe to remove the current scene
    current_scene.free()
    # Load the new scene.
    var s = ResourceLoader.load(path)
    # Instance the new scene.
    current_scene = s.instance()
    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)
    # Optionally, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)


func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)
	current_scene.queue_free() # get rid of the old scene
	# start your "loading..." animation
	self.modulate = Color(1,1,1,1)
	$MarginContainer/VBoxContainer/ProgressBar.value = $MarginContainer/VBoxContainer/ProgressBar.min_value
	$AnimationPlayer.play("loading")
	wait_frames = 1 # kann man runterstellen. Ist aktuell zum testen drin.

func show_error() -> void:
	print("Error while loading scene") # todo


func _process(time):
	if loader == null:
        # no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

        # poll your loader
		var err = loader.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			$MarginContainer/VBoxContainer/ProgressBar.value = $MarginContainer/VBoxContainer/ProgressBar.max_value
			set_new_scene(resource)
			#self.visible = false
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			show_error()
			loader = null
			break

func update_progress():
    var progress = float(loader.get_stage()) / loader.get_stage_count()
    # Update your progress bar?
    $MarginContainer/VBoxContainer/ProgressBar.value = progress

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	var has_init_func : bool= current_scene.has_method("initialize_level")
	var has_progress_signal : bool = current_scene.get_script().has_script_signal("level_loading_progress_changed")
	
	if has_init_func and has_progress_signal:
		current_scene.connect("level_loading_progress_changed", self, "_on_loading_progress_changed")
		current_scene.initialize_level(get_viewport().get_visible_rect().size)
	else:
		fade_out_and_and_to_root()
		
func _on_loading_progress_changed(progress):
	$MarginContainer/VBoxContainer/ProgressBar.value = progress
	if progress == 100:
		current_scene.disconnect("level_loading_progress_changed", self, "_on_loading_progress_changed")
		fade_out_and_and_to_root()
		
func fade_out_and_and_to_root():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("fadeAway")
	get_node("/root").add_child(current_scene)
		
		
		