extends CanvasLayer

func _ready():
	var list = $MarginContainer/Buttons
	# clear if regenerating
	for b: Button in list.get_children():
		b.queue_free()
	for id in GameManager.levels.keys():
		var data = GameManager.levels[id]
		var btn = preload("res://scenes/ui/level_button.tscn").instantiate()
		btn.level_id = id
		list.add_child(btn)

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/home.tscn")
