extends Node

enum GameState { TITLE_SCREEN, EXPLORATION, PUZZLE, RESULTS }

var current_state: int = GameState.TITLE_SCREEN

signal state_changed(new_state)

func change_state(new_state: int):
	if current_state != new_state:
		current_state = new_state
		state_changed.emit(new_state)
		print("State changed to : ", new_state)
