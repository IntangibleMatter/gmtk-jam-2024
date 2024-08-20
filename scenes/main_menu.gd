extends CanvasLayer

@onready var line: Line2D = $Line2D

var elapsed: float = 0
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	for i in 60:
		line.add_point(Vector2(0, i * 5))


func _process(delta: float) -> void:
	elapsed += delta
	
	for point in line.points.size():
		line.set_point_position(point, Vector2(sin(elapsed + point/7.0) * 32.0, line.points[point].y))
	
	sprite.global_position = line.to_global(line.points[0])
	sprite.rotation = line.points[1].angle_to_point(line.points[0]) + PI/2


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/city.tscn")
