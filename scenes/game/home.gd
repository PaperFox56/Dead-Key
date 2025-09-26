extends CanvasLayer

func _ready() -> void: 
	
	$CheckButton.button_pressed = GameManager.use_glitch
	var memory_display = ""
	for i in range(GameManager.memory_total):
		memory_display +=  ("▣" if OS.get_name() != "Web" else "+") if (i < GameManager.memory) else ("▢" if OS.get_name() != "Web" else "-")
	$Home/MemoryBar/MemoryDisplay.text = "MEMORY: " + memory_display


func _on_start_pressed():
	if GameManager.levels["level_1"].completed:
		$MarginContainer.visible = true
	else:
		get_tree().change_scene_to_file("res://scenes/game/intro_scene.tscn")

func _on_select_memories_pressed():
	get_tree().change_scene_to_file("res://scenes/game/level_select.tscn")

func _on_quit_pressed():
	get_tree().quit()


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.toggle_glitch_effect(toggled_on)


func _on_yes_pressed() -> void:
	GameManager.reset_progress()
	GameManager.show_briefing("level_1")


func _on_no_pressed() -> void:
		$MarginContainer.visible = false
