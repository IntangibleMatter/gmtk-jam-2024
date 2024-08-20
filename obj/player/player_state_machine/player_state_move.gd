extends PlayerState


func _physics_update(delta: float) -> void:
	var movement_dir : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
	)
	
	if Input.is_action_just_pressed("talk_to"):
		if not player.talk_delay > 0:
			prints("talk", player.get_nearest_npc())
			player.talk_to_closest_npc()
	if movement_dir == Vector2.ZERO:
		transition.emit("Idle", {})
	else:
		player.velocity += movement_dir * player.ACCELERATION * delta
	if player.velocity.length() > player.MAX_SPEED:
		player.velocity = player.velocity.normalized() * player.MAX_SPEED
	
	if movement_dir.x != 0:
		#player.set_trenchcoat_target(-movement_dir.x)
		player.set_facing(movement_dir.x)
	
	player.anim_player.play("walk")
	player.move_and_slide()
