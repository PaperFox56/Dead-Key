extends Area2D

@export var player: Player
@export var use_preprogramed_data: bool
@export var delay: float

var player_states: Array = []

func _physics_process(delta: float) -> void:
	if !use_preprogramed_data:
		# record the state of the player
		player_states.push_back({
			"position": player.global_position,
			"direction": player.animated_sprite_2d.flip_h
			}
		)
	
	if Time.get_ticks_msec() < delay * 1000:
		return
		
	var state = player_states.pop_front()
	if state == null and use_preprogramed_data: 
		## The echo reached the memory core first
		get_parent().game_over(false)
		return
	global_position = state.position
	$Sprite2D.flip_h = state.direction
