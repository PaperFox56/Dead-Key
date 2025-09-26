class_name Player
extends CharacterBody2D

@export var fall_speed: float = 1.0

@export var jump_cut_gravity := 2.5  # How much stronger gravity is after releasing jump
@export var normal_gravity := 1.0    # Restore gravity when falling normally

@export var max_glitches := 3

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var screen_glitch: ColorRect = $HUD/ScreenGlitch
@onready var input_tracker: InputTracker = $InputTracker

var glitches_used := 0

# Jump helpers
const COYOTE_TIME := 0.1
const JUMP_BUFFER_TIME := 0.1

var is_jumping: bool = false
var coyote_time_left: float = 0.0
var jump_buffer_left: float = 0.0

var player_direction: Vector2 = Vector2.ZERO
var gravity_acceleration: Vector2 = Vector2(0, 1)
var delta_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Apply gravity normally
	var effective_gravity = gravity_acceleration * fall_speed

	# Apply stronger gravity if jump was cut early
	if is_jumping and !Input.is_action_pressed("jump") and velocity.y < 0:
		effective_gravity *= jump_cut_gravity  # More gravity = faster fall
	
	delta_velocity += effective_gravity * delta
	velocity = delta_velocity

	# Timers for coyote/jump buffering
	if !is_on_floor():
		coyote_time_left = max(coyote_time_left - delta, 0)
	else:
		coyote_time_left = COYOTE_TIME
		delta_velocity.y = min(delta_velocity.y, 0)
		reset_jump()
	
	jump_buffer_left = max(jump_buffer_left - delta, 0)

	move_and_slide()
	
	# Glitches
	if Input.is_action_just_pressed("use_glitch"):
		trigger_glitch()
		
	# Some tests to ensure that the game is playable
	if global_position.y > 2000 or Input.is_key_pressed(KEY_R):
		get_parent().restart()
	
	if velocity.y != 0:
		if $StateMachine/Walk.walk_animation_playing:
			animated_sprite_2d.stop()
			$StateMachine/Walk.walk_animation_playing = false
		animated_sprite_2d.play("jump")
	
func can_use_jump() -> bool:
	return input_tracker.can_use_jump() and is_on_floor()

func can_move_left() -> bool:
	return input_tracker.can_move_left()

func can_move_right() -> bool:
	return input_tracker.can_move_right()

func can_glitch() -> bool:
	return glitches_used < max_glitches and input_tracker.memory > 0

func trigger_glitch():
	print(glitches_used < max_glitches)
	if !can_glitch():
		return
	
	glitches_used += 1
	input_tracker.glitches_used += 1
	input_tracker.memory -= 1
	input_tracker.hud_reference.update_data(input_tracker)
	input_tracker.hud_reference.reduce_screen_integrity(1) 
	
	# Temporarily disable collision with tiles
	set_collision_mask_value(5, false)  # assuming layer 1 is for TileMap
	
	# Optional: Visual feedback
	
	animated_sprite_2d.material.set_shader_parameter("glitch_active", true)
	create_tween().tween_callback(Callable(self, "end_glitch")).set_delay(1.0)
	
func end_glitch():
	set_collision_mask_value(5, true)
	animated_sprite_2d.material.set_shader_parameter("glitch_active", false)

func consume_input(action: String) -> void:
	input_tracker.consume_input(action)

func register_jump_input():
	jump_buffer_left = JUMP_BUFFER_TIME

func reset_jump():
	is_jumping = false
