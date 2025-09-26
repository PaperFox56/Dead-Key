extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.start(8.0)
	
	timer.timeout.connect(on_timeout)

func _process(delta: float) -> void:
	texture_rect.material.set_shader_parameter("opacity", opacity(timer.time_left))

func opacity(time: float) -> float:
	return exp(-.3*(time-4.0)**2)
	
func on_timeout():
	get_tree().change_scene_to_file("res://scenes/game/home.tscn")
