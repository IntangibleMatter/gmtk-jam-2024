class_name Player
extends CharacterBody2D

const ACCELERATION: float = 320
const MAX_SPEED: float = 80
const FRICTION: float = 120

var latest_kid: int = 0
var kid_count: int = 1

var talking: bool = false


@onready var bubble_point: Marker2D = %BubblePoint
@onready var interaction_zone: Area2D = $InteractionZone


func get_nearest_npc() -> NPCBase:
	var possible_npcs := interaction_zone.get_overlapping_areas()
	var npcs: Array[NPCBase]
	for npc in npcs:
		if npc is NPCBase:
			npcs.append(npc)
	
	if npcs.is_empty():
		return null
	npcs.sort_custom(
		func(a: NPCBase, b: NPCBase) -> bool:
			return (a.global_position.distance_to(global_position) < 
			b.global_position.distance_to(global_position))
	)
	return npcs[0]


func talk_to_closest_npc() -> void:
	var npc: NPCBase = get_nearest_npc()
	if not npc:
		return
	
	npc.start_convo()
