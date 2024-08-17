class_name StateMachine
extends Node

signal transitioned(to: String)

@export_node_path("State") var initial_state : NodePath

@onready var state : State = get_node(initial_state)

func _ready() -> void:
	if not owner.is_node_ready():
		await owner.ready
	
	for child in get_children():
		child.machine = self
		prints(child, child.script.resource_path)
	
	print(state)
	
	state.transition.connect(transition)
	state._enter()


func _process(delta: float) -> void:
	state._update(delta)


func _physics_process(delta: float) -> void:
	state._physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	state._handle_input(event)


func transition(to: String, msg := {}) -> void:
	#prints("attempting to transition to", to)
	if not has_node(to):
		return
	
	state._exit()
	state.transition.disconnect(transition)
	state = get_node(to)
	state.transition.connect(transition)
	state._enter(msg)
	#prints("transitioned to", to)
	emit_signal("transitioned", to)
