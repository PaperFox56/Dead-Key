extends AnimatedSprite2D

@export var memories: Dictionary = {
	"left": 0,
	"right": 0,
	"jump": 0,
	"memory":1
}

@onready var collectible_component: CollictibleComponent = $CollectibleComponent

func _ready() -> void:
	collectible_component.on_collected.connect(on_collected)
	
	
# Allow the player to receive the effect of the memory shard
func on_collected(player: Player) -> void:
	player.input_tracker.add_memories(memories)
	var level := get_parent() as Level
	level.shard = true
	
