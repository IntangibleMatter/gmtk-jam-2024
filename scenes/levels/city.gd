extends Node2D

@onready var collisionmap: TileMapLayer = $Tiles/collisionmap
@onready var camera: Camera2D = %Camera2D
@onready var player: Player = %PlayerBase
@onready var interactables: Node2D = $Interactables
@onready var cam_transform: RemoteTransform2D = $PlayerBase/CamTransform


var cam_scale: float = 1.0
var updating_cam: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collisionmap.modulate = Color(0,0,0,0)
	Dialogic.timeline_started.connect(camera_cutscene)
	Dialogic.timeline_ended.connect(end_camera_cutscene)
	Dialogic.Text.speaker_updated.connect(update_target_char)
	for child in interactables.get_children():
		if child.has_signal("dialogue_started"):
			child.dialogue_started.connect(register_characters_in_dialogue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not updating_cam:
		update_camera_size()


func camera_cutscene() -> void:
	camera.position_smoothing_enabled = true
	camera.scale = Vector2.ONE
	cam_transform.remote_path = ""
	camera.global_position = player.find_child("BubbleMarker").global_position


func end_camera_cutscene() -> void:
	cam_transform.remote_path = "../../Camera2D"


func update_target_char(char: DialogicCharacter) -> void:
	var cname: String = char.display_name
	var target_char: Node2D
	var target: Vector2
	if cname in ["Finn", "Player"]:
		target_char = player
	else:
		target_char = interactables.get_node_or_null(cname)
	
	if target_char:
		var marker: Node2D = target_char.find_child("BubbleMarker")
		if not marker:
			camera.global_position = target_char.global_position
		else:
			camera.global_position = marker.global_position
		#camera.global_position = target_char.find_child("BubbleMarker").global_position


func register_characters_in_dialogue(dianode: Node) -> void:
	dianode.register_character(load("res://resources/dialogic/characters/Finn.dch"), player.find_child("BubbleMarker"))
	for child in interactables.get_children():
		if FileAccess.file_exists("res://resources/dialogic/characters/%s.dch" % child.Name):
			dianode.register_character(load("res://resources/dialogic/characters/%s.dch" % child.Name), child.find_child("BubbleMarker"))
		


func update_camera_size() -> void:
	var ps: float = player.get_height()
	var sh: float = get_viewport().get_visible_rect().size.y
	#prints("ratio", ps/sh)
	if ps/sh > 0.6:
		updating_cam = true
		var new_size: float = 270 /( 1.667 * ps )
		cam_scale = new_size
		#prints("ns", new_size)
		var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(cam_transform, "position:y", -player.get_height()/2, 0.2)
		await tween.tween_property(camera, "zoom", Vector2(new_size, new_size), 0.2)
		updating_cam = false
