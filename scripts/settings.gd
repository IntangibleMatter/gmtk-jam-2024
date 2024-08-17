extends Node

const SETTINGS_PATH: String = "user://settings.cfg"

const default_settings: Dictionary = {
	"volume": 1.0,
	"volume_sfx": 1.0,
	"volume_mus": 1.0,
}
var settings: Dictionary = {}


func set_volume(type: String, to: float) -> void:
	var as_db: float = linear_to_db(to)
	match type:
		"master":
			AudioServer.set_bus_volume_db(0, as_db)
			settings["volume"] = to
		"sfx":
			AudioServer.set_bus_volume_db(1, as_db)
			settings["volume_sfx"] = to
		"mus":
			AudioServer.set_bus_volume_db(2, as_db)
			settings["volume_mus"] = to


func load_settings() -> void:
	pass


func apply_all_settings() -> void:
	set_volume("master", settings["volume"])
	set_volume("sfx", settings["volume_sfx"])
	set_volume("mus", settings["volume_mus"])
