extends Node

enum GameState { TITLE_SCREEN, EXPLORATION, PUZZLE, RESULTS }

var current_state: int = GameState.TITLE_SCREEN
var previous_state: int = GameState.TITLE_SCREEN
var paused = false

signal state_changed(new_state)
signal pause_toggled(paused)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_state(new_state):
	if current_state != new_state:
		previous_state = current_state
		current_state = new_state
		state_changed.emit(new_state)
		print("State changed to : ", new_state)

func toggle_pause():
	paused = !paused
	pause_toggled.emit(paused)

func was_previous_state(state_to_check: int):
	return previous_state == state_to_check
