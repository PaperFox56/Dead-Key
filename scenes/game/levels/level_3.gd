extends Level


var player_states: Array = []

func _enter_tree() -> void:
	player_states = []

func physics_process(delta: float) -> void:
	# record the state of the player
	player_states.push_back({
		"position": player.global_position,
		"direction": player.animated_sprite_2d.flip_h
		}
	)
	
func complete():
	GameManager.levels["level_3"]["player_states"] = player_states
	GameManager.complete_current_level()
	call_deferred("load_level_select")
