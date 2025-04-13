extends Node

var enemies : Array
var player : CharacterBody2D

var action_pending := false
var enemy_timer : Timer

const ENEMY_DELAY := 0.25

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("player_moved", Callable(self, "on_player_action"))
	check_enemies()

func check_enemies() -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")

func on_player_action() -> void:
	if action_pending:
		if is_instance_valid(enemy_timer):
			enemy_timer.stop()
		do_enemy_turn()
	else:
		action_pending = true
		enemy_timer = Timer.new()
		enemy_timer.wait_time = ENEMY_DELAY
		enemy_timer.one_shot = true
		enemy_timer.connect("timeout", Callable(self, "do_enemy_turn"))
		add_child(enemy_timer)
		enemy_timer.start()

func do_enemy_turn() -> void:
	action_pending = false
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.move()
	player.set_can_act(true)
