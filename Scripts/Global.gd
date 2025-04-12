extends Node

var max_health : int = 8
var health : int = max_health
var coins : int = 0
var level : int = 1
var enemies_defeated : int = 0
var generation_seed : int = 8037

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_R):
		StateManager.change_state(StateManager.GameState.TITLE_SCREEN)
		await get_tree().process_frame
		call_deferred("reload_scene")
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_F) or Input.is_key_pressed(KEY_F11):
		toggle_fullscreen()
	if event.is_action_pressed("pause"):
		if StateManager.paused:
			StateManager.toggle_pause()
		elif StateManager.current_state in [StateManager.GameState.EXPLORATION, StateManager.GameState.PUZZLE]:
			StateManager.toggle_pause()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func reload_scene():
	var current_scene = get_tree().current_scene
	if current_scene:
		get_tree().reload_current_scene()
