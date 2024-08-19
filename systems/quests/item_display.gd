extends HBoxContainer

@export var text: String:
	set(n_text):
		text = n_text
		if not label:
			return
		label.text = text
@export var done: bool = false:
	set(n_done):
		done = n_done
		if not sprite:
			return
		sprite.frame = 1 if done else 0

@onready var sprite: Sprite2D = $IconContainer/Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
	label.text = text
	sprite.frame = 1 if done else 0
	#set_process(false)
