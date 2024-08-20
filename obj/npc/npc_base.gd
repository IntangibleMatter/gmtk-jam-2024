@tool
class_name NPCBase
extends Area2D

signal dialogue_started(dialogue_node: Node)

@export var dialogue: DialogicTimeline
@export var char_name: String:
	set(n_name):
		char_name = n_name
		if not label:
			return
			#await label.ready
		label.text = char_name
		label.size.x = 0
		await get_tree().process_frame
		label.position.x = -label.size.x/2
@export_range(-64, 0, 1) var label_offset: float = -32:
	set(n_label_offset):
		label_offset = n_label_offset
		if not label:
			return
		#if not label_base.is_node_ready():
			#await label_base.ready
		label_base.position.y = label_offset

@export_range(-512, 10, 1) var bubble_marker_offset: float = -32:
	set(n_marker_offset):
		bubble_marker_offset = n_marker_offset
		if not bubble_marker:
			return
		#if not bubble_marker.is_node_ready():
			#await bubble_marker.ready
		bubble_marker.position.y = bubble_marker_offset

@onready var label: Label = $LabelBase/Label
@onready var sprite: Sprite2D = $Sprite2D
@onready var label_base: Node2D = $LabelBase
@onready var bubble_marker: Marker2D = $BubbleMarker



func _ready() -> void:
	#prints("label", label)
	label.hide()
	label.text = char_name
	label.size.x = 0
	await get_tree().process_frame
	await get_tree().process_frame
	#prints('labelsize', label.size)
	label.position.x = -label.size.x/2
	bubble_marker.position.y = bubble_marker_offset
	label_base.position.y = label_offset
	#label.text = char_name
	#label.size.x = 0
	#await get_tree().process_frame
	#label.position.x = -label.size.x/2


func _on_area_entered(area: Area2D) -> void:
	prints("entered", area, area.owner, area.owner is Player)
	if area.owner is Player:
		label.show()


func _on_area_exited(area: Area2D) -> void:
	prints("exited", area, area.owner)
	if area.owner is Player:
		label.hide()


func start_convo() -> void:
	var convonode := Dialogic.start(dialogue)
	dialogue_started.emit(convonode)
	label.hide()
	await Dialogic.timeline_ended
	label.show()
