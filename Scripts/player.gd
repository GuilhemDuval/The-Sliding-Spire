extends CharacterBody2D

signal player_moved

var has_key : bool = false
var can_act := true

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func set_can_act(value: bool) -> void:
	can_act = value

func _physics_process(_delta: float) -> void:
	if can_act:
		player_input()

func player_input() -> void:
	if Input.is_action_just_pressed("move_right"):
		velocity = Vector2.RIGHT
		move(velocity)
	elif Input.is_action_just_pressed("move_up"):
		velocity = Vector2.UP
		move(velocity)
	elif Input.is_action_just_pressed("move_left"):
		velocity = Vector2.LEFT
		move(velocity)
	elif Input.is_action_just_pressed("move_down"):
		velocity = Vector2.DOWN
		move(velocity)

	if Input.is_action_just_pressed("attack_right"):
		try_attack(Vector2.RIGHT)
	elif Input.is_action_just_pressed("attack_left"):
		try_attack(Vector2.LEFT)
	elif Input.is_action_just_pressed("attack_up"):
		try_attack(Vector2.UP)
	elif Input.is_action_just_pressed("attack_down"):
		try_attack(Vector2.DOWN)

func move(direction : Vector2) -> void:
	var destination = global_position + direction * 48
	
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var query = PhysicsRayQueryParameters2D.create(global_position, destination)
	var result = space_state.intersect_ray(query)
	if result and result.collider.is_in_group("Wall"):
		return
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.global_position == destination:
			return
	
	global_position = destination
	can_act = false
	player_moved.emit()
	$SFX.stream = load("res://Assets/SFX/walk.wav")
	$SFX.play()

func try_attack(direction : Vector2) -> void:
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + direction * 48)
	var result = PhysicsServer2D.space_get_direct_state(get_world_2d().space).intersect_ray(query)
	
	if result and result.collider.is_in_group("Enemy"):
		result.collider.take_damage(1)
		can_act = false
		player_moved.emit()

func take_damage(damage_taken: int) -> void:
	Global.health -= damage_taken
	print(Global.health)
	$SFX.stream = load("res://Assets/SFX/Hit.wav")
	$SFX.play()
	$AnimationPlayer.play("hit")
	if Global.health <= 0:
		StateManager.change_state(3)
