@tool
extends NPCBase

@export_range(0, 41) var kid_index: int = 0:
	set(idx):
		kid_index = idx
		sprite.frame = idx
@export var flipped: bool = false:
	set(flip):
		flipped = flip
		sprite.flip_h = flip
