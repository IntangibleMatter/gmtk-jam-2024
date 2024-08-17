extends PlayerState

func _physics_update(delta: float) -> void:
	var movement_dir : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
	)
