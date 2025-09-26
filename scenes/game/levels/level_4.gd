extends Level

@onready var echo: Area2D = $Echo

func ready() -> void:
	echo.player_states = GameManager.levels["level_3"]["player_states"].duplicate()
