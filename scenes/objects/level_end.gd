extends AnimatedSprite2D
class_name LevelEnd


@export var max_offset: Vector2


func _physics_process(delta: float) -> void:
	# random movements
	if GameManager.use_glitch:
		offset = Vector2(randf_range(-max_offset.x, max_offset.x),
						 randf_range(-max_offset.y, max_offset.y))
						

func end() -> void:
	await get_tree().create_timer(1.0).timeout
	get_parent().game_over(true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		end()
