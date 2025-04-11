extends Control

func _ready():
	$Intro/Buttons/Stats.text = "Level reachead: " + str(Global.level) + "\nEnemies defeated: " + str(Global.enemies_defeated) + "\nCoins collected: " + str(Global.coins)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
