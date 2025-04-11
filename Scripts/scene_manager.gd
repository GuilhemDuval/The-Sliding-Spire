extends Node

@onready var viewport = $"."

func _ready():
	StateManager.state_changed.connect(_on_state_changed)
	_on_state_changed(StateManager.current_state)

func clear_viewport():
	for child in viewport.get_children():
		child.queue_free()
	print("Viewport cleanup complete")

func is_scene_loaded(scene_path: String) -> bool:
	for child in viewport.get_children():
		if child.scene_file_path == scene_path:
			return true
	return false

func load_scene(scene_path: String, parent: Node):
	var scene = load(scene_path).instantiate()
	parent.add_child(scene)
	print("Added ", scene_path, " in ", parent.name)
	return scene

func _on_state_changed(new_state):
	print("SceneManager detects a state change: ", new_state)

	if new_state == StateManager.GameState.TITLE_SCREEN:
		clear_viewport()
		load_scene("res://Scenes/main_menu.tscn", viewport)
	elif new_state == StateManager.GameState.EXPLORATION:
		clear_viewport()
		load_scene("res://Scenes/world.tscn", viewport)
	elif new_state == StateManager.GameState.PUZZLE:
		clear_viewport()
		load_scene("", viewport)
	else:
		clear_viewport()
		load_scene("res://Scenes/death_menu.tscn", viewport)
