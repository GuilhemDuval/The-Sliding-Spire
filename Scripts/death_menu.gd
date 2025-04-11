extends Control

func _ready():
	$Intro/Buttons/Stats.text = "Level reachead: " + str(Global.level) + "\nEnemies defeated: " + str(Global.enemies_defeated) + "\nCoins collected: " + str(Global.coins)

func _on_back_pressed():
	StateManager.change_state(0)
