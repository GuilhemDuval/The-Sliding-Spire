extends Node

@onready var viewport = $"."

func _ready():
	StateManager.state_changed.connect(_on_state_changed)
	StateManager.pause_toggled.connect(_on_pause_toggled)
	_on_state_changed(StateManager.current_state)
	process_mode = Node.PROCESS_MODE_ALWAYS

func clear_viewport():
	for child in viewport.get_children():
		child.queue_free()
	print("Viewport cleanup complete")

func load_scene(scene_path: String, parent: Node, name_override=""):
	var scene = load(scene_path).instantiate()
	if name_override != "":
		scene.name = name_override
	parent.add_child(scene)
	parent.move_child(scene, parent.get_child_count() - 1)
	return scene

func is_scene_loaded(scene_name: String) -> bool:
	return viewport.has_node(scene_name)

func unload_scene(scene_name: String):
	var scene = viewport.get_node_or_null(scene_name)
	if scene:
		scene.queue_free()

func _on_state_changed(new_state):
	print("SceneManager detects a state change: ", new_state)
	
	if StateManager.was_previous_state(StateManager.GameState.PUZZLE):
		unload_scene("puzzle")
		get_tree().paused = false
		
	match new_state:
		StateManager.GameState.TITLE_SCREEN:
			clear_viewport()
			load_scene("res://Scenes/main_menu.tscn", viewport, "main_menu")
			get_tree().paused = false

		StateManager.GameState.EXPLORATION:
			if not StateManager.was_previous_state(StateManager.GameState.PUZZLE):
				clear_viewport()
				load_scene("res://Scenes/world.tscn", viewport, "world")
				get_tree().paused = false

		StateManager.GameState.PUZZLE:
			if not is_scene_loaded("puzzle"):
				load_scene("res://Scenes/puzzle.tscn", viewport, "puzzle")
			get_tree().paused = true

		StateManager.GameState.RESULTS:
			clear_viewport()
			load_scene("res://Scenes/death_menu.tscn", viewport, "results")
			get_tree().paused = false

func _on_pause_toggled(paused):
	if paused:
		load_scene("res://Scenes/pause_menu.tscn", viewport, "pause_menu")
		get_tree().paused = true
	else:
		unload_scene("pause_menu")
		get_tree().paused = StateManager.current_state == StateManager.GameState.PUZZLE

func _reload_exploration():
	clear_viewport()
	await get_tree().process_frame
	await get_tree().process_frame
	load_scene("res://Scenes/world.tscn", viewport, "world")
	get_tree().paused = false
