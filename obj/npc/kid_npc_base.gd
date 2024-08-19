@tool
extends NPCBase

@export_range(0, 41) var kid_index: int = 0:
	set(idx):
		kid_index = idx
		if not sprite:
			return
		#if not sprite.is_node_ready():
			#await sprite.ready
		sprite.frame = idx
@export var flipped: bool = false:
	set(flip):
		flipped = flip
		if not sprite:
			return
		#if not sprite.is_node_ready():
			#await sprite.ready
		sprite.flip_h = flip


func _ready() -> void:
	super()
	sprite.frame = kid_index
	sprite.flip_h = flipped
