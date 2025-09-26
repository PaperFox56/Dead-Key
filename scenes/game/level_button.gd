extends Button

@export var level_id: String = ""

func _ready():
	text = GameManager.levels[level_id].name
	disabled = !GameManager.levels[level_id].unlocked
	$TextureRect.visible = GameManager.levels[level_id].shard

func _on_pressed():
	GameManager.show_briefing(level_id)
	
