extends Area2D

@export var dialogue: DialogicTimeline
@export var char_name: String
@onready var label: Label = $LabelBase/Label


func _ready() -> void:
	label.hide()
	label.text = char_name
	await get_tree().process_frame
	label.position.x = -label.size.x/2


func _on_area_entered(area: Area2D) -> void:
	if area.owner is Player:
		label.show()


func _on_area_exited(area: Area2D) -> void:
	if area.owner is Player:
		label.hide()
