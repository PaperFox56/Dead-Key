class_name GameInputEvents

static var direction: Vector2
static var jump_pressed: bool

static func movement_input() -> Vector2:
	if Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO
		
	return direction

static func is_movement_input() -> bool:
	if direction == Vector2.ZERO and !Input.is_action_pressed("jump"):
		return false
	else:
		return true

static func use_glitch() -> bool:
	return Input.is_action_just_pressed("use_glitch")
 
