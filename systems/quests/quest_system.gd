extends Node

@export var quests: Dictionary = {
	"q_basketball": "Get the basketball from the tree",
	"q_berry": "Get a strawberry for Madeline",
	"q_broom": "Get a broom for Miriam",
	"q_bug": "Find a cool bug for Kiwi",
	"q_choco": "Get some Chocolate for Chara",
	"q_comic": "Get the last GALAXY HIKE Comic from Alex for James",
	"q_cookie": "Get a cookie for Lancer",
	"q_figure": "Get Alex's action figure for ???",
	"q_fakeid": "Get the Fake ID from the kid in the Tallest Tower",
	"q_letter": "Give Alex's letter to Steve",
	"q_money": "Get James' money",
}

const ITEM_DISPLAY: PackedScene = preload("res://systems/quests/item_display.tscn")

@onready var item_list: VBoxContainer = %ItemList
@onready var toast: Sprite2D = $Toast
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var menu: CanvasLayer = $Menu

var in_dialogue: bool = false


func _ready() -> void:
	if not Dialogic.is_node_ready():
		await get_tree().process_frame

	Dialogic.VAR.variable_changed.connect(update_quests)
	Dialogic.timeline_started.connect(func() -> void: in_dialogue = true)
	Dialogic.timeline_ended.connect(func() -> void: in_dialogue = false)


func _unhandled_input(event: InputEvent) -> void:
	if get_tree().current_scene:
		if not get_tree().current_scene.is_in_group("world"):
			return
	if Dialogic:
		pass
	if event.is_action_pressed("open_tasks"):
		if menu.visible:
			#get_viewport()
			menu.hide()
			Data.get_player().state_machine.transition("Idle", {})
		else:
			menu.show()
			Data.get_player().state_machine.transition("Talk", {"force_stay": true})
			#get_viewport().set_input_as_handled()


func update_quests(info: Dictionary) -> void:
	if info.variable == "stacksize":
		return
	var node: Control = item_list.get_node_or_null(info.variable)
	if not node:
		node = ITEM_DISPLAY.instantiate()
		node.script = load("res://systems/quests/item_display.gd")
		await get_tree().process_frame
		prints(node)
		node.name = info.variable
		node.text = quests.get(info.variable, info.variable)
		item_list.add_child(node)
		#node = n_item

	match info.new_value:
		1:
			node.show()
			node.done = false
			toast.frame = 1
			anim_player.play("notify")
		2:
			node.show()
			node.done = true
			toast.frame = 0
			anim_player.play("notify")
		0, _:
			node.hide()
			node.done = false


func store_fade() -> void:
	anim_player.play("store_fade")
