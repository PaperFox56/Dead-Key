extends Node2D
class_name Level

@export var id: String
@export var player: Player

@export_range(1, 10) var memory := 1
@export_range(0, 5) var left := 0
@export_range(0, 5) var right := 0
@export_range(0, 5) var jumps := 0
@export_range(0, 5) var glitches := 0

var shard = false

# to be overwritten
func ready():
	pass
	
func physics_process(delta: float) -> void:
	pass

func _ready() -> void:
	var input_tracker: InputTracker = player.input_tracker
	player.glitches_used = 3 - glitches
	input_tracker.glitches_used = player.glitches_used
	input_tracker.set_memories({
		"left": left,
		"right": right,
		"jump": jumps,
		"memory": memory
	})
	
	ready()
	
func _physics_process(delta: float) -> void:
	physics_process(delta)
	
func game_over(win: bool):
	if !win:
		restart()
	else:
		complete()

func restart() -> void:
	call_deferred("reload")
	
func reload():
	GameManager.load_level(id)
	
	
func complete() -> void:
	GameManager.complete_current_level()
	GameManager.levels[id].shard = shard or GameManager.levels[id].shard
	call_deferred("load_level_select")
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		call_deferred("load_level_select")
	
func load_level_select():
	get_tree().change_scene_to_file("res://scenes/game/level_select.tscn")
