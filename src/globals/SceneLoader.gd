extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)
	current_scene.queue_free() # get rid of the old scene
	# start your "loading..." animation
	self.modulate = Color(1,1,1,1)
	$AnimationPlayer.play("loading")
	wait_frames = 60

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
			#TODOD Hier fehlt wahrscheinlich noch das generieren.
			$AnimationPlayer.stop()
			$AnimationPlayer.play("fadeAway")
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
    get_node("/root").add_child(current_scene)