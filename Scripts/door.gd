extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_key:
			Sfx.get_child(3).play()
			Global.level += 1
			Global.seed += randi_range(1, 40000)
			get_tree().reload_current_scene.call_deferred()
