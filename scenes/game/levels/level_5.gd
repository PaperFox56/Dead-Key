extends Level


func complete() -> void:
	GameManager.complete_current_level()
	GameManager.levels[id].shard = shard or GameManager.levels[id].shard
	call_deferred("load_final_screen")
	
func load_final_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/game/final_screen.tscn")
