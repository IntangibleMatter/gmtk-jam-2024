extends Node2D

@onready var collisionmap: TileMapLayer = $Tiles/collisionmap
@onready var camera: Camera2D = %Camera2D
@onready var player: Player = %PlayerBase

var updating_cam: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collisionmap.modulate = Color(0,0,0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not updating_cam:
		update_camera_size()


func update_camera_size() -> void:
	var ps: float = player.get_height()
	var sh: float = get_viewport().get_visible_rect().size.y
	prints("ratio", ps/sh)
	if ps/sh > 0.6:
		updating_cam = true
		var new_size: float = 270 /( 1.667 * ps )
		prints("ns", new_size)
		var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		await tween.tween_property(camera, "zoom", Vector2(new_size, new_size), 0.1)
		updating_cam = false
