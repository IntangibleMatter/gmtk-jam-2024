extends PlayerState

var force_stay: bool = false

func _enter(msg: Dictionary = {}) -> void:
	force_stay = msg.get("force_stay", false)
	var npc: NPCBase = msg.get("npc")
	player.velocity = Vector2.ZERO
	player.anim_player.play("stand")
	
	Dialogic.timeline_ended.connect(
		func() -> void: 
			transition.emit("Idle", {})
			player.talk_delay = 0.75
	)
	
	if not npc:
		if not force_stay:
			print("LEAVING TALK STATE")
			transition.emit("Idle", {})
		return
	
	get_viewport().set_input_as_handled()

	npc.start_convo()
