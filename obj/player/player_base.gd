class_name Player
extends CharacterBody2D

const ACCELERATION: float = 450
const MAX_SPEED: float = 200
const FRICTION: float = 600

var latest_kid: int = 0
var kid_count: int = 1

var talking: bool = false

# trenchcoat left/right textures

var head_offsets: PackedInt32Array = [
	5, 5, 5, 5, 5, 5, # ponytails
	0, 0, 0, 0, 0, 4, # shaggy hair
	0,-1,-2, 0,-1,-1, # calvin
	1, 1, 1, 1, 1, 1, # poofy hair
	0, 0, 0, 0, 0,-2, # cameos 1
	-1,0,-1,-3, 1, 0, # cameos 2
	0, 0, 1,-1,-1, 1, # cameos 3
]

var trenchcoat_nodes: PackedVector2Array = []
var trenchcoat_node_count: int = 0

const trenchcoat_base_vec: Vector2 = Vector2(0, -22)
const trenchcoat_base_rotation: float = deg_to_rad(10)
const trenchcoat_rotation_divisor: float = 5

var trench_targ : float = 0
var trench_true_targ: float = 0

@onready var bubble_point: Marker2D = %BubbleMarker
@onready var interaction_zone: Area2D = $InteractionZone
@onready var head: Sprite2D = %Head
@onready var trenchcoat: Line2D = %Trenchcoat
@onready var sprite_single: Sprite2D = $SpriteSingle
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var trenchcoat_bottom: Sprite2D = $SpriteSingle/TrenchcoatBottom


var talk_delay: float = 0

func _ready() -> void:
	if trenchcoat_node_count <= 1:
		head.hide()
	else:
		head.show()
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.pressed:
			#match event.keycode:
				#KEY_PAGEDOWN:
					#change_trenchcoat_size(-1)
					##set_trenchcoat_target(trench_targ)
				#KEY_PAGEUP:
					#change_trenchcoat_size(1)
					##set_trenchcoat_target(trench_targ)
					##trenchcoat_nodes.resize(trenchcoat_node_count)
				#KEY_COMMA:
					#set_trenchcoat_target(-1)
				#KEY_PERIOD:
					#set_trenchcoat_target(1)
				#KEY_0:
					#set_trenchcoat_target(0)
					

func get_nearest_npc() -> NPCBase:
	var possible_npcs := interaction_zone.get_overlapping_areas()
	prints("possible", possible_npcs)
	var npcs: Array[NPCBase]
	for npc in possible_npcs:
		prints("group", npc.get_groups())
		if npc is NPCBase:
			npcs.append(npc)
	prints("npcs", npcs)
	if npcs.is_empty():
		return null
	npcs.sort_custom(
		func(a: NPCBase, b: NPCBase) -> bool: return (
			a.global_position.distance_to(global_position)
			< b.global_position.distance_to(global_position)
		)
	)
	return npcs[0]

func _process(delta: float) -> void:
	talk_delay -= delta
	trenchcoat_motion()
	if trenchcoat.points:
		head.position = sprite_single.to_local(trenchcoat.to_global(trenchcoat.points[-1]))
		#head.rotation = trenchcoat.points[-1].angle() + PI/2
		head.rotation = trenchcoat_node_count/trenchcoat_rotation_divisor * trenchcoat_base_rotation * trench_targ
	#if trench_true_targ != trench_targ:
		#if check_if_trenchcoat_at_target():
			#set_trenchcoat_target(trench_true_targ)

func change_trenchcoat_size(by: int) -> void:
	trenchcoat_node_count += by
	trenchcoat_nodes.resize(trenchcoat_node_count)
	Dialogic.VAR.set_variable("stacksize", trenchcoat_node_count)
	if trenchcoat_node_count <= 1:
		head.hide()
		trenchcoat_bottom.hide()
	else:
		head.show()
		trenchcoat_bottom.show()
	set_trenchcoat_target(trench_targ)

func set_trenchcoat_size(size: int) -> void:
	pass


func get_height() -> float:
	return max(32, abs(head.position.y - 32))


func add_kid(index: int) -> void:
	change_trenchcoat_size(1)
	head.frame = index


func set_facing(dir) -> void:
	if dir < 0:
		head.flip_h = false
		sprite_single.flip_h = false
	elif dir > 0:
		head.flip_h = true
		sprite_single.flip_h = true
	set_trenchcoat_target(-dir)


func talk_to_closest_npc() -> void:
	var npc: NPCBase = get_nearest_npc()
	if not npc:
		return
	state_machine.transition("Talk", {"npc": npc})


func set_trenchcoat_target(dir: float) -> void:
	trench_targ = dir
	#trenchcoat_nodes.resize(trenchcoat_node_count)
	#if dir != 0 and not check_if_trenchcoat_at_target():
		#trench_true_targ = dir
		#set_trenchcoat_target(0)
		##while not check_if_trenchcoat_at_target():
			##print("waiting")
			##pass # wait for it to reach the middle
		
	for point in trenchcoat_node_count:
		trenchcoat_nodes[point] = (
			(Vector2.ZERO if point == 0 else trenchcoat_nodes[point - 1]) +
			trenchcoat_base_vec.rotated(
				point/trenchcoat_rotation_divisor * trenchcoat_base_rotation * dir)
		)
	#print(trenchcoat_nodes)


func check_if_trenchcoat_at_target() -> bool:
	for point in trenchcoat.points.size():
		if not trenchcoat.points[point].is_equal_approx(trenchcoat_nodes[point]):
			return false
	return true


func trenchcoat_motion() -> void:
	if trenchcoat.points.size() == 0:
		trenchcoat.add_point(Vector2.ZERO)
	while trenchcoat.points.size() > trenchcoat_node_count: # while instead of if to accommadate bigger changes
		trenchcoat.remove_point(trenchcoat.points.size() - 1)
	while trenchcoat.points.size() < trenchcoat_node_count:
		trenchcoat.add_point(Vector2.ZERO)
		#print(trenchcoat.points, trenchcoat_node_count)
		if trenchcoat.points.size() < 3:
			for point in trenchcoat.points.size():
				trenchcoat.points[point] = trenchcoat_nodes[point]
		else:
			trenchcoat.points[-1] = trenchcoat.points[-2] + trenchcoat_base_vec.rotated(trenchcoat.points[-2].angle() + PI/2)
	for point in trenchcoat.points.size():
		#trenchcoat.points[point] = lerp(trenchcoat.points[point], trenchcoat_nodes[point], 20 * get_process_delta_time() * (1.0/point))
		trenchcoat.points[point] = lerp(trenchcoat.points[point], trenchcoat_nodes[point], 30 * get_process_delta_time() * (1.0/min(max(1,point), 15)))


func set_head(idx: int) -> void:
	head.frame = idx
	head.offset.x = head_offsets[idx]
