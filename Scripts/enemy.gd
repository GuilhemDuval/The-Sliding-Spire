extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

var health : int = 3
var damage : int = 1
var attack_chance : float = 0.5

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func move() -> void:
	if randf() < 0.5:
		return
	
	var direction : Vector2
	var attempts := 0
	var max_attempts := 10
	
	while attempts < max_attempts:
		attempts += 1
		direction = get_random_direction()
		var destination = global_position + direction * 48
		
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, destination)
		var result = space_state.intersect_ray(query)
		
		if result and result.collider.is_in_group("Wall"):
			continue
		
		var shape := RectangleShape2D.new()
		shape.extents = Vector2(23, 23)
		
		var shape_query := PhysicsShapeQueryParameters2D.new()
		shape_query.shape = shape
		shape_query.transform = Transform2D(0, destination)
		shape_query.collision_mask = 1 
		
		var collisions := space_state.intersect_shape(shape_query)
		
		var overlap_with_player := false
		for c in collisions:
			if c.collider.is_in_group("Player"):
				overlap_with_player = true
				break
		
		if overlap_with_player:
			continue
		
		var blocked := false
		for e in get_tree().get_nodes_in_group("Enemy"):
			if e != self and e.global_position.distance_to(destination) < 1.0:
				blocked = true
				break
		if blocked:
			continue
		
		global_position = destination
		return

func get_random_direction() -> Vector2:
	return [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()

func take_damage(damage_taken: int) -> void:
	health -= damage_taken
	$SFX.stream = load("res://Assets/SFX/Hit.wav")
	$SFX.play()
	$AnimationPlayer.play("hit")
	
	if health <= 0:
		Global.enemies_defeated += 1
		queue_free()
	
	if randf() > attack_chance and player.global_position.distance_to(global_position) <= 48:
		player.take_damage(damage)
