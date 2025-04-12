extends Control

func _on_play_pressed() -> void:
	$Intro.visible = false
	$Play.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	if $Play/Buttons/SpinBox.value == 0:
		Global.generation_seed = randi_range(1, 100000)
	else:
		Global.generation_seed = $Play/Buttons/SpinBox.value
	Global.health = Global.max_health
	Global.level = 1
	Global.coins = 0
	Global.enemies_defeated = 0
	StateManager.change_state(1)

func _on_back_pressed() -> void:
	$Intro.visible = true
	$Play.visible = false
