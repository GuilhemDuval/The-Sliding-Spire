extends Node

var max_health : int = 8
var health : int = max_health
var coins : int = 0
var level : int = 1
var enemies_defeated : int = 0
var seed : int = 8037

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		StateManager.change_state(StateManager.GameState.TITLE_SCREEN)
		await get_tree().process_frame
		call_deferred("reload_scene")
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_F) or Input.is_key_pressed(KEY_F11):
		toggle_fullscreen()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func reload_scene():
	var current_scene = get_tree().current_scene
	if current_scene:
		get_tree().reload_current_scene()
