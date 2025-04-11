extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Sfx.get_child(3).play()
		body.has_key = true
		queue_free()
