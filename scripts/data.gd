extends Node

const default_data: Dictionary = {}

var data: Dictionary = {}

var player_height: int = 1

func go_to_end() -> void:
	get_tree().change_scene_to_file("res://scenes/ending.tscn")


func get_player() -> Player:
	return get_tree().current_scene.find_child("PlayerBase")


func add_player_sprite(index: int) -> void:
	get_player().add_kid(index)


func remove_character(identifier: String) -> void:
	if not get_tree().current_scene.is_in_group("world"):
		return
	var node: Node = get_tree().current_scene.get_node("Interactables").find_child(identifier)
	if node:
		node.queue_free()

func save_game() -> void:
	pass


func load_game() -> void:
	pass
