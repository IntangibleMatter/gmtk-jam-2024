extends PlayerState


func _physics_process(delta: float) -> void:
	var movement_dir : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
	)
	if player.velocity.is_zero_approx():
		player.anim_player.play("stand")
	if movement_dir == Vector2.ZERO:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.FRICTION * delta)
	else:
		transition.emit("Move", {})
	
	player.move_and_slide()
	
