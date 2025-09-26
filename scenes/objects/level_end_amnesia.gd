extends LevelEnd

@onready var label: Label = $"../Label"


func _ready() -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if $"../Player/HUD".current_memory > 0:
			$Label.visible = true
		else:
			queue_free()
			call_deferred("end")	
