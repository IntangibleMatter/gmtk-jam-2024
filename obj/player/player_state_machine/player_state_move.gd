extends PlayerState


func _physics_update(delta: float) -> void:
	var movement_dir : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
	)
	
	if movement_dir == Vector2.ZERO:
		transition.emit("Idle", {})
	else:
		player.velocity += movement_dir * player.ACCELERATION * delta
	if player.velocity.length() > player.MAX_SPEED:
		player.velocity = player.velocity.normalized() * player.MAX_SPEED
	
	
	player.move_and_slide()
