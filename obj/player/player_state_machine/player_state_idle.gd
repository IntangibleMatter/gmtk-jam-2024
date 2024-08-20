extends PlayerState


func _physics_update(delta: float) -> void:
	var movement_dir : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
	)
	#print("ASKJDHKASJHDKJASHDGK")
	if Input.is_action_just_pressed("talk_to"):
		if not player.talk_delay > 0:
			prints("talk", player.get_nearest_npc())
			player.talk_to_closest_npc()
	if player.velocity.is_zero_approx():
		player.anim_player.play("stand")
	if movement_dir == Vector2.ZERO:
		player.velocity = player.velocity.lerp(Vector2.ZERO, 0.5)
		#player.velocity = player.velocity.move_toward(Vector2.ZERO, player.FRICTION * delta)
	else:
		transition.emit("Move", {})
	
	player.move_and_slide()
	
