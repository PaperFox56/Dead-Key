extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50
@export var jump_force: float = 150.0

@export var acceleration := 800
@export var deceleration := 500

var left_was_pressed := false
var right_was_pressed := false

var walk_animation_playing = false

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()

	if direction.x != 0 and (player.is_on_floor() or abs(player.velocity.x) < 5):
		player.player_direction = direction
		animated_sprite_2d.flip_h = player.player_direction.x < 0

	var current_speed = player.delta_velocity.x
	var target_speed = 0

	# Movement
	if direction.x < 0 and player.can_move_left():
		left_was_pressed = true
		target_speed = direction.x * speed
	elif Input.is_action_just_released("walk_left") and left_was_pressed:
		player.consume_input("left")
		left_was_pressed = false
		
	if direction.x > 0 and player.can_move_right():
		left_was_pressed = true
		target_speed = direction.x * speed
	elif Input.is_action_just_released("walk_right") and left_was_pressed:
		player.consume_input("right")
		left_was_pressed = true
	player.delta_velocity.x = move_toward(player.delta_velocity.x, target_speed, (acceleration if (target_speed > 0) else deceleration)
	 * _delta)

	# Jump input
	if Input.is_action_pressed("jump"):
		player.register_jump_input()

	if player.jump_buffer_left > 0 and player.coyote_time_left > 0 and player.can_use_jump():
		player.consume_input("jump")
		player.delta_velocity.y = -jump_force
		player.is_jumping = true
		player.jump_buffer_left = 0
		player.coyote_time_left = 0
		
	if player.velocity.y != 0:
		if walk_animation_playing:
			animated_sprite_2d.stop()
			walk_animation_playing = false
		animated_sprite_2d.play("jump")
	elif abs(player.velocity.x) > 0 and !walk_animation_playing:
		animated_sprite_2d.play("walk")
		walk_animation_playing = true
	else:
		animated_sprite_2d.stop()
		walk_animation_playing = false


func _on_next_transitions() -> void:
	if player.velocity.x == 0 and !player.is_jumping:
		transition.emit("Idle")

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	animated_sprite_2d.stop()
