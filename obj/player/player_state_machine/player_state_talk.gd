extends PlayerState

func _enter(msg: Dictionary = {}) -> void:
	var npc: NPCBase = msg.get("npc")
	player.velocity = Vector2.ZERO
	get_viewport().set_input_as_handled()
	
	if not npc:
		print("LEAVING TALK STATE")
		transition.emit("Idle", {})
	Dialogic.timeline_ended.connect(func() -> void: transition.emit("Idle", {}))
	npc.start_convo()
	
	
