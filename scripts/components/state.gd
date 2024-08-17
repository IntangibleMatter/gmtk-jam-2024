class_name State
extends Node

signal transition(to: String, msg: Dictionary)

var machine : StateMachine

func _enter(msg := {}) -> void:
	pass


func _handle_input(_event: InputEvent) -> void:
	pass


func _update(_delta: float) -> void:
	pass


func _physics_update(_delta: float) -> void:
	pass


func _exit() -> void:
	pass
