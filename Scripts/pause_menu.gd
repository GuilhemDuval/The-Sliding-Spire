extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_pressed():
	StateManager.toggle_pause()

func _on_restart_pressed():
	get_tree().paused = false
	StateManager.paused = false
	get_tree().get_root().get_node("SceneManager")._reload_exploration()
	queue_free()

func _on_main_menu_pressed():
	get_tree().paused = false
	StateManager.paused = false
	StateManager.change_state(StateManager.GameState.TITLE_SCREEN)


func _on_back_pressed() -> void:
	pass # Replace with function body.
