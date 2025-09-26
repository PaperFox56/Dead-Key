class_name InputTracker
extends Node

@onready var hud_reference = get_parent().get_node("HUD")

@export var max_memories := 5
@export var jump_limit := 5
@export var left_limit := 5
@export var right_limit := 5
@export var max_glitches := 3

@onready var memory := max_memories
var jumps_used := 0
var left_used := 0
var right_used := 0
var glitches_used := 0

func _ready() -> void:
	await get_tree().physics_frame
	if hud_reference:
		hud_reference.update_data(self)

func add_memories(memories: Dictionary) -> void:
	left_used = clamp(left_used - memories["left"], 0, left_limit)
	right_used = clamp(right_used - memories["right"], 0, right_limit)
	jumps_used = clamp(jumps_used - memories["jump"], 0, jump_limit)
	memory = clamp(memory + memories["memory"], 0, max_memories)
	hud_reference.update_data(self)
	
func set_memories(memories: Dictionary) -> void:
	left_used = clamp(left_limit - memories["left"], 0, left_limit)
	right_used = clamp(left_limit - memories["right"], 0, right_limit)
	jumps_used = clamp(left_limit - memories["jump"], 0, jump_limit)
	memory = clamp(memories["memory"], 0, max_memories)
	hud_reference.update_data(self)

func can_use_jump() -> bool:
	return jumps_used < jump_limit and memory > 0

func can_move_left() -> bool:
	return left_used < left_limit and memory > 0

func can_move_right() -> bool:
	return right_used < right_limit and memory > 0


func consume_input(action: String) -> void:
	if memory <= 0:
		return

	match action:
		"jump":
			if jumps_used < jump_limit:
				jumps_used += 1
				memory -= 1
		"left":
			if left_used < left_limit:
				left_used += 1
				memory -= 1
		"right":
			if right_used < right_limit:
				right_used += 1
				memory -= 1
				
	# Call UI update here if reference is available
	if hud_reference:
		hud_reference.update_data(self)
