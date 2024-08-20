extends NPCBase

@export var texture: Texture2D:
	set(n_tex):
		texture = n_tex
		if not sprite:
			return
		sprite.texture = texture


func _ready() -> void:
	super()
	sprite.texture = texture
