@tool
class_name PlacableNPC
extends NPCBase

@export var texture: Texture2D:
	set(n_tex):
		texture = n_tex
		if not sprite:
			return
		sprite.texture = texture
@export var texture_offset: Vector2 = Vector2.ZERO:
	set(n_off):
		texture_offset = n_off
		if not sprite:
			return
		sprite.offset = texture_offset


func _ready() -> void:
	super()
	sprite.texture = texture
	sprite.offset = texture_offset
