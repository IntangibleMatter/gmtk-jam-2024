extends PlayerState

func _enter(msg: Dictionary = {}) -> void:
	player.velocity = Vector2.ZERO
