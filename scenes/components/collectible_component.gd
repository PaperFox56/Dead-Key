class_name CollictibleComponent
extends Area2D

@export var collectible_name: String


signal on_collected(player: Player)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		on_collected.emit(body)
		$"../AudioStreamPlayer".play()
		await get_tree().create_timer(.3).timeout
		get_parent().queue_free()
